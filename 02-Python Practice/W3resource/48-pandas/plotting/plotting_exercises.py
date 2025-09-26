import pandas as pd
import matplotlib.pyplot as plt

# Create sample data
data = {
    'Year': range(2015, 2023),
    'Sales': [100, 120, 140, 180, 200, 220, 250, 280]
}
df = pd.DataFrame(data)

# Create basic plot
plt.figure(figsize=(10, 6))
df.plot(x='Year', y='Sales', kind='line', marker='o')
plt.title('Sales Trend Over Years')
plt.xlabel('Year')
plt.ylabel('Sales')
plt.grid(True)

print("Original DataFrame:")
print(df)
print("\nNote: Plot will be displayed when running in interactive environment")