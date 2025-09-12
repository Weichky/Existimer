#!/usr/bin/env python3
"""
Run multiple independent simple_experiment tests with different configurations in parallel
"""

import os
import subprocess
import shutil
import sys
import matplotlib
matplotlib.use('Agg')  # 设置matplotlib后端为非交互式，避免弹出图形界面
from concurrent.futures import ProcessPoolExecutor, as_completed
import tempfile
import time
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
    handlers=[
        logging.FileHandler('experiment_log.txt', mode='w'),
        logging.StreamHandler()  # Also print to console
    ]
)

# 添加日志开关配置
ENABLE_DETAILED_LOGGING = True  # 设置为False可关闭详细日志输出以节省性能

# 获取当前脚本所在目录的绝对路径
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

def create_pic_directory():
    """Create pic directory if it doesn't exist"""
    if not os.path.exists('pic'):
        os.makedirs('pic')

def backup_simple_experiment():
    """Backup the original simple_experiment.py file"""
    if not os.path.exists('simple_experiment_backup.py'):
        shutil.copy2('simple_experiment.py', 'simple_experiment_backup.py')

def restore_simple_experiment():
    """Restore the original simple_experiment.py file"""
    if os.path.exists('simple_experiment_backup.py'):
        shutil.copy2('simple_experiment_backup.py', 'simple_experiment.py')

def modify_config_in_file(file_path, param_updates):
    """Modify configuration parameters in a specific file"""
    # Read the original file
    with open(file_path, 'r') as f:
        lines = f.readlines()
    
    # Modify the specified parameters
    for i, line in enumerate(lines):
        # Skip comments and empty lines
        stripped_line = line.strip()
        if stripped_line.startswith('#') or stripped_line == '':
            continue
            
        # Check if this line contains a parameter definition
        for param, value in param_updates.items():
            # More precise matching - look for "PARAM = VALUE" pattern
            if stripped_line.startswith(param + ' ='):
                if isinstance(value, bool):
                    lines[i] = f"{param} = {value}     # Modified parameter\n"
                elif isinstance(value, str):
                    lines[i] = f'{param} = "{value}"     # Modified parameter\n'
                else:
                    lines[i] = f"{param} = {value}     # Modified parameter\n"
                break
    
    # Write the modified file
    with open(file_path, 'w') as f:
        f.writelines(lines)

def log_info(message):
    """根据ENABLE_DETAILED_LOGGING开关决定是否记录详细日志"""
    if ENABLE_DETAILED_LOGGING:
        logging.info(message)
    # 即使不记录详细日志，也要确保关键信息被记录
    elif "Starting experiment" in message or "Experiment completed" in message or "Experiment failed" in message or "All experiments completed" in message:
        logging.info(message)

def run_single_experiment(args):
    """Run a single experiment in an isolated environment"""
    test_name, param_updates = args
    
    log_info(f"[{test_name}] Starting experiment: {test_name}")
    start_time = time.time()
    
    # Create a temporary directory for this experiment
    with tempfile.TemporaryDirectory() as temp_dir:
        # Copy all necessary files to the temporary directory using absolute paths
        shutil.copy2(os.path.join(SCRIPT_DIR, 'simple_experiment.py'), temp_dir)
        shutil.copy2(os.path.join(SCRIPT_DIR, 'simulation.py'), temp_dir)
        
        # Path to the experiment file in the temporary directory
        experiment_file = os.path.join(temp_dir, 'simple_experiment.py')
        
        # Add SHOW_PLOT = False to prevent interactive plots
        param_updates_with_plot = param_updates.copy()
        param_updates_with_plot["SHOW_PLOT"] = False
        # Enable data points output
        param_updates_with_plot["OUTPUT_DATA_POINTS"] = True
        # Set data points filename with test name
        param_updates_with_plot["DATA_POINTS_FILENAME"] = f"{test_name}_data_points.txt"
        
        # Modify configuration in the temporary file
        modify_config_in_file(experiment_file, param_updates_with_plot)
        
        # Run the experiment in the temporary directory
        try:
            # Use Popen for real-time output
            process = subprocess.Popen(
                [sys.executable, 'simple_experiment.py'], 
                cwd=temp_dir,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                bufsize=1,
                universal_newlines=True
            )
            
            # Read and log output in real-time
            while True:
                output = process.stdout.readline()
                if output == '' and process.poll() is not None:
                    break
                if output:
                    log_info(f"[{test_name}] {output.strip()}")
                    # 强制刷新日志以实现实时输出（仅在启用详细日志时）
                    if ENABLE_DETAILED_LOGGING:
                        for handler in logging.getLogger().handlers:
                            handler.flush()
            
            # Get the return code
            return_code = process.poll()
            end_time = time.time()
            elapsed_time = end_time - start_time
            
            if return_code == 0:
                log_info(f"[{test_name}] Experiment completed successfully in {elapsed_time:.2f} seconds")
                # Move the generated image to pic directory with descriptive name
                result_image = os.path.join(temp_dir, 'indexing_results.png')
                if os.path.exists(result_image):
                    shutil.copy2(result_image, f'pic/{test_name}_results.png')
                
                # Move the data points file to pic directory with descriptive name
                data_points_file = os.path.join(temp_dir, f'{test_name}_data_points.txt')
                if os.path.exists(data_points_file):
                    shutil.copy2(data_points_file, f'pic/{test_name}_data_points.txt')
                    
                return test_name, True, None, elapsed_time
            else:
                # Collect and log stderr output
                stderr_output = process.stderr.read()
                error_msg = f"Error output: {stderr_output}"
                log_info(f"[{test_name}] Experiment failed with return code {return_code} after {elapsed_time:.2f} seconds")
                log_info(f"[{test_name}] {error_msg}")
                return test_name, False, error_msg, elapsed_time
        except Exception as e:
            end_time = time.time()
            elapsed_time = end_time - start_time
            log_info(f"[{test_name}] Experiment failed with exception after {elapsed_time:.2f} seconds: {e}")
            return test_name, False, str(e), elapsed_time

def main():
    """Main function to run all experiments"""
    # Create pic directory
    create_pic_directory()
    
    # Define experiments
    experiments = [
        ("task1_default", {}),
        ("task2_no_auto_increment", {"AUTO_INCREMENT": False}),
        ("task3_increment_5", {"INCREMENT_INTERVAL": 5}),
        ("task4_increment_2", {"INCREMENT_INTERVAL": 2}),
        ("task5_mn_256", {"M": 256, "N": 256}),
        ("task6_mn_20", {"M": 20, "N": 20})
    ]
    
    log_info("Running multiple experiments in parallel")
    log_info("=" * 60)
    
    # Run experiments in parallel
    max_workers = min(len(experiments), os.cpu_count())  # Limit to number of experiments or CPU cores
    log_info(f"Running {len(experiments)} experiments in parallel with {max_workers} workers")
    
    completed_experiments = 0
    total_experiments = len(experiments)
    successful_experiments = 0
    start_time = time.time()
    
    with ProcessPoolExecutor(max_workers=max_workers) as executor:
        # Submit all experiments
        future_to_experiment = {executor.submit(run_single_experiment, exp): exp for exp in experiments}
        
        # Collect results as they complete
        for future in as_completed(future_to_experiment):
            test_name, success, error, elapsed_time = future.result()
            completed_experiments += 1
            if success:
                successful_experiments += 1
                log_info(f"✓ Completed {test_name} ({completed_experiments}/{total_experiments}) in {elapsed_time:.2f}s")
            else:
                log_info(f"✗ Failed {test_name} ({completed_experiments}/{total_experiments}) after {elapsed_time:.2f}s")
                if error:
                    log_info(f"[{test_name}] Error: {error}")
            
            # Log overall progress
            progress = (completed_experiments / total_experiments) * 100
            log_info(f"Overall progress: {completed_experiments}/{total_experiments} ({progress:.1f}%)")
            log_info("-" * 60)
            # 强制刷新日志以实现实时输出（仅在启用详细日志时）
            if ENABLE_DETAILED_LOGGING:
                for handler in logging.getLogger().handlers:
                    handler.flush()
    
    end_time = time.time()
    total_time = end_time - start_time
    
    log_info("=" * 60)
    log_info("All experiments completed!")
    log_info(f"Successfully completed: {successful_experiments}/{total_experiments}")
    log_info(f"Total execution time: {total_time:.2f} seconds")
    log_info("Results are in the 'pic' directory.")
    log_info("Detailed logs are in 'experiment_log.txt'")

if __name__ == "__main__":
    main()