import numpy as np


array_3d = np.random.randint(0, 100, size=(3, 4, 5))


row_indices = np.array([0, 1, 2])
col_indices = np.array([1, 2, 3])


selected_elements = array_3d[row_indices[:, np.newaxis], col_indices]


print('Original 3D array:\n', array_3d)
print('Row indices:\n', row_indices)
print('Column indices:\n', col_indices)
print('Selected elements:\n', selected_elements)
