# 架构
## 前端
- 使用Timer.periodic()手动刷新，定期与后台同步.

## 数据库
- meta与实体解耦，如task_meta,task_notes,task_tags

## 数据结构与类
- 自定义 EntityWithMeta类，而不是使用Tuple2等.

# 开发构思与日志
## 2025年
### 5月
**11日A**
- TimerUnit作为实体，Task作为标签或状态被持有. 
- ~~对于TimerUnit使用SQLite单表，建立索引优化查找速度.~~ `拆成多表`
- 准备编写Task部分，然后进行数据库读写测试.
- 状态管理准备使用Riverpod+StateNotifier.

**11日B**
数据库设计相关：
- TimerUnit表包含所有可执行的TimerUnit的全部状态，可以从此读取恢复计时.
- ~~添加任务名称到TimerUnit中，但是唯一标识仍是uuid.~~ `保持解耦`
- 对于计时历史单独记录一张表，使用uuid区别任务. 只需记录uuid、持续时长、计时开始时间.
- ~~有必要维护一张uuid与名称关联的表，方便转移历史.~~ `创建meta表`

**12日A**
- 基于EntityWithMeta派生具体类.

**13&14日**
- 休息一下