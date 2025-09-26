import pandas as pd
import numpy as np

# Create sample data
data = {
    'category': ['A', 'A', 'B', 'B', 'A', 'B'],
    'subcategory': ['X', 'Y', 'X', 'Y', 'X', 'Y'],
    'value': [10, 15, 20, 25, 30, 35]
}
df = pd.DataFrame(data)

print("Original DataFrame:")
print(df)

# Advanced grouping operations
# 1. Multiple level grouping
grouped = df.groupby(['category', 'subcategory']).agg({
    'value': ['sum', 'mean', 'count']
})
print("\nMulti-level grouping:")
print(grouped)

# 2. Custom aggregation function
def custom_agg(x):
    return pd.Series({
        'mean': x.mean(),
        'sum': x.sum(),
        'range': x.max() - x.min()
    })

custom_grouped = df.groupby('category')['value'].apply(custom_agg)
print("\nCustom aggregation:")
print(custom_grouped)