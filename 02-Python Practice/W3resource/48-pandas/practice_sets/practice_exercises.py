import pandas as pd
import numpy as np



def exercise1():
    """Sales Analysis"""
  
    sales_data = {
        'date': pd.date_range(start='2023-01-01', periods=10),
        'product': ['A', 'B', 'A', 'C', 'B', 'A', 'C', 'B', 'A', 'C'],
        'quantity': [10, 15, 12, 8, 20, 25, 14, 18, 22, 16],
        'price': [100, 150, 100, 200, 150, 100, 200, 150, 100, 200]
    }
    df = pd.DataFrame(sales_data)

    df['total'] = df['quantity'] * df['price']
    
    print("Exercise 1: Sales Analysis")
    print("\nOriginal Data:")
    print(df)
    
    print("\nSales Summary by Product:")
    product_summary = df.groupby('product').agg({
        'quantity': 'sum',
        'total': 'sum'
    })
    print(product_summary)

def exercise2():
    """Customer Analysis"""
  
    customer_data = {
        'customer_id': range(1, 6),
        'name': ['John', 'Emma', 'Alex', 'Sarah', 'Mike'],
        'purchases': [5, 8, 3, 10, 7],
        'total_spent': [500, 800, 300, 1000, 700]
    }
    df = pd.DataFrame(customer_data)
    
    print("\nExercise 2: Customer Analysis")
    print("\nCustomer Data:")
    print(df)
    
 
    df['average_purchase'] = df['total_spent'] / df['purchases']
    df['segment'] = pd.qcut(df['total_spent'], q=3, labels=['Low', 'Medium', 'High'])
    
    print("\nCustomer Segments:")
    print(df[['name', 'total_spent', 'average_purchase', 'segment']])

if __name__ == "__main__":
    exercise1()
    exercise2()