
import numpy as np


x = np.array([1, 2, 3])


y = np.array([4, 5, 6, 7, 8, 9])


x_reshaped = x.reshape(3, 1)


y_reshaped = y.reshape(1, 6)


result = x_reshaped * y_reshaped

print("Reshaped Array x:\n", x_reshaped)
print("Reshaped Array y:\n", y_reshaped)
print("Result of element-wise multiplication:\n", result)
