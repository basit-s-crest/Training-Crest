import pandas as pd
import numpy as np

# Create a DataFrame with date information
dates = pd.date_range(start='2023-01-01', end='2023-12-31', freq='M')
df = pd.DataFrame({
    'date': dates,
    'value': np.random.randn(len(dates))
})

print("Original DataFrame:")
print(df)

# Date operations
print("\nYear from dates:")
print(df['date'].dt.year)

print("\nMonth from dates:")
print(df['date'].dt.month)

# Add new date columns
df['year'] = df['date'].dt.year
df['month'] = df['date'].dt.month
df['day'] = df['date'].dt.day

print("\nDataFrame with extracted date components:")
print(df)