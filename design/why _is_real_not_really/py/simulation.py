import random
import matplotlib.pyplot as plt
import numpy as np
from concurrent.futures import ThreadPoolExecutor, as_completed

def initialize_integer_indexing(m, initial_value=9):
    """Initialize integer indexing system with m elements, all with initial_value"""
    return [initial_value] * m

def initialize_float_indexing(n):
    """Initialize float indexing system with n elements, all with value 1"""
    return [1] * n

def move_integer_index(integer_indices, reset_value=9):
    """Move operation for integer indexing system"""
    if len(integer_indices) <= 1:
        return integer_indices
    
    # Randomly select an index to move
    source_index = random.randint(0, len(integer_indices) - 1)
    index_value = integer_indices.pop(source_index)
    
    # Randomly select a target position
    target_index = random.randint(0, len(integer_indices))
    
    # Insert the index
    integer_indices.insert(target_index, index_value)
    
    # Update the inserted index value
    if target_index == 0:
        # Inserted at the beginning
        if len(integer_indices) > 1:
            integer_indices[0] = reset_value
    elif target_index == len(integer_indices) - 1:
        # Inserted at the end
        if len(integer_indices) > 1:
            integer_indices[-1] = reset_value
    else:
        # Inserted in the middle
        left_val = integer_indices[target_index - 1]
        right_val = integer_indices[target_index + 1]
        min_val = min(left_val, right_val)
        
        # Check if both neighbors are 1
        if left_val == 1 and right_val == 1:
            integer_indices[target_index] = max(0, min_val - 1)
        else:
            integer_indices[target_index] = max(1, min_val - 1)
    
    return integer_indices

def move_float_index(float_indices):
    """Move operation for float indexing system"""
    if len(float_indices) <= 1:
        return float_indices
    
    # Randomly select an index to move
    source_index = random.randint(0, len(float_indices) - 1)
    index_value = float_indices.pop(source_index)
    
    # Randomly select a target position
    target_index = random.randint(0, len(float_indices))
    
    # Insert the index
    float_indices.insert(target_index, index_value)
    
    # Update the inserted index value
    if target_index == 0:
        # Inserted at the beginning
        if len(float_indices) > 1:
            float_indices[0] = float_indices[1]
    elif target_index == len(float_indices) - 1:
        # Inserted at the end
        if len(float_indices) > 1:
            float_indices[-1] = float_indices[-2]
    else:
        # Inserted in the middle
        left_val = float_indices[target_index - 1]
        right_val = float_indices[target_index + 1]
        float_indices[target_index] = max(left_val, right_val) + 1
    
    return float_indices

def add_integer_index(integer_indices, initial_value=9):
    """Add a new integer index to the system"""
    # Add an initial value index to a random position
    target_index = random.randint(0, len(integer_indices))
    integer_indices.insert(target_index, initial_value)
    return integer_indices

def add_float_index(float_indices):
    """Add a new float index to the system"""
    # Add an initial value (1) index to a random position
    target_index = random.randint(0, len(float_indices))
    float_indices.insert(target_index, 1)
    return float_indices

def check_integer_failure(integer_indices):
    """Check if integer indexing system fails (has index value of 0)"""
    return 0 in integer_indices

def check_float_failure(float_indices):
    """Check if float indexing system fails (has index value of 54)"""
    return 54 in float_indices

def compress_sequence(indices):
    """
    Compress sequence by abbreviating consecutive identical numbers
    For example: [9,9,9,9,8,9,9,9,9,9,9,9,9,9,9,8,9,9,9,9,9,9,9,9,9] 
    Displayed as: 9[4].8.9[10].8.9[9]
    """
    if not indices:
        return ""
    
    result = []
    current_value = indices[0]
    count = 1
    
    for i in range(1, len(indices)):
        if indices[i] == current_value:
            count += 1
        else:
            if count >= 3:
                result.append(f"{current_value}[{count}]")
            else:
                result.append(".".join([str(current_value)] * count))
            current_value = indices[i]
            count = 1
    
    # Handle the last group
    if count >= 3:
        result.append(f"{current_value}[{count}]")
    else:
        result.append(".".join([str(current_value)] * count))
    
    return ".".join(result)

def simulate_integer_indexing(m, moves, initial_value=9, reset_value=9, verbose=False, 
                             auto_increment=False, increment_interval=5):
    """Simulate integer indexing system"""
    # Initially only one index
    integer_indices = [initial_value] if auto_increment else initialize_integer_indexing(1 if auto_increment else m, initial_value)
    current_max_indices = 1 if auto_increment else m
    
    if verbose:
        print(f"Initial integer indices: {compress_sequence(integer_indices)} (Indices: {len(integer_indices)})")
    
    for i in range(moves):
        # Check if we need to add a new index
        if auto_increment and (i + 1) % increment_interval == 0 and current_max_indices < m:
            integer_indices = add_integer_index(integer_indices, initial_value)
            current_max_indices += 1
            if verbose:
                print(f"Add index at move {i+1}: {compress_sequence(integer_indices)} (Indices: {len(integer_indices)})")
        
        integer_indices = move_integer_index(integer_indices, reset_value)
        if verbose:
            print(f"Move {i+1}: {compress_sequence(integer_indices)} (Indices: {len(integer_indices)})")
        
        if check_integer_failure(integer_indices):
            if verbose:
                print(f"Integer indexing failed at move {i+1}")
            return True
    
    return False

def simulate_float_indexing(n, moves, verbose=False, auto_increment=False, increment_interval=5):
    """Simulate float indexing system"""
    # Initially only one index
    float_indices = [1] if auto_increment else initialize_float_indexing(1 if auto_increment else n)
    current_max_indices = 1 if auto_increment else n
    
    if verbose:
        print(f"Initial float indices: {compress_sequence(float_indices)} (Indices: {len(float_indices)})")
    
    for i in range(moves):
        # Check if we need to add a new index
        if auto_increment and (i + 1) % increment_interval == 0 and current_max_indices < n:
            float_indices = add_float_index(float_indices)
            current_max_indices += 1
            if verbose:
                print(f"Add index at move {i+1}: {compress_sequence(float_indices)} (Indices: {len(float_indices)})")
        
        float_indices = move_float_index(float_indices)
        if verbose:
            print(f"Move {i+1}: {compress_sequence(float_indices)} (Indices: {len(float_indices)})")
            # Show current maximum value
            print(f"Max value: {max(float_indices)}")
        
        if check_float_failure(float_indices):
            if verbose:
                print(f"Float indexing failed at move {i+1}")
            return True
    
    return False

# ==================== Parameter Adjustment Area ====================
# All experimental parameters can be adjusted here
DEFAULT_M = 54              # Number of elements in integer indexing system
DEFAULT_N = 54              # Number of elements in float indexing system
DEFAULT_MAX_MOVES = 100     # Maximum number of moves
DEFAULT_MIN_MOVES = 1       # Minimum number of moves
DEFAULT_NUM_EXPERIMENTS = 200  # Number of experiments
DEFAULT_STEP_INTEGER = 2    # Integer indexing move step size
DEFAULT_STEP_FLOAT = 5      # Float indexing move step size
DEFAULT_INITIAL_VALUE_INTEGER = 9 # Integer indexing initial value
DEFAULT_RESET_VALUE_INTEGER = 9   # Integer indexing reset value
DEFAULT_INCREMENT_INTERVAL = 5  # Auto increment interval

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

# Display options - Enable/disable text elements
SHOW_VISUALIZATION_TITLE = True
SHOW_INTEGER_CHART_TITLE = True
SHOW_FLOAT_CHART_TITLE = True
SHOW_X_AXIS_LABEL = True
SHOW_Y_AXIS_LABEL = True
SHOW_LEGEND = True
SHOW_GRID = True
SHOW_PLOT_LINE = True  # 控制是否显示数据线

# Chart styling - Material Design colors with low saturation
INTEGER_COLOR = '#6200EA'  # Material Design purple with lower saturation
FLOAT_COLOR = '#03DAC6'    # Material Design teal with lower saturation
GRID_COLOR = '#BDBDBD'     # Material Design gray for grid
BACKGROUND_COLOR = '#FFFFFF'  # White background

# Chart configuration
Y_AXIS_MIN = 0.0
Y_AXIS_MAX = 1.0
GRID_DENSITY = 0.1         # Grid line density (0.1 = 10 lines from 0 to 1)
FIGURE_SIZE = (12, 5)      # Figure size (width, height)
# ===================================================================

def run_single_experiment_integer(args):
    """Helper function to run a single integer indexing experiment"""
    m, moves, initial_value, reset_value, verbose, auto_increment, increment_interval = args
    return simulate_integer_indexing(m, moves, initial_value, reset_value, verbose, auto_increment, increment_interval)

def run_single_experiment_float(args):
    """Helper function to run a single float indexing experiment"""
    n, moves, verbose, auto_increment, increment_interval = args
    return simulate_float_indexing(n, moves, verbose, auto_increment, increment_interval)

def run_experiments_parallel(m, n, max_moves, min_moves=1, num_experiments=200, 
                           initial_value_integer=9, reset_value_integer=9, verbose=False, 
                           auto_increment=False, increment_interval=5, max_workers=4):
    """Run experiments in parallel and collect data"""
    # Store results
    integer_failures = {}
    float_failures = {}
    
    # Test with step sizes
    move_counts_integer = list(range(DEFAULT_STEP_INTEGER, max_moves+1, DEFAULT_STEP_INTEGER))
    move_counts_float = list(range(DEFAULT_STEP_FLOAT, max_moves+1, DEFAULT_STEP_FLOAT))
    
    # Ensure minimum moves are included
    move_counts_integer = [moves for moves in move_counts_integer if moves >= min_moves]
    move_counts_float = [moves for moves in move_counts_float if moves >= min_moves]
    
    if verbose:
        print("Integer indexing failure rates:")
        print("Moves\tFailures\tTotal\tFailure Rate")
    
    # Run integer indexing experiments in parallel
    for moves in move_counts_integer:
        with ThreadPoolExecutor(max_workers=max_workers) as executor:
            # Prepare arguments
            args_list = [(m, moves, initial_value_integer, reset_value_integer, False, auto_increment, increment_interval) for _ in range(num_experiments)]
            # Submit tasks
            futures = [executor.submit(run_single_experiment_integer, args) for args in args_list]
            
            # Collect results
            failures = 0
            for future in as_completed(futures):
                if future.result():
                    failures += 1
        
        failure_rate = failures / num_experiments
        integer_failures[moves] = failure_rate
        if verbose:
            print(f"{moves}\t{failures}\t\t{num_experiments}\t{failure_rate:.3f}")
    
    if verbose:
        print("\nFloat indexing failure rates:")
        print("Moves\tFailures\tTotal\tFailure Rate")
    
    # Run float indexing experiments in parallel
    for moves in move_counts_float:
        with ThreadPoolExecutor(max_workers=max_workers) as executor:
            # Prepare arguments
            args_list = [(n, moves, False, auto_increment, increment_interval) for _ in range(num_experiments)]
            # Submit tasks
            futures = [executor.submit(run_single_experiment_float, args) for args in args_list]
            
            # Collect results
            failures = 0
            for future in as_completed(futures):
                if future.result():
                    failures += 1
        
        failure_rate = failures / num_experiments
        float_failures[moves] = failure_rate
        if verbose:
            print(f"{moves}\t{failures}\t\t{num_experiments}\t{failure_rate:.3f}")
    
    return integer_failures, float_failures, move_counts_integer, move_counts_float

def run_experiments(m, n, max_moves, min_moves=1, num_experiments=200, 
                   initial_value_integer=9, reset_value_integer=9, verbose=True,
                   auto_increment=False, increment_interval=5):
    """Run experiments and collect data"""
    # Store results
    integer_failures = {}
    float_failures = {}
    
    # Test with step sizes
    move_counts_integer = list(range(DEFAULT_STEP_INTEGER, max_moves+1, DEFAULT_STEP_INTEGER))
    move_counts_float = list(range(DEFAULT_STEP_FLOAT, max_moves+1, DEFAULT_STEP_FLOAT))
    
    # Ensure minimum moves are included
    move_counts_integer = [moves for moves in move_counts_integer if moves >= min_moves]
    move_counts_float = [moves for moves in move_counts_float if moves >= min_moves]
    
    if verbose:
        print("Integer indexing failure rates:")
        print("Moves\tFailures\tTotal\tFailure Rate")
    
    for moves in move_counts_integer:
        failures = 0
        for _ in range(num_experiments):
            if simulate_integer_indexing(m, moves, initial_value_integer, reset_value_integer, False, auto_increment, increment_interval):
                failures += 1
        
        failure_rate = failures / num_experiments
        integer_failures[moves] = failure_rate
        if verbose:
            print(f"{moves}\t{failures}\t\t{num_experiments}\t{failure_rate:.3f}")
    
    if verbose:
        print("\nFloat indexing failure rates:")
        print("Moves\tFailures\tTotal\tFailure Rate")
    
    for moves in move_counts_float:
        failures = 0
        for _ in range(num_experiments):
            if simulate_float_indexing(n, moves, False, auto_increment, increment_interval):
                failures += 1
        
        failure_rate = failures / num_experiments
        float_failures[moves] = failure_rate
        if verbose:
            print(f"{moves}\t{failures}\t\t{num_experiments}\t{failure_rate:.3f}")
    
    return integer_failures, float_failures, move_counts_integer, move_counts_float

def visualize_results(integer_failures, float_failures, move_counts_integer, move_counts_float):
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
        from matplotlib.ticker import MultipleLocator
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
    plt.show()

def main():
    """Main function"""
    # Set parameters m=n=54
    m = DEFAULT_M
    n = DEFAULT_N
    max_moves = DEFAULT_MAX_MOVES
    min_moves = DEFAULT_MIN_MOVES
    num_experiments = DEFAULT_NUM_EXPERIMENTS  # Control number of experiments
    initial_value_integer = DEFAULT_INITIAL_VALUE_INTEGER
    reset_value_integer = DEFAULT_RESET_VALUE_INTEGER
    auto_increment = False  # Auto increment feature switch
    increment_interval = DEFAULT_INCREMENT_INTERVAL
    
    print(f"Running experiments with m=n={m}")
    print("=" * 50)
    
    # Run experiments
    integer_failures, float_failures, move_counts_integer, move_counts_float = run_experiments(
        m, n, max_moves, min_moves, num_experiments, initial_value_integer, reset_value_integer, 
        True, auto_increment, increment_interval)
    
    # Visualize results with new visualization parameters
    visualize_results(integer_failures, float_failures, move_counts_integer, move_counts_float)
    
    # Print summary of parameters and results
    print("\n" + "=" * 50)
    print("Experiment Summary:")
    print(f"Number of experiments per move count: {num_experiments}")
    print(f"Integer indexing move step size: {DEFAULT_STEP_INTEGER}")
    print(f"Float indexing move step size: {DEFAULT_STEP_FLOAT}")
    print(f"Minimum moves tested: {min_moves}")
    print(f"Maximum moves tested: {max_moves}")
    print(f"Integer indexing initial value: {initial_value_integer}")
    print(f"Integer indexing reset value: {reset_value_integer}")
    print(f"Auto increment: {auto_increment}")
    print(f"Increment interval: {increment_interval}")
    print("\nVisualization Parameters:")
    print(f"Chart size: {FIGURE_SIZE}")
    print(f"Integer color: {INTEGER_COLOR}")
    print(f"Float color: {FLOAT_COLOR}")
    print(f"Grid color: {GRID_COLOR}")
    print(f"Y-axis range: {Y_AXIS_MIN}-{Y_AXIS_MAX}")
    print(f"Grid density: {GRID_DENSITY}")
    print("\nTo adjust parameters, modify the values in the 'Parameter Adjustment Area' at the top of the code.")

if __name__ == "__main__":
    main()