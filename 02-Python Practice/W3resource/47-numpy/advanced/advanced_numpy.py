import numpy as np

# Advanced NumPy Features
def demonstrate_advanced_features():
    # Advanced array creation
    print("1. Creating arrays with complex operations:")
    grid = np.mgrid[0:5, 0:5]
    print("Grid array:\n", grid)

    # Advanced indexing
    print("\n2. Advanced boolean indexing:")
    arr = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
    mask = arr > 5
    print("Values greater than 5:", arr[mask])

    # Custom ufunc
    print("\n3. Custom universal function:")
    def custom_operation(x):
        return np.sqrt(x) + np.sin(x)
    
    x = np.array([1, 2, 3, 4])
    result = custom_operation(x)
    print("Custom operation result:", result)

    # Structured arrays with advanced features
    print("\n4. Advanced structured arrays:")
    dt = np.dtype([
        ('name', 'U10'),
        ('scores', 'i4', (2,)),
        ('rank', 'f8')
    ])
    students = np.array([
        ('Alice', [85, 90], 1.5),
        ('Bob', [75, 85], 2.1)
    ], dtype=dt)
    print("Students data:\n", students)

if __name__ == "__main__":
    demonstrate_advanced_features()