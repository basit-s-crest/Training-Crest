import numpy as np

x = np.array([1, 2, 3, 4])
y = np.array([5, 6, 7, 8])

print("Original arrays:")
print("x =", x)
print("y =", y)

add_result = np.add(x, y)
multiply_result = np.multiply(x, y)
sqrt_result = np.sqrt(x)
exp_result = np.exp(x)

print("\nUniversal Function Results:")
print("Addition:", add_result)
print("Multiplication:", multiply_result)
print("Square root of x:", sqrt_result)
print("Exponential of x:", exp_result)