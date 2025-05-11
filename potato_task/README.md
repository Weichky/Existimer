# 构想
## 前端
- 使用Timer.periodic()手动刷新，定期与后台同步.

# 开发日志
## 2025年
### 5月
**11日A**
- TimerUnit作为实体，Task作为标签或状态被持有. 
- 对于TimerUnit使用SQLite单表，建立索引优化查找速度.
- 准备编写Task部分，然后进行数据库读写测试.
- 状态管理准备使用Riverpod+StateNotifier.

**11日B**
数据库设计相关：
- TimerUnit表包含所有可执行的TimerUnit的全部状态，可以从此读取恢复计时.
- 添加任务名称到TimerUnit中，但是唯一标识仍是uuid.
- 对于计时历史单独记录一张表，使用uuid区别任务. 只需记录uuid、持续时长、计时开始时间.
- 有必要维护一张uuid与名称关联的表，方便转移历史.