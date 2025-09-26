import pandas as pd
import numpy as np

# Create sample data
data = {
    'Date': pd.date_range(start='2023-01-01', periods=5),
    'Product': ['A', 'B', 'A', 'B', 'A'],
    'Sales': [100, 150, 200, 120, 180]
}
df = pd.DataFrame(data)

print("Original DataFrame:")
print(df)

# Create pivot table
pivot = pd.pivot_table(df, 
                      values='Sales',
                      index='Product',
                      columns=pd.Grouper(key='Date', freq='M'),
                      aggfunc='sum')

print("\nPivot Table (Sales by Product and Month):")
print(pivot)