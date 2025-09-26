import numpy as np

def demonstrate_mastering_numpy():
    # 1. Advanced array operations
    print("1. Advanced Array Operations:")
    arr = np.arange(12).reshape(3, 4)
    print("Original array:")
    print(arr)
    
    # Views vs Copies
    print("\n2. Views vs Copies:")
    view = arr.view()
    copy = arr.copy()
    arr[0, 0] = 99
    print("After modifying original:")
    print("Original:", arr[0, 0])
    print("View:", view[0, 0])
    print("Copy:", copy[0, 0])

    # Memory optimization
    print("\n3. Memory Optimization:")
    large_array = np.arange(1000000)
    print(f"Memory usage: {large_array.nbytes / 1024:.2f} KB")
    small_dtype = large_array.astype(np.int32)
    print(f"Optimized memory: {small_dtype.nbytes / 1024:.2f} KB")

    # Broadcasting
    print("\n4. Advanced Broadcasting:")
    a = np.array([[1, 2, 3], [4, 5, 6]])
    b = np.array([10, 20, 30])
    print("Broadcasting result:")
    print(a * b)

if __name__ == "__main__":
    demonstrate_mastering_numpy()