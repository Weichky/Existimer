import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
import matplotlib.patches as mpatches

# Values for each operation
positions = [512, 256, 128, 64, 32, 16, 8, 4, 2, 1]
labels = [f"Step {i+1}" for i in range(len(positions))]

# Set up plot with subplots
fig = plt.figure(figsize=(15, 6))

# Main plot (top)
ax_main = plt.subplot2grid((3, 1), (0, 0), rowspan=2)
ax_main.set_xlim(0, 1024)
ax_main.set_ylim(0, 1)
ax_main.set_yticks([])

# Draw main number line
ax_main.hlines(0.5, 0, 1024, color='#B0BEC5', linewidth=16)  # MD grey low saturation

# Colors (Material Design low saturation palette)
arrow_color = '#90A4AE'  # Blue Grey 300
text_color = '#37474F'   # Blue Grey 800
highlight_color = '#EF9A9A'  # Red 200

# Draw arrows and labels - only show first 4 steps in main view
for i, (pos, label) in enumerate(zip(positions[:4], labels[:4])):  # Only first 4 steps
    ax_main.annotate(
        label,
        xy=(pos, 0.5),  # Adjusted to be closer to the line
        xytext=(pos, 0.65),  # Adjusted text position to be closer
        textcoords='data',
        ha='center',
        va='bottom',
        color=text_color,
        arrowprops=dict(facecolor=arrow_color, edgecolor=arrow_color, arrowstyle='->', shrinkA=2, shrinkB=2)
    )

# Remove frame and ticks for main plot
ax_main.spines['top'].set_visible(False)
ax_main.spines['left'].set_visible(False)
ax_main.spines['right'].set_visible(False)
ax_main.spines['bottom'].set_visible(False)
ax_main.set_xticks([0, 256, 512, 768, 1024])
ax_main.set_xticklabels(['0', '256', '512', '768', '1024'], color=text_color)

# Highlight the 0-32 region with a rectangle
highlight = Rectangle((0, 0.45), 32, 0.1, linewidth=1, edgecolor='#5C6BC0', facecolor='none', linestyle='--')
ax_main.add_patch(highlight)

# Inset plot (zoomed view of 0-32 region) - placed at the bottom
ax_zoom = plt.subplot2grid((3, 1), (2, 0))
ax_zoom.set_xlim(0, 32)
ax_zoom.set_ylim(0, 1)
ax_zoom.set_yticks([])

# Draw zoomed number line
ax_zoom.hlines(0.5, 0, 32, color='#BFBEF5', linewidth=8)

# Draw arrows and labels for zoomed region - adjust positions to avoid crowding
zoom_positions = [32, 16, 8, 4, 2, 1]
zoom_labels = [f"Step {i+5}" for i in range(len(zoom_positions))]

for i, (pos, label) in enumerate(zip(zoom_positions, zoom_labels)):
    color = highlight_color if pos == 1 else arrow_color
    # Calculate vertical position to avoid overlapping
    y_text = 0.65 + (i * 0.07) if i < 3 else 0.65 + ((i-3) * 0.07)
    ax_zoom.annotate(
        label,
        xy=(pos, 0.5),  # Adjusted to be closer to the line
        xytext=(pos, y_text),  # Dynamically position text to avoid overlap
        textcoords='data',
        ha='center',
        va='bottom',
        color=text_color,
        arrowprops=dict(facecolor=color, edgecolor=color, arrowstyle='->', shrinkA=2, shrinkB=2)
    )

# Special annotation for 1 in zoomed view
ax_zoom.annotate(
    "Cannot split further",
    xy=(1, 0.5),
    xytext=(5, 0.9),
    textcoords='data',
    ha='left',
    va='bottom',
    color=highlight_color,
    arrowprops=dict(facecolor=highlight_color, edgecolor=highlight_color, arrowstyle='->', shrinkA=2, shrinkB=2)
)

# Remove frame and ticks for zoomed plot
ax_zoom.spines['top'].set_visible(False)
ax_zoom.spines['left'].set_visible(False)
ax_zoom.spines['right'].set_visible(False)
ax_zoom.spines['bottom'].set_visible(False)
ax_zoom.set_xticks([0, 8, 16, 24, 32])
ax_zoom.set_xticklabels(['0', '8', '16', '24', '32'], color=text_color)

# Add connecting lines to show the zoom relationship
# Get the position of the highlight rectangle in figure coordinates
con = mpatches.ConnectionPatch(
    xyA=(0, 0.45), xyB=(0, 0.55),
    coordsA="data", coordsB="data",
    axesA=ax_main, axesB=ax_zoom,
    color="#5C6BC0", linestyle="--", linewidth=1
)
fig.add_artist(con)

con2 = mpatches.ConnectionPatch(
    xyA=(32, 0.45), xyB=(32, 0.55),
    coordsA="data", coordsB="data",
    axesA=ax_main, axesB=ax_zoom,
    color="#5C6BC0", linestyle="--", linewidth=1
)
fig.add_artist(con2)

# Add title
fig.suptitle('Binary Splitting Process with Zoomed View (0-32 Region)', fontsize=14, color=text_color)

plt.tight_layout()
plt.show()