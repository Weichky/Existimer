#!/usr/bin/env python3
"""
Simple Experiment File - Non-parallel Version
This file provides a simple experimental interface without parallel processing
"""

import time
import matplotlib.pyplot as plt
from matplotlib.ticker import MultipleLocator
import sys

# ==================== Experimental Parameter Configuration ====================
# Basic parameters
M = 53                    # Number of elements in integer indexing system
N = 53                    # Number of elements in float indexing system
MAX_MOVES = 2000          # Maximum number of moves
MIN_MOVES = 1             # Minimum number of moves

# Experimental parameters
NUM_EXPERIMENTS = 2000    # Number of experiments

# Integer indexing specific parameters
INITIAL_VALUE_INTEGER = 53  # Integer indexing initial value
RESET_VALUE_INTEGER = 53    # Integer indexing reset value

# Step parameters
STEP_INTEGER = 10         # Integer indexing move step size
STEP_FLOAT = 10           # Float indexing move step size

# Auto increment parameters
AUTO_INCREMENT = True     # Auto increment feature switch
INCREMENT_INTERVAL = 10   # Increment interval

# Output control
VERBOSE = True            # Whether to output detailed information

# Performance control
ENABLE_DETAILED_OUTPUT = True  # 设置为False可关闭详细输出以节省性能

# Data output control
OUTPUT_DATA_POINTS = True  # 是否将绘图时使用的点输出到文件中

# ==================== Visualization Configuration ====================
# Text elements - All text in the visualization
VISUALIZATION_TITLE = "Indexing System Failure Rate Analysis"
INTEGER_CHART_TITLE = "Integer Indexing Failure Rate vs Moves"
FLOAT_CHART_TITLE = "Float Indexing Failure Rate vs Moves"
X_AXIS_LABEL = "Number of Moves"
Y_AXIS_LABEL = "Failure Rate"
INTEGER_LEGEND_LABEL = "Integer Indexing"
FLOAT_LEGEND_LABEL = "Float Indexing"
CHART_FILENAME = "indexing_results.png"
DATA_POINTS_FILENAME = "data_points.txt"  # 数据点输出文件名

# Display options - Enable/disable text elements
SHOW_VISUALIZATION_TITLE = True
SHOW_INTEGER_CHART_TITLE = True
SHOW_FLOAT_CHART_TITLE = True
SHOW_X_AXIS_LABEL = True
SHOW_Y_AXIS_LABEL = True
SHOW_LEGEND = False
SHOW_GRID = True
SHOW_PLOT_LINE = True  # 控制是否显示数据线

# Chart styling - Material Design colors with low saturation
INTEGER_COLOR = '#B71C1C'  # Material Design purple with lower saturation
FLOAT_COLOR = '#0D47A1'    # Material Design teal with lower saturation
GRID_COLOR = '#BDBDBD'     # Material Design gray for grid
BACKGROUND_COLOR = '#FFFFFF'  # White background

# Chart configuration
Y_AXIS_MIN = 0.0
Y_AXIS_MAX = 1.01
GRID_DENSITY = 0.1         # Grid line density (0.1 = 10 lines from 0 to 1)
FIGURE_SIZE = (12, 5)      # Figure size (width, height)
# ==============================================================================

def print_if_enabled(*args, **kwargs):
    """根据ENABLE_DETAILED_OUTPUT开关决定是否打印详细输出"""
    if ENABLE_DETAILED_OUTPUT:
        # 确保强制刷新输出
        kwargs.setdefault('flush', True)
        print(*args, **kwargs)

def run_integer_indexing_experiments(m, moves, initial_value_integer, reset_value_integer, auto_increment, increment_interval, num_experiments):
    """Run integer indexing experiments"""
    from simulation import simulate_integer_indexing
    
    failures = 0
    for _ in range(num_experiments):
        if simulate_integer_indexing(m, moves, initial_value_integer, reset_value_integer, False, auto_increment, increment_interval):
            failures += 1
    
    return failures

def run_float_indexing_experiments(n, moves, auto_increment, increment_interval, num_experiments):
    """Run float indexing experiments"""
    from simulation import simulate_float_indexing
    
    failures = 0
    for _ in range(num_experiments):
        if simulate_float_indexing(n, moves, False, auto_increment, increment_interval):
            failures += 1
    
    return failures

def run_experiments(m, n, max_moves, min_moves, num_experiments, 
                   initial_value_integer, reset_value_integer, auto_increment, increment_interval,
                   step_integer, step_float):
    """Run experiments and collect data"""
    # Store results
    integer_failures = {}
    float_failures = {}
    
    # Test with specified step sizes
    move_counts_integer = list(range(step_integer, max_moves+1, step_integer))
    move_counts_float = list(range(step_float, max_moves+1, step_float))
    
    # Ensure minimum moves are included
    move_counts_integer = [moves for moves in move_counts_integer if moves >= min_moves]
    move_counts_float = [moves for moves in move_counts_float if moves >= min_moves]
    
    if VERBOSE and ENABLE_DETAILED_OUTPUT:
        print_if_enabled("Integer indexing failure rates:")
        print_if_enabled("Moves\tFailures\tTotal\tFailure Rate")
    
    for moves in move_counts_integer:
        failures = run_integer_indexing_experiments(m, moves, initial_value_integer, reset_value_integer, auto_increment, increment_interval, num_experiments)
        failure_rate = failures / num_experiments
        integer_failures[moves] = failure_rate
        if VERBOSE and ENABLE_DETAILED_OUTPUT:
            print_if_enabled(f"{moves}\t{failures}\t\t{num_experiments}\t{failure_rate:.3f}")
    
    if VERBOSE and ENABLE_DETAILED_OUTPUT:
        print_if_enabled("\nFloat indexing failure rates:")
        print_if_enabled("Moves\tFailures\tTotal\tFailure Rate")
    
    for moves in move_counts_float:
        failures = run_float_indexing_experiments(n, moves, auto_increment, increment_interval, num_experiments)
        failure_rate = failures / num_experiments
        float_failures[moves] = failure_rate
        if VERBOSE and ENABLE_DETAILED_OUTPUT:
            print_if_enabled(f"{moves}\t{failures}\t\t{num_experiments}\t{failure_rate:.3f}")
    
    return integer_failures, float_failures

def output_data_points(integer_failures, float_failures, filename=DATA_POINTS_FILENAME):
    """Output data points to a file"""
    if not OUTPUT_DATA_POINTS:
        return
    
    with open(filename, 'w') as f:
        f.write("# Integer indexing data points\n")
        f.write("# Moves\tFailure Rate\n")
        for moves, rate in sorted(integer_failures.items()):
            f.write(f"{moves}\t{rate}\n")
        
        f.write("\n# Float indexing data points\n")
        f.write("# Moves\tFailure Rate\n")
        for moves, rate in sorted(float_failures.items()):
            f.write(f"{moves}\t{rate}\n")
    
    print_if_enabled(f"Data points output to {filename}")

def visualize_results(integer_failures, float_failures):
    """Visualize results"""
    # Create two subplots
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=FIGURE_SIZE)
    
    # Plot integer indexing results
    moves_integer = list(integer_failures.keys())
    rates_integer = list(integer_failures.values())
    if SHOW_PLOT_LINE:
        ax1.plot(moves_integer, rates_integer, 'o-', color=INTEGER_COLOR, label=INTEGER_LEGEND_LABEL)
    else:
        ax1.plot(moves_integer, rates_integer, 'o', color=INTEGER_COLOR, label=INTEGER_LEGEND_LABEL)
    if SHOW_INTEGER_CHART_TITLE:
        ax1.set_title(INTEGER_CHART_TITLE)
    if SHOW_X_AXIS_LABEL:
        ax1.set_xlabel(X_AXIS_LABEL)
    if SHOW_Y_AXIS_LABEL:
        ax1.set_ylabel(Y_AXIS_LABEL)
    ax1.set_ylim([Y_AXIS_MIN, Y_AXIS_MAX])
    if SHOW_GRID:
        ax1.grid(True, color=GRID_COLOR, linestyle='-', linewidth=0.5)
        # Set grid density
        ax1.yaxis.set_major_locator(MultipleLocator(GRID_DENSITY))
    if SHOW_LEGEND:
        ax1.legend()
    
    # Plot float indexing results
    moves_float = list(float_failures.keys())
    rates_float = list(float_failures.values())
    if SHOW_PLOT_LINE:
        ax2.plot(moves_float, rates_float, 'o-', color=FLOAT_COLOR, label=FLOAT_LEGEND_LABEL)
    else:
        ax2.plot(moves_float, rates_float, 'o', color=FLOAT_COLOR, label=FLOAT_LEGEND_LABEL)
    if SHOW_FLOAT_CHART_TITLE:
        ax2.set_title(FLOAT_CHART_TITLE)
    if SHOW_X_AXIS_LABEL:
        ax2.set_xlabel(X_AXIS_LABEL)
    if SHOW_Y_AXIS_LABEL:
        ax2.set_ylabel(Y_AXIS_LABEL)
    ax2.set_ylim([Y_AXIS_MIN, Y_AXIS_MAX])
    if SHOW_GRID:
        ax2.grid(True, color=GRID_COLOR, linestyle='-', linewidth=0.5)
        # Set grid density
        ax2.yaxis.set_major_locator(MultipleLocator(GRID_DENSITY))
    if SHOW_LEGEND:
        ax2.legend()
    
    # Set main title
    if SHOW_VISUALIZATION_TITLE:
        fig.suptitle(VISUALIZATION_TITLE)
    
    plt.tight_layout()
    plt.savefig(CHART_FILENAME)
    # plt.show()

def run_simple_experiments():
    """Run simple experiments"""
    print_if_enabled(f"Running simple experiments with m=n={M}")
    print_if_enabled(f"Auto increment: {AUTO_INCREMENT}, Interval: {INCREMENT_INTERVAL}")
    print_if_enabled("=" * 60)
    
    start_time = time.time()
    
    # Run experiments
    integer_failures, float_failures = run_experiments(
        m=M,
        n=N,
        max_moves=MAX_MOVES,
        min_moves=MIN_MOVES,
        num_experiments=NUM_EXPERIMENTS,
        initial_value_integer=INITIAL_VALUE_INTEGER,
        reset_value_integer=RESET_VALUE_INTEGER,
        auto_increment=AUTO_INCREMENT,
        increment_interval=INCREMENT_INTERVAL,
        step_integer=STEP_INTEGER,
        step_float=STEP_FLOAT
    )
    
    end_time = time.time()
    
    # Output data points if enabled
    output_data_points(integer_failures, float_failures)
    
    # Visualize results
    visualize_results(integer_failures, float_failures)
    
    # Print summary
    print_if_enabled("\n" + "=" * 60)
    print_if_enabled("Experiment Summary:")
    print_if_enabled("MAIN", f"- Elements count: Integer={M}, Float={N}")
    print_if_enabled("MAIN", f"- Move range: {MIN_MOVES} to {MAX_MOVES}")
    print_if_enabled("MAIN", f"- Experiments per data point: {NUM_EXPERIMENTS}")
    print_if_enabled("MAIN", f"- Integer indexing initial/reset value: {INITIAL_VALUE_INTEGER}/{RESET_VALUE_INTEGER}")
    print_if_enabled("MAIN", f"- Integer indexing step size: {STEP_INTEGER}")
    print_if_enabled("MAIN", f"- Float indexing step size: {STEP_FLOAT}")
    print_if_enabled("MAIN", f"- Auto increment: {AUTO_INCREMENT} (interval: {INCREMENT_INTERVAL})")
    print_if_enabled("MAIN", f"- Total execution time: {end_time - start_time:.2f} seconds")

if __name__ == "__main__":
    run_simple_experiments()