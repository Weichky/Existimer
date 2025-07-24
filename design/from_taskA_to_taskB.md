# From Task A to Task B

## 情景假设

用户在复习考研数学。一开始在复习高数，于是创建了“高数”任务。随后进入线性代数复习，又创建了“线代”任务。显然，两者同属于考研数学这一分类。或者在复习高数之后，同时复习线代和概率论。



### 链表与树

天然的，我们能够想到用链表来描述这一结构。

每一节点除了自己的信息以外，还包括父节点和子节点的信息。这时就有两种可能的数据结构：

```dart
class Task {
    String name;
    String uuid;
    // and so on
    // ....
    bool hasChild;
    String parentUuid;
}
```

或者

```dart
class Task {
    String name;
    // ...
    bool hasChild;
    String parentUuid;
    String childUuid;
}
```

以及两者分别添加`bool hasParent`后的版本。区别在于一个是单向的，一个是双向的。

### 有向图

```dart
class Task {
    String uuid;
    String name;
    // ....
}

class TaskTransition {
    String fromUuid;
    String toUuid;
    int count;
}
```

大致是这种数据结构。



不分析了，没理由不用图。关键在于是DG还是DAG，至于更复杂的数据结构，不是这个阶段考虑的。有向图的有向是否必要？我们强调的是一种普遍的关系，而非一种传统的层级。展示顺序是否会破坏这种感觉？我们是否需要有向？这种结构的有向图，比起表示任务之间的关系，似乎更适合拿来做历史。