# Redraw: discrete small color blocks, no text, no labels.
# - Linear mapping from smallest positive FP64 to max finite FP64.
# - Partition by exponent intervals [2^n, 2^(n+1)) for n in [-1074..1023].
# - Assign pixel blocks (total_pixels) proportionally to interval widths (exact numeric handling).
# - Each pixel block is drawn as an individual small rectangle with alpha set by precision density (log-scaled).
# - No text, no axes, no ticks — pure visual stripe made of discrete blocks.
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
from matplotlib import colors
import math

# FP64 constants
MIN_SUBNORMAL = 2.0 ** -1074            # smallest positive subnormal
MIN_NORMAL = 2.0 ** -1022               # smallest positive normal
MAX_FINITE = (2 - 2 ** -52) * (2.0 ** 1023)  # largest finite double

# exponent range
ns = np.arange(-1074, 1024)  # include 1023
# compute starts safely using ldexp (1.0 * 2**n)
starts = np.ldexp(1.0, ns)  # 2**n
# compute ends: for n < 1023 use 2^(n+1), for n==1023 use MAX_FINITE
ends = np.where(ns < 1023, np.ldexp(1.0, ns + 1), MAX_FINITE)

# Clip to representable positive finite range [MIN_SUBNORMAL, MAX_FINITE]
starts_clipped = np.maximum(starts, MIN_SUBNORMAL)
ends_clipped = np.minimum(ends, MAX_FINITE)
widths = ends_clipped - starts_clipped
valid_mask = widths > 0
ns = ns[valid_mask]
starts_clipped = starts_clipped[valid_mask]
ends_clipped = ends_clipped[valid_mask]
widths = widths[valid_mask]

# total length (linear mapping)
total_length = MAX_FINITE - MIN_SUBNORMAL

# fractional widths of each interval (sum approx 1)
widths_frac = widths / total_length

# pixelization: number of discrete color blocks to draw
total_pixels = 4000  # adjust resolution: increase for finer blocks, decrease for performance
# compute integer pixel counts for each interval using floor + remainder distribution
raw = widths_frac * total_pixels
floor_counts = np.floor(raw).astype(int)
remainder = int(total_pixels - floor_counts.sum())
if remainder > 0:
    # distribute remainder to intervals with largest fractional parts
    frac_parts = raw - floor_counts
    order = np.argsort(frac_parts)[::-1]
    for idx in order[:remainder]:
        floor_counts[idx] += 1
pixel_counts = floor_counts

# remove intervals with zero pixel count to speed up drawing
keep = pixel_counts > 0
ns = ns[keep]
pixel_counts = pixel_counts[keep]
widths_frac = widths_frac[keep]

# compute opacity mapping using analytic log10 density (avoid overflow)
# density = 1/ulp; for normals (n >= -1022): ulp = 2^(n-52) -> density = 2^(52-n)
# for subnormals (n < -1022): ulp = 2^-1074 -> density = 2^1074
log10_2 = math.log10(2.0)
log_d = np.where(ns < -1022, 1074 * log10_2, (52 - ns) * log10_2)
# normalize log_d -> alpha in [alpha_min, alpha_max]
alpha_min, alpha_max = 0.05, 1.0
ld_min, ld_max = log_d.min(), log_d.max()
alphas = alpha_min + (log_d - ld_min) / (ld_max - ld_min) * (alpha_max - alpha_min)
# ensure no NaN
alphas = np.clip(alphas, alpha_min, alpha_max)

# choose a single low-saturation Material-like color (blue-grey)
base_hex = "#000000"
base_rgb = colors.to_rgb(base_hex)

# draw discrete blocks
fig, ax = plt.subplots(figsize=(14, 1.6))
y = 0.05
height = 0.9
pixel_width = 1.0 / total_pixels
x = 0.0
for count, a in zip(pixel_counts, alphas):
    # draw 'count' blocks with same alpha for this interval
    for _ in range(count):
        rect = Rectangle((x, y), pixel_width, height, facecolor=(base_rgb[0], base_rgb[1], base_rgb[2], a), linewidth=0)
        ax.add_patch(rect)
        x += pixel_width
# If numerical rounding left tiny gap/overlap, clamp
ax.set_xlim(0, 1)
ax.set_ylim(0, 1)
ax.axis('off')
plt.subplots_adjust(left=0, right=1, top=1, bottom=0)
plt.show()
