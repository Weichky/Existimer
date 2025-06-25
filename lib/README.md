# 架构
## UML图
暂时未完成，待更正

```mermaid
classDiagram
direction LR

%% Snapshot部分
class SnapshotBase {
  <<abstract>>
  + Map<String, dynamic> toMap()
}
class TimerUnitSnapshot {
  + String uuid
  + TimerUnitStatus status
  + TimerUnitType type
  + Duration duration
  + DateTime? referenceTime
  + Duration? lastRemainTime

  + Map<String, dynamic> toMap()
  + static TimerUnitSnapshot fromMap(Map<String, dynamic>)
}
TimerUnitSnapshot ..|> SnapshotBase

%% TimerUnit 和 TimerBase 层
class TimerUnit {
  - String _uuid
  - TimerUnitStatus _status
  - TimerUnitType _timerUnitType
  - TimerBase _currentTimer
  - Duration _duration
  - DateTime? _referenceTime
  - Duration? _lastRemainTime
  - Clock clock

  + factory countup()
  + factory countdown(Duration time)
  + void toCountup()
  + void toCountdown(Duration time)
  + void start()
  + void pause()
  + void resume()
  + void stop()
  + Duration get duration
  + TimerUnitSnapshot toSnapshot()
  + void fromSnapshot(TimerUnitSnapshot snapshot)
}

class TimerBase {
  <<abstract>>
  + Duration duration(DateTime now)
  + DateTime referenceTime()
  + void start(DateTime now)
  + void stop(DateTime now)
  + bool get isCountup
  + bool get isCountdown
}

class CountupTimer {
  - Duration _totalDuration
  - DateTime? _startTime

  + Duration duration(DateTime now)
  + DateTime referenceTime()
  + void start(DateTime now)
  + void stop(DateTime now)
  + void reset()
  + bool get isCountup
  + bool get isCountdown
}

class CountdownTimer {
  - Duration _remainDuration
  - DateTime? _endTime

  + Duration duration(DateTime now)
  + DateTime referenceTime()
  + void start(DateTime now)
  + void stop(DateTime now)
  + void reset(Duration time)
  + bool get isCountup
  + bool get isCountdown
}

TimerUnit --> TimerUnitSnapshot : toSnapshot/fromSnapshot
TimerUnit --> TimerBase : _currentTimer
CountupTimer ..|> TimerBase
CountdownTimer ..|> TimerBase

%% 仓库接口及实现
class SnapshotRepository~T~ {
  <<abstract>>
  + Future<void> saveSnapshot(T snapshot)
  + Future<T?> loadSnapshot(String uuid)
}

class TimerUnitSqlite {
  + Database db

  + Future<void> saveSnapshot(TimerUnitSnapshot snapshot)
  + Future<TimerUnitSnapshot?> loadSnapshot(String uuid)
}

TimerUnitSqlite ..|> SnapshotRepository~TimerUnitSnapshot~
TimerUnitSqlite ..> TimerUnitSnapshot : uses toMap/fromMap
```

## 前端
- 使用Timer.periodic()手动刷新，定期与后台同步.

## 数据库
- [x] meta与实体解耦，如task_meta,task_notes,task_tags

## 数据结构与类
- ~~自定义 EntityWithMeta类，而不是使用Tuple2等.~~

# 开发构思与日志
## 2025年
### 5月
**11日A**
- ~~TimerUnit作为实体，Task作为标签或状态被持有.~~ `抽象所有类为Task`
- ~~对于TimerUnit使用SQLite单表，建立索引优化查找速度.~~ `拆成多表`
- 准备编写Task部分，然后进行数据库读写测试.
- ==状态管理准备使用Riverpod+StateNotifier.==

**11日B**
数据库设计相关：
- [x] TimerUnit表包含所有可执行的TimerUnit的全部状态，可以从此读取恢复计时.
- ~~添加任务名称到TimerUnit中，但是唯一标识仍是uuid.~~ `保持解耦`
- [x] 对于计时历史单独记录一张表，使用uuid区别任务. 只需记录uuid、持续时长、计时开始时间.
- ~~有必要维护一张uuid与名称关联的表，方便转移历史.~~ `创建meta表`

**12日A**
- ~~基于EntityWithMeta派生具体类.~~ `原本采用的是SnapshotWithMeta,但是这层封装没有意义. `

**13&14日AB**
- 休息一下，马上回来（其实14日是有水一下的）

**15日A**
- 暂时解决了数据库问题（未经测试）
- 编写了部分初始化模块，尚未完成逻辑
- 数据库结构已经搭建了，但是相应的逻辑没有完成（snapshot没有处理好）

**16日A**
- [x] 将snapshot纳入SnapshotBase基类
- [x] 理清了存储关系
- [x] ==考虑将哲学观点融入项目设计==
- [x] ~~PotatoTask名字并不是很好，考虑改名“Existimer”，不过这个阶段最重要的不是名字~~ `已改名`
- [x] 删除了SnapshotWithMeta,该类没有起到作用

**17日B**
- [x] 完成了设置的编写
- [x] 数不清的工作
- [x] 数据库基本没问题
- 发现TimerUnit工作竟然尚未完成，暂且搁置

**18日A**
- 还在调试数据库和计时模块. 上次重构后没有进行测试. 必须重写一部分Timer，解决初始化时endTime等没有生成的问题，以及倒计时的逻辑问题. 

**19日至21日**
- [x] 数据库和TimerUnit模块等调试完毕，修复了发现的所有问题，准备水两天休息一下
- 下阶段准备完善一下settings/config的部分，然后准备riverpod架构的设计

**TILL 25日**
- keep alive. 预计25日继续项目，最近专注于考研复习和各种课程的期末项目.


### 6月
**TILL 3日**
- 进入期末周复习，暂停更新

**24日**
- code review

**25日**
- 重新开工
- 缕清了Riverpod的基本概念
- 重构了timer_controller.dart、timer_provider.dart等相关代码，该部分代码尚未完成

**26日**
- 考虑重新组织UML图
