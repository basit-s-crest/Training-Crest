import pandas as pd
import numpy as np

# Create a DataFrame with missing values
df = pd.DataFrame({
    'A': [1, np.nan, 3, np.nan, 5],
    'B': [np.nan, 2, 3, 4, 5],
    'C': [1, 2, np.nan, 4, 5]
})

print("Original DataFrame with missing values:")
print(df)

# Check for missing values
print("\nMissing values count in each column:")
print(df.isnull().sum())

# Fill missing values with mean of column
df_filled = df.fillna(df.mean())
print("\nDataFrame after filling missing values with mean:")
print(df_filled)

# Drop rows with any missing values
df_dropped = df.dropna()
print("\nDataFrame after dropping rows with missing values:")
print(df_dropped)