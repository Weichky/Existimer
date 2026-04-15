import matplotlib.pyplot as plt
import matplotlib.patches as patches
import numpy as np

# Set up the figure and axis
fig, ax = plt.subplots(1, 1, figsize=(12, 4))

# Define the FP64 structure: 1 sign bit, 11 exponent bits, 52 mantissa bits
bits = [
    ('Sign', 1, '#6C757D'),      # Gray color for sign bit
    ('Exponent', 11, '#3B5B92'), # Blue color for exponent bits
    ('Mantissa', 52, '#5A923F')  # Green color for mantissa bits
]

# MD low saturation color palette
colors = ['#6C757D', '#3B5B92', '#5A923F']  # Gray, Blue, Green - low saturation

# Draw the bit fields
current_pos = 0
# Height is now 4 times the width
height = 4
for i, (name, width, color) in enumerate(bits):
    # Draw rectangle for each bit field with height 4 times width
    # Remove the edge lines as we will draw them separately within bounds
    rect = patches.Rectangle((current_pos, 0), width, height, linewidth=0,
                            edgecolor='none', facecolor=color, alpha=0.7)
    ax.add_patch(rect)
    
    # Add bit numbers
    for j in range(width):
        bit_pos = current_pos + j
        # Adjust y position for new height
        ax.text(bit_pos + 0.5, height/2, str(bit_pos), ha='center', va='center', 
                fontsize=8, color='white', weight='bold')
    
    # Add label for each field
    label_x = current_pos + width / 2
    # Adjust y position for label
    ax.text(label_x, -0.2, f'{name}\n({width} bits)', ha='center', va='top', 
            fontsize=10, weight='bold')
    
    # Draw vertical lines for each bit (within the rectangle bounds)
    for j in range(width + 1):
        bit_pos = current_pos + j
        # 使用plot函数替代axvline，使垂直线只在格子高度范围内绘制
        ax.plot([bit_pos, bit_pos], [0, height], color='black', linestyle='-', linewidth=0.5)
    
    current_pos += width

# Draw horizontal lines to complete the rectangle borders
# Limit the horizontal lines to the actual width (0 to 64) using transform
ax.hlines(y=0, xmin=0, xmax=64, color='black', linestyle='-', linewidth=0.5)
ax.hlines(y=height, xmin=0, xmax=64, color='black', linestyle='-', linewidth=0.5)

# Formatting
# 添加一些边距确保边界线可见
ax.set_xlim(-0.5, 64.5)
# Adjust y limits for new height and add margins
ax.set_ylim(-0.5, height + 0.5)
# 保持等比例以确保格子形状正确
ax.set_aspect('equal')
ax.axis('off')

# # Add title
# plt.title('FP64 (Double Precision) Bit Layout\n'
#           '1 bit Sign | 11 bits Exponent | 52 bits Mantissa', 
#           fontsize=14, weight='bold', pad=20)

# # Add bit position markers
# ax.text(0, height + 0.1, '0', ha='center', va='bottom', fontsize=9)
# ax.text(1, height + 0.1, '1', ha='center', va='bottom', fontsize=9)
# ax.text(10.5, height + 0.1, '11', ha='center', va='bottom', fontsize=9)
# ax.text(12, height + 0.1, '12', ha='center', va='bottom', fontsize=9)
# ax.text(38, height + 0.1, '38', ha='center', va='bottom', fontsize=9)
# ax.text(63, height + 0.1, '63', ha='center', va='bottom', fontsize=9)

# # Add bit range indicators
# ax.annotate('', xy=(0, height + 0.05), xytext=(1, height + 0.05), 
#             arrowprops=dict(arrowstyle='<->', color='black', lw=0.7))
# ax.annotate('', xy=(1, height + 0.05), xytext=(11, height + 0.05), 
#             arrowprops=dict(arrowstyle='<->', color='black', lw=0.7))
# ax.annotate('', xy=(12, height + 0.05), xytext=(63, height + 0.05), 
#             arrowprops=dict(arrowstyle='<->', color='black', lw=0.7))

# # Add bit range labels
# ax.text(0.5, height + 0.08, '1 bit', ha='center', va='bottom', fontsize=8)
# ax.text(6, height + 0.08, '11 bits', ha='center', va='bottom', fontsize=8)
# ax.text(37.5, height + 0.08, '52 bits', ha='center', va='bottom', fontsize=8)

# 移除tight_layout以避免裁剪，使用bbox_inches='tight'参数保存图像
plt.savefig('FP64_structure.png', dpi=300, bbox_inches='tight')
plt.show()