import numpy as np

data_dict = {'a': 1, 'b': 2, 'c': 3, 'd': 4, 'e': 5}

print("Original dictionary with numeric values:",data_dict)
print("Type:",type(data_dict))

numpy_array = np.array(list(data_dict.values()))
print("\nDictionary values to a NumPy array")

print(numpy_array)
print(type(numpy_array))
