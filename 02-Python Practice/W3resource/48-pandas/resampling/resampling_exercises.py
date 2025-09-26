import pandas as pd
import numpy as np

# Create time series data
dates = pd.date_range(start='2023-01-01', end='2023-12-31', freq='D')
df = pd.DataFrame({
    'date': dates,
    'value': np.random.randn(len(dates))
})
df.set_index('date', inplace=True)

print("Original daily data:")
print(df.head())

# Resample to monthly frequency
monthly = df.resample('M').mean()
print("\nMonthly averages:")
print(monthly)

# Resample to weekly frequency with sum
weekly = df.resample('W').sum()
print("\nWeekly sums:")
print(weekly)

# Rolling window calculations
rolling_avg = df.rolling(window=7).mean()
print("\n7-day rolling average:")
print(rolling_avg.head(10))