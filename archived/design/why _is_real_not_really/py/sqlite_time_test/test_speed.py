import sqlite3
import time
import random
import os

DB_FILE = "test_times.db"
NUM_TOTAL = 1000000  # 总插入量
NUM_SAMPLE = 100000    # 测写入样本数
NUM_QUERY = 100000   # 测读取和查找样本数
ORDER_INDEX_GAP = 1000

def setup_db():
    if os.path.exists(DB_FILE):
        os.remove(DB_FILE)
    conn = sqlite3.connect(DB_FILE)
    c = conn.cursor()
    c.execute("CREATE TABLE test_data (id INTEGER PRIMARY KEY AUTOINCREMENT, order_index INTEGER, value INTEGER)")
    c.execute("CREATE INDEX idx_order_index ON test_data(order_index)")  # 添加索引以优化排序操作
    conn.commit()

    # 批量插入NUM_TOTAL条数据，按照reorder的模式预留间隔
    data = [(i * ORDER_INDEX_GAP, random.randint(0, 2**63-1)) for i in range(NUM_TOTAL)]
    c.executemany("INSERT INTO test_data (order_index, value) VALUES (?, ?)", data)
    conn.commit()
    return conn

def measure_write_time_with_transaction(conn):
    c = conn.cursor()
    test_data = [(NUM_TOTAL * ORDER_INDEX_GAP + i, random.randint(0, 2**63-1)) for i in range(NUM_SAMPLE)]

    start = time.time()
    c.execute("BEGIN TRANSACTION;")
    for order_idx, val in test_data:
        c.execute("INSERT INTO test_data (order_index, value) VALUES (?, ?)", (order_idx, val))
    conn.commit()
    end = time.time()
    return (end - start) / NUM_SAMPLE

def measure_update_time(conn):
    c = conn.cursor()
    # 随机选择一些记录进行更新，模拟reorder操作
    ids = random.sample(range(1, NUM_TOTAL+1), min(NUM_SAMPLE, NUM_TOTAL))
    start = time.time()
    c.execute("BEGIN TRANSACTION;")
    for id_ in ids:
        new_order_index = random.randint(0, 2**63-1)
        c.execute("UPDATE test_data SET order_index = ? WHERE id = ?", (new_order_index, id_))
    conn.commit()
    end = time.time()
    return (end - start) / len(ids)

def measure_read_time(conn):
    c = conn.cursor()
    # 随机查询NUM_QUERY条记录，读取value字段，计算平均时间
    ids = random.sample(range(1, NUM_TOTAL+1), NUM_QUERY)
    start = time.time()
    for id_ in ids:
        c.execute("SELECT value FROM test_data WHERE id = ?", (id_,))
        c.fetchone()
    end = time.time()
    return (end - start) / NUM_QUERY

def measure_search_time_by_id(conn):
    c = conn.cursor()
    # 随机查询NUM_QUERY条记录，只读取order_index（索引列），计算平均时间
    ids = random.sample(range(1, NUM_TOTAL+1), NUM_QUERY)
    start = time.time()
    for id_ in ids:
        c.execute("SELECT order_index FROM test_data WHERE id = ?", (id_,))
        c.fetchone()
    end = time.time()
    return (end - start) / NUM_QUERY

def measure_sort_time(conn):
    c = conn.cursor()
    # 测量排序时间，模拟reorder中的排序操作
    start = time.time()
    c.execute("SELECT id, order_index FROM test_data ORDER BY order_index ASC")
    c.fetchall()  # 获取所有结果
    end = time.time()
    return end - start

def measure_reorder_simulation(conn):
    """
    模拟完整的reorder操作：排序+更新
    这更接近实际的reorder_all函数操作
    """
    c = conn.cursor()
    
    # 测量排序时间
    start_sort = time.time()
    c.execute("SELECT id, order_index FROM test_data ORDER BY order_index ASC")
    records = c.fetchall()
    sort_time = time.time() - start_sort
    
    # 测量更新时间（使用事务）
    start_update = time.time()
    with conn:
        for i, (rowid, _) in enumerate(records[:min(NUM_SAMPLE, len(records))]):
            new_order = (i + 1) * ORDER_INDEX_GAP
            c.execute('UPDATE test_data SET order_index = ? WHERE id = ?', (new_order, rowid))
    update_time = time.time() - start_update
    
    return sort_time, update_time / len(records[:min(NUM_SAMPLE, len(records))])

def measure_single_reorder_operation(conn):
    """
    测量单次reorder操作的时间（包含排序和更新）
    """
    c = conn.cursor()
    
    start = time.time()
    # 完整模拟reorder_all操作，但只处理部分数据以控制测试时间
    c.execute("SELECT id, order_index FROM test_data ORDER BY order_index ASC")
    records = c.fetchall()
    
    with conn:
        for i, (rowid, _) in enumerate(records[:min(NUM_SAMPLE, len(records))]):
            new_order = (i + 1) * ORDER_INDEX_GAP
            c.execute('UPDATE test_data SET order_index = ? WHERE id = ?', (new_order, rowid))
    
    end = time.time()
    return (end - start) / len(records[:min(NUM_SAMPLE, len(records))])

def main():
    conn = setup_db()
    t_w = measure_write_time_with_transaction(conn)
    t_u = measure_update_time(conn)
    t_r = measure_read_time(conn)
    t_s = measure_search_time_by_id(conn)
    t_sort = measure_sort_time(conn)
    t_reorder = measure_single_reorder_operation(conn)
    
    # 获取排序和更新的分离时间
    sort_time, update_time_per_record = measure_reorder_simulation(conn)
    
    conn.close()

    print(f"单条写入并提交事务平均时间 t_w: {t_w:.8f} 秒")
    print(f"单条更新平均时间 t_u: {t_u:.8f} 秒")
    print(f"单条读取平均时间 t_r: {t_r:.8f} 秒")
    print(f"单条索引查找平均时间 t_s: {t_s:.8f} 秒")
    print(f"全表排序时间 t_sort: {t_sort:.8f} 秒")
    print(f"单次完整reorder操作时间 t_reorder: {t_reorder:.8f} 秒")
    print(f"排序部分时间: {sort_time:.8f} 秒")
    print(f"单条记录更新时间(模拟reorder): {update_time_per_record:.8f} 秒")

if __name__ == "__main__":
    main()