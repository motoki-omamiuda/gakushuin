import mpmath as mp


print(mp.ellipk(0.5))
print(mp.ellipf(1 + 3j, 0.5))
print(mp.ellipfun("sn", 1 + 3j, 0.5))


import numpy as np
from scipy.optimize import root_scalar

# 関数 f を定義（np.sqrt を使用）
def f(a):
    return np.sqrt(a - 1)


# 解を求める範囲を指定
solution = root_scalar(f, bracket=[2, 4])

if solution.converged:
    print(f"Solution: {solution.root}")
else:
    print("No solution found in the given range.")
