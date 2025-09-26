import numpy as np
import numpy.ma as ma

data = np.array([1, 2, -999, 4, -999, 6])
masked_data = ma.masked_array(data, mask=data == -999)

print("Original array:", data)
print("Masked array:", masked_data)
print("Mean of masked array:", masked_data.mean())
print("Sum of masked array:", masked_data.sum())

filled_data = masked_data.filled(fill_value=0)
print("\nFilled array (replacing masked values with 0):", filled_data)