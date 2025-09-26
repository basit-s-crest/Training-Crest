import numpy as np


data_array = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

binary_file_path = 'data.npy'

np.save(binary_file_path, data_array)

loaded_array = np.load(binary_file_path)


print("Original NumPy Array:")
print(data_array)

print("\nLoaded NumPy Array from Binary File:")
print(loaded_array)
