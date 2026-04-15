import sqlite3
import time
import random
import matplotlib.pyplot as plt
import numpy as np
import math
import os

DB_FILE = 'test_times.db'
ORDER_INDEX_GAP = 1

# 这里使用你之前测得的典型单条时间（秒）
t_w = 0.00000107     # single write time
t_s = 0.00000983     # single search time (log factor included later)

def setup_db(record_count):
    if os.path.exists(DB_FILE):
        os.remove(DB_FILE)

    conn = sqlite3.connect(DB_FILE)
    c = conn.cursor()
    c.execute('''
        CREATE TABLE test_data (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            order_index INTEGER,
            value INTEGER
        )
    ''')
    conn.commit()

    data = [(i * ORDER_INDEX_GAP, random.randint(0, 2**63-1)) for i in range(record_count)]
    c.executemany('INSERT INTO test_data (order_index, value) VALUES (?, ?)', data)
    conn.commit()

    return conn

def reorder_all(conn):
    c = conn.cursor()
    c.execute('SELECT id, order_index FROM test_data ORDER BY order_index ASC')
    records = c.fetchall()

    with conn:
        for i, (rowid, _) in enumerate(records):
            new_order = (i + 1) * ORDER_INDEX_GAP
            c.execute('UPDATE test_data SET order_index = ? WHERE id = ?', (new_order, rowid))

def model_time(N):
    # model = (t_s * log2(N) + t_w) * N
    if N == 0:
        return 0
    return (t_s * math.log2(N) + t_w) * N * 0.01
    # return 0.00002142 * N * 0.05

def main():
    record_counts = []
    times = []

    test_sizes = [10, 100, 1000, 10_000, 100_000, 1_000_000]

    for count in test_sizes:
        print(f"Testing with {count} records...")
        conn = setup_db(count)

        start = time.time()
        reorder_all(conn)
        end = time.time()

        elapsed = end - start
        print(f"Reorder time: {elapsed:.4f} seconds")

        record_counts.append(count)
        times.append(elapsed)

        conn.close()

    # 计算模型时间
    model_times = [model_time(N) for N in record_counts]

    # 绘图
    plt.figure(figsize=(10, 6))
    plt.plot(record_counts, times, marker='o', color='#5c6bc0', linewidth=2, label='Measured Reorder Time')  # Indigo
    plt.plot(record_counts, model_times, marker='x', color='#f57c00', linewidth=2, label='Model: (t_s*log2(N) + t_w)*N')  # Orange

    plt.xscale('log')
    plt.yscale('log')
    plt.xlabel('Record Count (log scale)', fontsize=14)
    plt.ylabel('Time (seconds, log scale)', fontsize=14)
    plt.title('SQLite reorderAll Performance vs Model', fontsize=16)
    plt.grid(True, which="both", ls="--", linewidth=0.5, alpha=0.7)
    plt.legend()
    plt.tight_layout()
    plt.show()

if __name__ == "__main__":
    main()
