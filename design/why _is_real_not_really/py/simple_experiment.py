#!/usr/bin/env python3
"""
Simple Experiment File - Non-parallel Version
This file provides a simple experimental interface without parallel processing
"""

import time
import matplotlib.pyplot as plt

# ==================== Experimental Parameter Configuration ====================
# Basic parameters
M = 54                    # Number of elements in integer indexing system
N = 54                    # Number of elements in float indexing system
MAX_MOVES = 1800          # Maximum number of moves
MIN_MOVES = 1             # Minimum number of moves

# Experimental parameters
NUM_EXPERIMENTS = 2000    # Number of experiments

# Integer indexing specific parameters
INITIAL_VALUE_INTEGER = 55  # Integer indexing initial value
RESET_VALUE_INTEGER = 55    # Integer indexing reset value

# Step parameters
STEP_INTEGER = 10         # Integer indexing move step size
STEP_FLOAT = 10           # Float indexing move step size

# Auto increment parameters
AUTO_INCREMENT = True     # Auto increment feature switch
INCREMENT_INTERVAL = 10   # Increment interval

# Output control
VERBOSE = True            # Whether to output detailed information
# ==============================================================================

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
    
    if VERBOSE:
        print("Integer indexing failure rates:")
        print("Moves\tFailures\tTotal\tFailure Rate")
    
    for moves in move_counts_integer:
        failures = run_integer_indexing_experiments(m, moves, initial_value_integer, reset_value_integer, auto_increment, increment_interval, num_experiments)
        failure_rate = failures / num_experiments
        integer_failures[moves] = failure_rate
        if VERBOSE:
            print(f"{moves}\t{failures}\t\t{num_experiments}\t{failure_rate:.3f}")
    
    if VERBOSE:
        print("\nFloat indexing failure rates:")
        print("Moves\tFailures\tTotal\tFailure Rate")
    
    for moves in move_counts_float:
        failures = run_float_indexing_experiments(n, moves, auto_increment, increment_interval, num_experiments)
        failure_rate = failures / num_experiments
        float_failures[moves] = failure_rate
        if VERBOSE:
            print(f"{moves}\t{failures}\t\t{num_experiments}\t{failure_rate:.3f}")
    
    return integer_failures, float_failures

def visualize_results(integer_failures, float_failures):
    """Visualize results"""
    # Create two subplots
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 5))
    
    # Plot integer indexing results
    moves_integer = list(integer_failures.keys())
    rates_integer = list(integer_failures.values())
    ax1.plot(moves_integer, rates_integer, 'bo-', label='Integer Indexing')
    ax1.set_xlabel('Number of Moves')
    ax1.set_ylabel('Failure Rate')
    ax1.set_title('Integer Indexing Failure Rate vs Moves')
    ax1.grid(True)
    ax1.legend()
    
    # Plot float indexing results
    moves_float = list(float_failures.keys())
    rates_float = list(float_failures.values())
    ax2.plot(moves_float, rates_float, 'ro-', label='Float Indexing')
    ax2.set_xlabel('Number of Moves')
    ax2.set_ylabel('Failure Rate')
    ax2.set_title('Float Indexing Failure Rate vs Moves')
    ax2.grid(True)
    ax2.legend()
    
    plt.tight_layout()
    plt.savefig('indexing_results.png')
    plt.show()

def run_simple_experiments():
    """Run simple experiments"""
    print(f"Running simple experiments with m=n={M}")
    print(f"Auto increment: {AUTO_INCREMENT}, Interval: {INCREMENT_INTERVAL}")
    print("=" * 60)
    
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
    
    # Visualize results
    visualize_results(integer_failures, float_failures)
    
    # Print summary
    print("\n" + "=" * 60)
    print("Experiment Summary:")
    print(f"- Elements count: Integer={M}, Float={N}")
    print(f"- Move range: {MIN_MOVES} to {MAX_MOVES}")
    print(f"- Experiments per data point: {NUM_EXPERIMENTS}")
    print(f"- Integer indexing initial/reset value: {INITIAL_VALUE_INTEGER}/{RESET_VALUE_INTEGER}")
    print(f"- Integer indexing step size: {STEP_INTEGER}")
    print(f"- Float indexing step size: {STEP_FLOAT}")
    print(f"- Auto increment: {AUTO_INCREMENT} (interval: {INCREMENT_INTERVAL})")
    print(f"- Total execution time: {end_time - start_time:.2f} seconds")

if __name__ == "__main__":
    run_simple_experiments()