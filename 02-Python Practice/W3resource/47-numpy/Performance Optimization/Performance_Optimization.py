import numpy as np


large_array = np.random.rand(100, 100, 100)

def sum_using_loops(array):
    total_sum = 0.0
    for i in range(array.shape[0]):
        for j in range(array.shape[1]):
            for k in range(array.shape[2]):
                total_sum += array[i, j, k]
    return total_sum

sum_loop = sum_using_loops(large_array)
print("Sum using nested for loops:", sum_loop)


sum_numpy = np.sum(large_array)
print("Sum using NumPy's built-in function:", sum_numpy)
