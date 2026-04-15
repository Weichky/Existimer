import numpy as np
import matplotlib.pyplot as plt
from scipy.interpolate import make_interp_spline
import math

# 常见时间复杂度函数
def O_1(n): 
    return np.ones_like(n)
def O_log_n(n):
    return np.log2(n)
def O_n(n):
    return n
def O_n_log_n(n):
    return n * np.log2(n)
def O_n2(n):
    return n**2
def O_n3(n):
    return n**3
def O_2n(n):
    return 2**n
def O_factorial(n):
    return np.array([math.factorial(int(x)) for x in n])

# 输入范围
n = np.linspace(1, 20, 50)  # 这里取到 20，n! 和 2ⁿ 会很快超过上限
y_max_limit = 40            # y 轴最大值

# 函数及名称
functions = [
    (O_1, "O(1)"),
    (O_log_n, "O(log n)"),
    (O_n, "O(n)"),
    (O_n_log_n, "O(n log n)"),
    (O_n2, "O(n²)"),
    (O_n3, "O(n³)"),
    (O_2n, "O(2ⁿ)"),
    (O_factorial, "O(n!)")
]

# Material Design 色板（降低饱和度）
colors = [
    "#4285F4", "#DB4437", "#F4B400", "#0F9D58",
    "#AB47BC", "#00ACC1", "#FF7043", "#8D6E63"
]

plt.figure(figsize=(4, 15))

for i, (func, label) in enumerate(functions):
    y = func(n)
    # 限制最大值，超出部分截断
    y = np.clip(y, None, y_max_limit)
    # 平滑曲线
    x_smooth = np.linspace(n.min(), n.max(), 300)
    spline = make_interp_spline(n, y, k=3)
    y_smooth = spline(x_smooth)
    plt.plot(x_smooth, y_smooth, label=label, color=colors[i], linewidth=2)

plt.title("Comparison of Common Time Complexities", fontsize=12)
plt.xlabel("Input Size (n)", fontsize=12)
plt.ylabel("Growth", fontsize=12)
plt.ylim(0, y_max_limit)
plt.xlim(1, n.max())
plt.gca().set_aspect('equal', adjustable='box')
plt.legend()
plt.grid(True, linestyle="--", alpha=0.6)
plt.minorticks_on()
plt.grid(which="minor", linestyle=":", alpha=0.3)  # 网格更密集
plt.tight_layout()
plt.show()
