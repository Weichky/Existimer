# 从TimerUnit出发设计的Meta

目前是将TimerUnit保存为final的TimerUnitSnapshot后，再存入数据库的. 其唯一标识是uuid，也是读取和保存的凭据. 基于这点，作了如下的讨论

## Meta的身份

Meta的目的是什么？为了以后的笔记、计次任务等，以及历史统计的方便. 不是一个一定要有的东西，不是核心要素. 主要区别在于，不涉及业务逻辑，往往只是自动读写，而且内容会比较大. 



我们可以建立一个MetaBase基类，在其之上派生出其他Meta类. 这里又引发了一个问题：负责统计历史、备注和笔记内容等的Meta，应该是同一个Meta么？

## TimerUnit的一致性

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

```sqlite
Task {
  uuid TEXT PRIMARY KEY,
  ... // 其他字段
}

TimerUnit {
  uuid TEXT PRIMARY KEY,
  ... // 其他字段
}

TaskTimerMapping {
  taskUuid TEXT,
  timerUuid TEXT,
  PRIMARY KEY (taskUuid, timerUuid) // 组合主键（composite primary key）
}
```

看起来我们要维护另外一个表，希望这是值得的. 

以上最后还是需要用户决定.

## 不同的Meta

上面我们允许了Task的重名. 除了在UI显示中引入颜色，也应当允许用户备注. 这个note不应该是Meta. 
