import pandas as pd
import numpy as np
import time

# Create a large DataFrame for performance testing
n_rows = 1000000
df = pd.DataFrame({
    'id': range(n_rows),
    'value': np.random.randn(n_rows),
    'category': np.random.choice(['A', 'B', 'C'], n_rows)
})

# Measure performance of different operations
print("Performance comparison of different operations:\n")

# Method 1: Using loc
start_time = time.time()
result1 = df.loc[df['category'] == 'A']
time1 = time.time() - start_time
print(f"Time using loc: {time1:.4f} seconds")

# Method 2: Using query
start_time = time.time()
result2 = df.query('category == "A"')
time2 = time.time() - start_time
print(f"Time using query: {time2:.4f} seconds")

# Method 3: Direct boolean indexing
start_time = time.time()
result3 = df[df['category'] == 'A']
time3 = time.time() - start_time
print(f"Time using boolean indexing: {time3:.4f} seconds")