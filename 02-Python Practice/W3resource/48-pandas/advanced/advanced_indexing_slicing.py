import pandas as pd

# Create a DataFrame
df = pd.DataFrame({
    'A': [1, 6, 8, 3, 7],
    'B': [5, 2, 9, 4, 1],
    'C': ['one', 'one', 'two', 'two', 'one']
})

# Set MultiIndex
df = df.set_index(['C', 'A'])

# Slice DataFrame
result = df.loc['one']
print(result)
