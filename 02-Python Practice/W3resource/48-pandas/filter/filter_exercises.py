import pandas as pd
import numpy as np

# Create a sample DataFrame
df = pd.DataFrame({
    'name': ['John', 'Emma', 'Alex', 'Sarah', 'James'],
    'age': [25, 30, 22, 28, 32],
    'salary': [50000, 60000, 45000, 55000, 65000]
})

print("Original DataFrame:")
print(df)

# Filter rows where age is greater than 25
filtered_age = df[df['age'] > 25]
print("\nEmployees older than 25:")
print(filtered_age)

# Filter rows with salary greater than mean
mean_salary = df['salary'].mean()
high_salary = df[df['salary'] > mean_salary]
print("\nEmployees with above average salary:")
print(high_salary)