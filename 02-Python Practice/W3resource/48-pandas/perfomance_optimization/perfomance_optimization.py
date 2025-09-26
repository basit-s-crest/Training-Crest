import pandas as pd  # Import the Pandas library
import numpy as np  # Import the NumPy library

# Create a sample DataFrame with mixed data types
np.random.seed(0)  # Set seed for reproducibility
data = {
    'int_col': np.random.randint(0, 100, size=100000),
    'float_col': np.random.random(size=100000) * 100,
    'category_col': np.random.choice(['A', 'B', 'C'], size=100000),
    'object_col': np.random.choice(['foo', 'bar', 'baz'], size=100000)
}
df = pd.DataFrame(data)

# Print memory usage before optimization
print("Memory usage before optimization:")
print(df.info(memory_usage='deep'))

# Convert data types using astype method
df['int_col'] = df['int_col'].astype('int16')
df['float_col'] = df['float_col'].astype('float32')
df['category_col'] = df['category_col'].astype('category')
df['object_col'] = df['object_col'].astype('category')

# Print memory usage after optimization
print("\nMemory usage after optimization:")
print(df.info(memory_usage='deep'))
