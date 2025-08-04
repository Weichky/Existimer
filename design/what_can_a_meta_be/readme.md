# What Can A Meta Be?
### Before Reading
整理了Existimer开发第0阶段的设计思路。这是本系列第一篇讨论，主要讨论了实体与任务的关系，元数据和任务的存在形式。

在**重构**以前的均是初版讨论，思路不清晰明朗，但有大致的方向。大可直接跳至重构部分阅读。

----
目前是将TimerUnit保存为final的TimerUnitSnapshot后，再存入数据库的. 其唯一标识是uuid，也是读取和保存的凭据. 基于这点，作了如下的讨论。

### Meta的身份

Meta的目的是什么？为了以后的笔记、计次任务等，以及历史统计的方便. 不是一个一定要有的东西，不是核心要素. 主要区别在于，不涉及业务逻辑，往往只是自动读写，而且内容会比较大. 



我们可以建立一个MetaBase基类，在其之上派生出其他Meta类. 这里又引发了一个问题：负责统计历史、备注和笔记内容等的Meta，应该是同一个Meta么？

### TimerUnit的一致性

我们考察一个应用场景. 用户最初建立了一个倒计时TimerUnit a. 在数次倒计时后，查看总计时间，或者过往历史. 然后在某次计时之后，a变成了正向计时，又进行了几次. 如果用户始终在为同一件事情计时，那么时间应该累加. 这就要求我们以a.uuid为标准，统计呈现数据，同时把这几次行为冠以相同的名字（Task）.



再考察另外一件事情. 用户在两个平台同时进行了名称为A的Task，分别有TimerUnit a1和a2. 显然a1和a2的uuid几乎不可能相同. 起初两平台相安无事，直到用户在a2所在的设备需要合并两平台数据. 我们应当假设用户的目的么？最好不要这样做. 这里天然的就有三种选择：

- 1）合并a1和a2的Task不加区别
- 2）继续保持a1和a2 Task的不同
- 3）以其中一方为准，舍弃另一个

其中1和3都好说，因为最终保证了Task的唯一性. 如果用户是多人协同，需要区分不同人的Task，但是他们都从事同名的实际事物，如果强行让用户重命名以区分Task莫过于太丑陋. 最好是以备注的形式存在. 这样就要求Task也有各自的uuid以相互区分. 在上面的3种情况下，若A1记录a1.uuid，A2记录a2.uuid，会有

- 1）A2记录a1.uuid和a2.uuid
- 2）保持，(A1.name == A2.name) == true
- 3）A2记录a2.uuid

其中1如何优雅的同时记录a1.uuid和a2.uuid是个问题.  天然的，我们想到在Task中添加JSON字段. 不过建立一个映射表可能是更好的选择.

```sql
CREATE TABLE Task {
  uuid TEXT PRIMARY KEY
  --- ... 其他字段
}

CREATE TABLE TimerUnit {
  uuid TEXT PRIMARY KEY
  --- ... 其他字段
}

CREATE TABLE TaskMapping {
  taskUuid TEXT,
  entityUuid TEXT,
  PRIMARY KEY (taskUuid, timerUuid) --- 组合主键（composite primary key）
}
```

看起来我们要维护另外一个表，希望这是值得的. 

### 重构

我们可以以一个实际例子切入：用户 A 创建了一个名为“考研数学复习”的任务，打算围绕这个任务进行若干种操作，包括计时、记录备注、打卡等。起初，用户只是创建了一个 `TimerUnit`：

```dart
final timer = TimerUnit(
  uuid: generateUuid(),
  startAt: Clock.instance.now(),
  duration: Duration(minutes: 45),
  mode: TimerMode.countdown,
);
```

过去我们会考虑是否要为这个 TimerUnit 添加一个 Meta，例如总计时间、历史次数、备注等。于是一个候选方案可能是：

```dart
final meta = TimerMeta(
  timerUuid: timer.uuid,
  totalDuration: Duration(hours: 5),
  notes: ['效率不错', '状态一般'],
);
```

但很快我们意识到，这种以实体为主导的扩展路径，天然地与任务语义脱节。用户真正关心的并不是某一个计时片段的备注，而是整个“考研数学复习”任务的状态演变。于是我们需要一种方式，让所有行为围绕这个任务聚合。

这时候，引入 `Task` 实体就成为一种自然的做法：

```dart
final task = Task(
  uuid: generateUuid(),
  name: '考研数学复习',
  createdAt: Clock.instance.now(),
);
```

然后通过一条映射关系，将 `TimerUnit` 与 `Task` 关联起来：

```dart
final mapping = TaskMapping(
  taskUuid: task.uuid,
  entityUuid: timer.uuid,
  entityType: 'timer',
);
```

这种关系在数据库中可以采用如下结构：

```sql
CREATE TABLE Task (
  uuid TEXT PRIMARY KEY,
  name TEXT,
  createdAt INTEGER,
  ...
);

CREATE TABLE TimerUnit (
  uuid TEXT PRIMARY KEY,
  startAt INTEGER,
  duration INTEGER,
  ...
);

CREATE TABLE TaskMapping (
  taskUuid TEXT,
  entityUuid TEXT,
  entityType TEXT,
  PRIMARY KEY (taskUuid, entityUuid)
);
```

未来用户新增一条备注，可以生成一个新的 Note 实体：

```dart
final note = Note(
  uuid: generateUuid(),
  content: '今天主要复习了概率论',
  timestamp: Clock.instance.now(),
);
```

同样通过 TaskMapping 加入任务体系：

```dart
TaskMapping(
  taskUuid: task.uuid,
  entityUuid: note.uuid,
  entityType: 'note',
);
```

这样，“考研数学复习”任务下的所有内容都通过 `TaskMapping` 聚合起来了。Task 变成了一个语义容器，TimerUnit、Note、Checklist 等等，都是它的表现形式。

接下来，如果我们希望展示一个任务的全部历史行为，可以这样

```dart
Future<List<Object>> loadAllEntitiesForTask(String taskUuid) async {
  final mappings = await db.queryTaskMappings(taskUuid);
  final results = <Object>[];

  for (final m in mappings) {
    switch (m.entityType) {
      case 'timer':
        results.add(await db.loadTimerUnit(m.entityUuid));
        break;
      case 'note':
        results.add(await db.loadNote(m.entityUuid));
        break;
      // 支持更多类型
    }
  }

  return results;
}
```

这也使 UI 呈现变得统一，任务详情页可以自动从这些实体构建出时间线、统计、笔记摘要等模块。

更重要的是，这种映射式设计天然支持多对多关系。例如，当两个不同任务共享某个笔记、计时行为，或者一个任务中引用了另一个任务的结果作为资源（如“刷题”任务引用“错题集”任务），我们不需要变更实体结构，只需增添一条 `TaskMapping` 记录即可。

再进一步，我们可以引入 `TaskRelation` 表描述任务之间的关系：

```sql
CREATE TABLE TaskRelation (
  fromUuid TEXT,
  toUuid TEXT,
  weight REAL,
  PRIMARY KEY (fromUuid, toUuid)
);
```

这迎合我们的设计哲学，一种去中心化的关系图谱，查询逻辑也可以通过图的方法实现。

如果进一步引入 Meta 层，用于补充每个任务的历史信息、使用频率等，也无需再依附于 `TimerUnit`，而是绑定在 Task 上。这样所有扩展数据都归属语义中心 Task，而不被拆散在多个实体内部，这种集中式设计反而更有利于维护和分析。
