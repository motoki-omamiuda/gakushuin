# importing from sympy library
import numpy as np
from scipy.optimize import minimize

func = lambda x: np.sqrt(x)
x = [10]
res = minimize(func, x, bounds=[(0, 40)])

# print(res.x)
# print((1 + 3j) ** (1 / 2))

from consts import THETA, MASS


def P(b):
    b_norm = b / (2 * MASS)
    var_00 = -b_norm ** 2 + b_norm ** 2 * (1 - (b_norm ** 2 / 27)) ** (1 / 2)
    var_01 = -b_norm ** 2 - b_norm ** 2 * (1 - (b_norm ** 2 / 27)) ** (1 / 2)
    print(var_00)
    print(var_01)
    print(var_00 ** (1 / 3) + var_01 ** (1 / 3))
    return var_00 ** (1 / 3) + var_01 ** (1 / 3)


print(P(10))
