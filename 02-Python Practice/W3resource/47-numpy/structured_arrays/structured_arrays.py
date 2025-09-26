import numpy as np

dt = np.dtype([('name', 'U10'), ('age', 'i4'), ('salary', 'f8')])
employees = np.array([
    ('John', 25, 50000.0),
    ('Alice', 30, 65000.0),
    ('Bob', 35, 75000.0)
], dtype=dt)

print("Structured Array:")
print(employees)
print("\nAccessing fields:")
print("Names:", employees['name'])
print("Ages:", employees['age'])
print("Salaries:", employees['salary'])

filtered = employees[employees['age'] > 28]
print("\nEmployees older than 28:")
print(filtered)