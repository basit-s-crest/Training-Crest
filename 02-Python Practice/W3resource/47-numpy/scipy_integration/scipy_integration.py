import numpy as np
from scipy import linalg
from scipy import special

# Create a sample matrix
A = np.array([[1, 2], [3, 4]])
b = np.array([5, 6])

print("Matrix A:")
print(A)
print("\nVector b:", b)

# Solve linear system using SciPy
solution = linalg.solve(A, b)
print("\nSolution to Ax = b:", solution)

# Special functions from SciPy
x = np.array([1.0, 2.0, 3.0])
bessel = special.j0(x)
print("\nBessel function of first kind:", bessel)