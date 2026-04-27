# 二维无限滚动导航器

## 概述

一个支持横向（Timer 预设切换）和纵向（不同页面切换）的二维导航系统。

## 设计原则

- 对过去不负责，只对当下状态负责
- 行为决定结果
- navigate() 函数返回完整的 Page 对象，而非仅更新索引

## 结构

```
                纵向 (vertical)
                    ↑
    Timer ←→ History ←→ Settings ←→ ...
                   (Timer 预设横向循环)
                    
horizontal →
```

## 核心类型

```typescript
type AxisType = 'horizontal' | 'vertical';

interface Page {
  axis: AxisType;      // 轴向
  index: number;       // 索引
  name: string;        // 页面名称
}

interface NavigationState {
  horizontalIndex: number;
  verticalIndex: number;
  currentPage: Page;
  navigate: (action: { type: AxisType; delta: number }) => Page;
}
```

## 页面映射

| 轴向 | 行为 | 页面列表 |
|------|------|---------|
| horizontal | 左右滑动/点击 | Timer35, Timer90, TimerCountup, TimerCustom1, TimerCustom2 |
| vertical | 上下滑动/点击 | Timer, History, Settings |

## 算法

```typescript
navigate(action) {
  const { type, delta } = action;
  
  if (type === 'horizontal') {
    index = horizontalIndex + delta;
    name = timerPresets[mod(index, timerPresets.length)];
  } else {
    index = verticalIndex + delta;
    name = verticalPages[mod(index, verticalPages.length)];
  }
  
  currentPage = { axis, index, name };
  return currentPage;
}
```

## 关键实现点

1. **navigate() 返回 Page**
   - 包含 axis, index, name
   - UI 层直接使用 currentPage 显示，不做二次计算

2. **负数循环**
   - 使用 `((n % m) + m) % m` 保证负数索引正确循环

3. **独立索引**
   - horizontalIndex 只响应 horizontal 操作
   - verticalIndex 只响应 vertical 操作
   - 切换轴向时各自位置保留