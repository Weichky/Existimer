| 42c12b8 | Weichky Charl | Tue Jul 29 13:12:50 2025 +0800 | refactor(database): 重构数据库相关代码 |
| a5bcaa1 | Weichky Charl | Tue Jul 29 12:28:16 2025 +0800 | feat(demo): 实现计时器恢复功能并优化应用启动流程 |
| 7a1f38e | Weichky Charl | Mon Jul 28 18:14:36 2025 +0800 | refactor(settings): 重构设置相关代码并优化倒计时功能 |
| f8ee197 | Weichky Charl | Mon Jul 28 17:35:12 2025 +0800 | fix: 修复跳秒bug |
| c2abcb4 | Weichky Charl | Mon Jul 28 00:58:27 2025 +0800 | test(timer): 暂且提交，正向计时跳变问题仍未解决 |
| d3c7988 | Weichky Charl | Sun Jul 27 19:35:56 2025 +0800 | feat(timer): 编写了demo bug:发现计时器暂时出现正向计时错误 |
| 24efd4d | Weichky Charl | Sun Jul 27 16:31:01 2025 +0800 | refactor: 移动和整理了的contoller和provider |
| 4c596ad | Weichky Charl | Sun Jul 27 15:48:24 2025 +0800 | update: design/class_diagram.mmd |
| 5bf5d3c | Weichky Charl | Sun Jul 27 15:40:16 2025 +0800 | update: design/class_diagram.mmd |
| f6b95d2 | Weichky Charl | Sun Jul 27 11:13:48 2025 +0800 | update: commit_log.md |
| 2dac73a | Weichky Charl | Sun Jul 27 10:42:52 2025 +0800 | feat(data): 新增任务元数据、关系和历史记录的数据库支持 |
| e698ad1 | Weichky Charl | Sun Jul 27 10:23:15 2025 +0800 | feat(application): 实现任务映射功能并重构控制器和仓库模式 |
| b474a05 | Weichky Charl | Sun Jul 27 08:59:22 2025 +0800 | feat: 实现了TaskMapping的数据结构,snapshot和sqlite接口 |
| b544884 | Weichky Charl | Sat Jul 26 23:00:53 2025 +0800 | fix: 删除初始化数据库时多余的"," |
| e6a07a0 | Weichky Charl | Sat Jul 26 22:32:01 2025 +0800 | update: ignore |
| a2d7669 | Weichky | Sat Jul 26 22:27:36 2025 +0800 | Delete .metadata |
| 3b87dcd | Weichky | Sat Jul 26 22:27:10 2025 +0800 | Delete pubspec.lock |
| 05a937e | Weichky Charl | Sat Jul 26 21:37:21 2025 +0800 | feat: 实现了TaskRelation的数据结构,snapshot和sqlite接口 |
| 89bb7b6 | Weichky Charl | Sat Jul 26 21:23:05 2025 +0800 | feat: 实现了 HistorySnapshot 和 HistorySqlite.fix: 修复 HistorySnapshot 的 toMap/fromMap 方法. |
| c104a23 | Weichky Charl | Sat Jul 26 20:46:11 2025 +0800 | 编写了task_meta.dart |
| a28cbbc | Weichky Charl | Sat Jul 26 19:18:22 2025 +0800 | 编写了task_meta_snapshot.dart,同时为TaskSnapshot.fromMap()添加非空检测 |
| 3781495 | Weichky Charl | Sat Jul 26 19:06:56 2025 +0800 | 修改部分疏漏createAt/create_at为createdAt |
| 51df544 | Weichky Charl | Sat Jul 26 16:13:13 2025 +0800 | 删掉一些漏网之鱼description |
| b6d739c | Weichky Charl | Sat Jul 26 14:18:34 2025 +0800 | 移动timer_unit_snapshot.dart |
| 496adf3 | Weichky Charl | Sat Jul 26 14:16:36 2025 +0800 | 统一更改user_settings为settings |
| eab22c4 | Weichky Charl | Sat Jul 26 14:10:58 2025 +0800 | 更改task_meta_sqlite.dart为task_sqlite.dart |
| d3c4471 | Weichky Charl | Sat Jul 26 14:06:33 2025 +0800 | 目录改名 |
| c8d773f | Weichky Charl | Sat Jul 26 13:48:56 2025 +0800 | 重命名default_config.dart为default_settings.dart,并为其添加toMap()方法 |
| 1b302a3 | Weichky Charl | Sat Jul 26 11:47:41 2025 +0800 | 将settings的存储方式从分字段转为json，并修改user_settings_sqlite.dart中saveSnapshot()和loadSnapshot()方法 |
| bcf4a25 | Weichky Charl | Sat Jul 26 02:45:05 2025 +0800 | 编写完成history.dart,为Clock.dart添加getter instance. 现无需持有或Clock(),通过Clock.instance.currentTime来获取现在时间 |
| e191a02 | Weichky Charl | Sat Jul 26 02:21:50 2025 +0800 | 继续编写history和相关内容,去除Task.fromSnapshot中的无效字段 |
| e5fba1c | Weichky Charl | Fri Jul 25 18:39:16 2025 +0800 | 补充了history.dart |
| 8d8844b | Weichky Charl | Fri Jul 25 18:08:19 2025 +0800 | 编写了部分task_meta.dart,task_relation.dart和history.dart,删除了对应数据结构和数据库中的description字段,后续单独建立description类 |
| 0524d4b | Weichky Charl | Fri Jul 25 11:18:20 2025 +0800 | 为Task添加了opacity属性 |
| 40dc172 | Weichky Charl | Fri Jul 25 11:16:37 2025 +0800 | 为Task添加了opacity属性 |
| 99356f0 | Weichky Charl | Fri Jul 25 09:43:10 2025 +0800 | design改名 |
| 3e02719 | Weichky Charl | Fri Jul 25 01:02:48 2025 +0800 | 编写了部分task_relation.dart,提高了部分代码可读性,创建了tag_or_meta.md |
| f21dee5 | Weichky Charl | Fri Jul 25 00:49:21 2025 +0800 | 讨论了task数据结构的问题,Finish from_taskA_to_taskB.md |
| 70f4136 | Weichky Charl | Thu Jul 24 22:43:21 2025 +0800 | 更改Task.name自String为String? |
| 59a2caa | Weichky Charl | Thu Jul 24 18:45:54 2025 +0800 | 更改数据库中所有用于判断的量类型为BOOLEAN |
| 3a6eb10 | Weichky Charl | Tue Jul 22 18:23:59 2025 +0800 | 更新开发日志 |
| 4fbce65 | Weichky Charl | Tue Jul 22 13:56:10 2025 +0800 | 探讨设计理念 |
| 96b937e | Weichky Charl | Mon Jul 21 21:53:30 2025 +0800 | 修改TaskSnapshot从数据库恢复Unix时间戳的方法 |
| 59ea37b | Weichky Charl | Mon Jul 21 21:49:32 2025 +0800 | 修改时间存储方式，修改Task |
| bd9d11c | Weichky Charl | Sat Jul 19 23:50:45 2025 +0800 | 更新开发日志 |
| 7851fba | Weichky Charl | Sat Jul 19 23:48:44 2025 +0800 | fix: 修改task_meta类名为task |
| 1991356 | Weichky Charl | Sat Jul 19 23:14:01 2025 +0800 | 更新了开发日志 |
| b450ee4 | Weichky Charl | Sat Jul 19 23:10:19 2025 +0800 | 创建history类 |
| 491fb70 | Weichky Charl | Sat Jul 19 22:34:12 2025 +0800 | 更改task_sqlite.dart及其对应方法,重命名自task_meta_sqlite.dart |
| 98c8166 | Weichky Charl | Sat Jul 19 22:26:33 2025 +0800 | 修改task等内部结构 |
| 4e7cd5c | Weichky Charl | Sat Jul 19 21:59:35 2025 +0800 | 统一将task_meta更换为task |
| 9e6ef3b | Weichky Charl | Thu Jul 17 00:11:00 2025 +0800 | 修改表名 |
| b388bc3 | Weichky Charl | Wed Jul 16 23:58:33 2025 +0800 | 为history表添加了冗余 |
| 895ca0e | Weichky Charl | Wed Jul 16 23:25:47 2025 +0800 | 使用uuid-v4的,统一命名为uuid而非id |
| 23e39ea | Weichky Charl | Wed Jul 16 23:18:29 2025 +0800 | 暂时去除task_meta表 |
| c5c0787 | Weichky Charl | Tue Jul 15 23:36:12 2025 +0800 | 删除多余的模块,keep alive |
| 5c4c6c4 | Weichky Charl | Mon Jul 14 22:24:24 2025 +0800 | 添加了重置删除数据库逻辑,reset默认为false |
| f629b27 | Weichky Charl | Mon Jul 14 22:04:47 2025 +0800 | 保证表task_mapping中task_id和entity_id非空 |
| 94664ec | Weichky Charl | Mon Jul 14 22:01:23 2025 +0800 | 数据库添加了表task_mapping |
| c9a6137 | Weichky Charl | Mon Jul 7 21:09:29 2025 +0800 | 添加数据库版本功能 |
| 44c6173 | Weichky Charl | Mon Jul 7 20:18:44 2025 +0800 | 删两行 |
| 677f8b6 | Weichky Charl | Thu Jul 3 21:07:53 2025 +0800 | 更换设备至ALLDOCUBE |
| 65fb29b | weichky | Wed Jul 2 14:41:01 2025 +0800 | 部分设计 |
| ecd2e13 | weichky | Tue Jul 1 23:44:20 2025 +0800 | 未完成 |
| 5bb6ade | weichky | Mon Jun 30 00:04:03 2025 +0800 | 更新日志 |
| fda253a | weichky | Sun Jun 29 23:59:08 2025 +0800 | keep alive |
| ebb067e | weichky | Sat Jun 28 23:23:03 2025 +0800 | 添加了类图说明 |
| 37c6fe4 | weichky | Sat Jun 28 23:18:23 2025 +0800 | 删除了dcdg |
| 320a279 | weichky | Sat Jun 28 23:17:59 2025 +0800 | 创建了类图 |
| 97b758e | weichky | Sat Jun 28 22:23:50 2025 +0800 | 编写了config_provider.dart和config_contoller.dart，为UserSettings添加了getter |
| d9c4ba8 | weichky | Sat Jun 28 20:53:16 2025 +0800 | 编写了ConfigContoller的build方法，为UserSettings添加fromSnapshot方法 |
| d95906f | weichky | Sat Jun 28 01:24:04 2025 +0800 | AI注释 by Qwen2.5-coder:32b via Continue. |
| ad97b08 | weichky | Fri Jun 27 04:48:34 2025 +0800 | 修改了pubspec.yaml |
| b2228b0 | weichky | Fri Jun 27 04:48:12 2025 +0800 | 修改了pubspec.taml |
| 0b63651 | weichky | Fri Jun 27 04:44:25 2025 +0800 | bug fixed. 去除了部分调试语句 |
| c4e7ef2 | weichky | Fri Jun 27 04:40:43 2025 +0800 | 修复了TimerUnit启动时未能正确保存referenceTime的错误 |
| 843aedf | weichky | Fri Jun 27 03:53:13 2025 +0800 | 编写了timer_controller测试dev_main.dart，修改了TaskType.fromString()的bug等 |
| e2055ec | weichky | Fri Jun 27 00:30:45 2025 +0800 | 编写了timer_controller.dart的save方法 |
| 3240175 | weichky | Thu Jun 26 19:55:18 2025 +0800 | 编写了timer_controller.dart的部分控制方法 |
| 0871d34 | weichky | Thu Jun 26 04:05:51 2025 +0800 | 更新了开发日志 |
| d6399db | weichky | Thu Jun 26 03:56:35 2025 +0800 | 编写了timer_repo_provider.dart，修改了timer_controller.dart |
| d87bafc | weichky | Thu Jun 26 03:24:05 2025 +0800 | 编写了timerProvider.dart、部分timer_contoller.dart |
| b894b78 | weichky | Wed Jun 25 23:14:16 2025 +0800 | 添加了factory TimerUnit.fromSnapshot(TimerUnitSnapshot snapshot) |
| b9c7b93 | weichky | Wed Jun 25 23:03:15 2025 +0800 | 编写了部分timer_provider.dart，需要为timer_unit.dart添加fromSnapshot的工厂方法 |
| 0c40b76 | weichky | Tue Jun 24 19:30:01 2025 +0800 | code review |
| 1dea18c | weichky | Tue Jun 24 16:55:50 2025 +0800 | 恢复更新 |
| 0aa4bdf | weichky | Thu Jun 12 03:51:50 2025 +0800 | 新token投入使用测试2 |
| 7d6da19 | weichky | Thu Jun 12 03:48:06 2025 +0800 | 新token投入使用测试 |
| cfb8d6a | Weichky | Thu Jun 12 03:29:20 2025 +0800 | 在Windows下使用WSL2初始化 |
| 7777335 | Weichky | Wed Jun 11 23:52:09 2025 +0800 | 尝试riverpod编写timer_controller和timer_provider. 还需进一步调整 |
| 8ab81b9 | Weichky | Tue Jun 10 23:36:17 2025 +0800 | 编写了部分timer_provider |
| 90ef049 | Weichky | Sat Jun 7 19:49:12 2025 +0800 | 对SettingsSnapshot添加mergeWith方法;编写settings_provider.dart等 |
| ff9dd52 | Weichky | Thu Jun 5 00:14:53 2025 +0800 | 编写了appStartupServiceProvider和databaseProvider |
| 5e9d39a | Weichky | Wed Jun 4 22:45:39 2025 +0800 | 对TimerUnit的pause()方法进行补充说明 |
| 6dd9ff3 | Weichky | Tue Jun 3 23:59:30 2025 +0800 | 更改开发日志 |
| 84a6e39 | Weichky | Mon Jun 2 21:49:46 2025 +0800 | 更改开发日志 |
| 3895a53 | Weichky | Sun Jun 1 17:20:37 2025 +0800 | 更改开发日志 |
| 3ba4551 | Weichky | Sun May 25 23:56:54 2025 +0800 | 更新开发日志 |
| 4e56e9e | Weichky | Sat May 24 21:40:05 2025 +0800 | 更新开发日志 |
| 63a40ab | Weichky | Fri May 23 23:50:24 2025 +0800 | 更新开发日志 |
| 1492883 | Weichky | Fri May 23 23:49:57 2025 +0800 | 更新开发日志 |
| 24f3f6c | Weichky | Wed May 21 20:56:54 2025 +0800 | 更改开发日志和UML图 |
| 266b6e5 | Weichky | Wed May 21 20:42:04 2025 +0800 | 更改README.md和日志 |
| 5af79be | Weichky | Wed May 21 20:38:22 2025 +0800 | 更改项目布局 |
| 0b7c7d3 | Weichky | Wed May 21 20:28:13 2025 +0800 | 文件内更名，将所有potato_task替换为existimer |
| 50ae82b | Weichky | Wed May 21 20:05:03 2025 +0800 | 编写调试了TimerUnit的get duration方法 |
| aafab5e | Weichky | Wed May 21 01:23:41 2025 +0800 | 代码格式化 |
| 8a552a9 | Weichky Charl | Tue May 20 16:56:19 2025 +0800 | 修复TimerUnit计时逻辑，数据库调试完毕 |
| 97ab418 | Weichky Charl | Tue May 20 13:12:38 2025 +0800 | 增加了isFromSnapshot,用于恢复逻辑 |
| 991b0db | Weichky Charl | Tue May 20 13:09:36 2025 +0800 | 删除了timer.dart中的isWorking成员,准备更换为timer_unit.dart的isFromSnapshot |
| 5f96a45 | Weichky | Mon May 19 23:08:30 2025 +0800 | TimerUnit问题尚未解决 |
| 88c1096 | Weichky | Mon May 19 06:17:38 2025 +0800 | 修改测试dev_main.dart |
| c13b6d3 | Weichky | Mon May 19 01:27:02 2025 +0800 | 继续调试数据库 |
| 710e2d2 | Weichky | Sun May 18 02:09:23 2025 +0800 | 调试数据库 |
| 6255588 | Weichky | Sat May 17 23:46:37 2025 +0800 | 修复了编译阶段错误 |
| 4994ca4 | Weichky | Sat May 17 20:55:37 2025 +0800 | 修改了文件目录，完善了fromString方法的异常处理 |
| 7ff4193 | Weichky | Sat May 17 20:42:09 2025 +0800 | 编写了UserSettings.dart |
| 15bd688 | Weichky | Sat May 17 20:13:46 2025 +0800 | 编写了system_config和对应的数据库部分 |
| 840043f | Weichky | Fri May 16 10:43:57 2025 +0800 | 删除了没必要的SnapshotWithMeta封装 |
| 903a4fc | Weichky | Fri May 16 06:39:39 2025 +0800 | 重新更新了项目介绍 |
| 366939e | Weichky | Fri May 16 06:37:28 2025 +0800 | 更新了项目介绍和开发日志 |
| ad29849 | Weichky | Fri May 16 05:20:02 2025 +0800 | 更新UML图 |
| ffb0a7f | Weichky | Fri May 16 04:58:38 2025 +0800 | 统一snapshot为SnapshotBase，调整相关repository和startup代码 |
| a871dd0 | Weichky | Fri May 16 03:28:23 2025 +0800 | 调整了UML图中SnapshotWithMeta类的位置 |
| c7d1cde | Weichky | Fri May 16 03:22:26 2025 +0800 | 更新了开发日志，添加了UML图等 |
| b185492 | Weichky | Thu May 15 19:39:28 2025 +0800 | 编写了task_meta.dart配套文件 |
| 23cfa87 | Weichky | Thu May 15 02:00:24 2025 +0800 | Merge remote-tracking branch 'refs/remotes/origin/main' |
| f06c81d | Weichky | Thu May 15 01:22:34 2025 +0800 | 更改了settings_repository.dart的位置 |
| b6c843d | Weichky | Thu May 15 01:17:32 2025 +0800 | fix README.md |
| b723d0e | Weichky | Thu May 15 01:16:12 2025 +0800 | Update README.md |
| 5653d73 | Weichky | Thu May 15 01:15:31 2025 +0800 | 更新了开发日志 |
| 2a9347f | Weichky | Thu May 15 01:11:16 2025 +0800 | 编写了部分app_startup_service.dart |
| 3dd2f15 | Weichky | Thu May 15 00:51:32 2025 +0800 | 编写了app_database.dart |
| 28e4295 | Weichky | Wed May 14 22:20:16 2025 +0800 | 删除了TimerUnit的name成员 |
| f318a4e | Weichky | Mon May 12 00:19:33 2025 +0800 | 更新了开发日志 |
| 2917d32 | Weichky | Mon May 12 00:06:34 2025 +0800 | 编写了app_startup_service.dart，编写了部分数据库代码. |
| 1bf603d | Weichky | Sun May 11 22:13:58 2025 +0800 | 更新了开发日志 |
| c5848a6 | Weichky | Sun May 11 01:32:14 2025 +0800 | 删除tree.txt |
| 780be48 | Weichky | Sun May 11 01:31:11 2025 +0800 | 修改外部.gitignore，现在不会留下tree.txt |
| a9047ef | Weichky | Sun May 11 01:28:08 2025 +0800 | Update README.md |
| c7770a5 | Weichky | Sun May 11 01:27:56 2025 +0800 | Update README.md |
| ac79467 | Weichky | Sun May 11 01:25:46 2025 +0800 | 更新构想 |
| 9491bac | Weichky | Sun May 11 01:20:38 2025 +0800 | 更新开发日志 |
| 07c7872 | Weichky | Sun May 11 01:17:32 2025 +0800 | 修改lib/README.md记录思路. 删除冗余设计 |
| 5b5e9ed | Weichky | Sat May 10 23:59:20 2025 +0800 | 开始修改TimerUnitModel,主要负责数据库模型 |
| e1e6c37 | Weichky | Tue May 6 21:42:03 2025 +0800 | 水一下 |
| 054a3c1 | Weichky | Sat May 3 07:01:42 2025 +0800 | 添加了读写sqlite数据库相关，包括TimerUnitRepository和TimerUnitSqlite等 |
| 8b7060e | Weichky | Sat May 3 05:25:43 2025 +0800 | 水一次 |
| ce69cda | Weichky | Thu May 1 21:19:25 2025 +0800 | Update README.md |
| 4f9f028 | Weichky | Thu May 1 21:17:49 2025 +0800 | 重构了TimerUnit |
| 0b0e2a0 | Weichky | Thu May 1 19:55:14 2025 +0800 | 创建了TimerUnitSnapshot.dart |
| 486302b | Weichky | Thu May 1 19:30:15 2025 +0800 | Delete .VSCodeCounter/2025-05-01_16-46-52 directory |
| 19d1255 | Weichky | Thu May 1 19:28:56 2025 +0800 | 创建了外部.gitignore |
| 8280cc4 | Weichky | Thu May 1 19:26:17 2025 +0800 | 更新了.gitignore |
| b106a5a | Weichky | Thu May 1 19:23:27 2025 +0800 | 改善了timer.dart和timer_unit.dart,准备snapshot |
| e337210 | Weichky | Thu May 1 02:13:14 2025 +0800 | 改回第一版Timer,准备snapshot |
| 373e3de | Weichky | Thu May 1 00:03:36 2025 +0800 | 调整了reach位置 |
| 26329df | Weichky | Wed Apr 30 23:59:12 2025 +0800 | 设计了优化后的timer.dart |
| ff19b4f | Weichky | Tue Apr 29 13:01:26 2025 +0800 | 需要考虑重新设计timer_unit.dart和timer.dart,确保职能单一 |
| 4ce2118 | Weichky | Tue Apr 29 11:20:14 2025 +0800 | 创建了task.dart和task_model.dart |
| 3d6fc5e | Weichky | Tue Apr 29 02:20:55 2025 +0800 | 将uuid挪至TimerUnit,编写了部分timer_unit_model.dart |
| 4000a16 | Weichky | Tue Apr 29 00:00:12 2025 +0800 | 水一次 |
| bdd9cfb | Weichky | Sun Apr 27 18:19:07 2025 +0800 | 编写了部分timer_privider.dart,设计了settings部分 |
| 63c1c36 | Weichky | Sun Apr 27 17:11:59 2025 +0800 | 更新了.gitignore |
| 8cceb40 | Weichky | Sun Apr 27 16:54:11 2025 +0800 | 清除了工程文件 |
| c0ac9d0 | Weichky | Sun Apr 27 16:52:20 2025 +0800 | 修改TimeManager为Clock |
| e32ad0d | Weichky | Sun Apr 27 16:19:09 2025 +0800 | 修复time_manager.dart命名 |
| 784b7b3 | Weichky | Sat Apr 26 23:35:49 2025 +0800 | vscode 自动保存 |
| 7da5288 | Weichky | Sat Apr 26 23:11:28 2025 +0800 | 编写了部分TimerUnit.dart,设置了统一获取时间单例 |
| 49d9afb | Weichky | Sat Apr 26 18:54:40 2025 +0800 | 调整timer.dart位置 |
| 46edb28 | Weichky | Sat Apr 26 16:19:20 2025 +0800 | 更新了README.md |
| 1fd4822 | Weichky | Sat Apr 26 16:11:23 2025 +0800 | 实现了Timer逻辑 |
| d102b33 | Weichky | Sat Apr 19 01:52:58 2025 +0800 | Initial commit |