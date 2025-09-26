
import numpy as np

array = np.array([1, -2, np.inf, -np.inf, 0, 3.5])

result_pos_inf = np.isposinf(array)
result_neg_inf = np.isneginf(array)

print("Element-wise positive infinity check:", result_pos_inf)
print("Element-wise negative infinity check:", result_neg_inf) 
