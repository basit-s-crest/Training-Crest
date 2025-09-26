import pandas as pd
import sqlite3

# Create a sample SQLite database
conn = sqlite3.connect(':memory:')
df = pd.DataFrame({
    'id': range(1, 6),
    'name': ['John', 'Emma', 'Alex', 'Sarah', 'Mike'],
    'salary': [50000, 60000, 45000, 55000, 65000]
})
df.to_sql('employees', conn, index=False)

# SQL query examples
print("1. Basic SELECT query:")
query1 = "SELECT * FROM employees WHERE salary > 50000"
result1 = pd.read_sql_query(query1, conn)
print(result1)

print("\n2. Aggregation query:")
query2 = "SELECT AVG(salary) as avg_salary FROM employees"
result2 = pd.read_sql_query(query2, conn)
print(result2)

print("\n3. GROUP BY query:")
query3 = """
SELECT 
    CASE 
        WHEN salary >= 60000 THEN 'High'
        WHEN salary >= 50000 THEN 'Medium'
        ELSE 'Low'
    END as salary_category,
    COUNT(*) as count
FROM employees
GROUP BY salary_category
"""
result3 = pd.read_sql_query(query3, conn)
print(result3)

conn.close()