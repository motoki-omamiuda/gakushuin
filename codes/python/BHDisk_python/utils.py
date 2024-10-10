# library
import numpy as np
import mpmath as mp

from scipy.optimize import minimize

# constants
from consts import THETA, MASS


def alpha(phi):
    return np.arccos(
        (np.cos(phi) * np.cos(THETA))
        / np.sqrt(1 - np.cos(phi) ** 2 * np.sin(THETA) ** 2)
    )


def gamma(phi):
    return np.arccos(
        np.cos(alpha(phi))
        / np.sqrt(np.cos(alpha(phi)) ** 2 + (np.cos(THETA) / np.sin(THETA)) ** 2)
    )


def P(b):
    b_norm = b / MASS
    var_00 = -b_norm ** 2 + b_norm ** 2 * complex(1 - (b_norm ** 2 / 27)) ** (0.5)
    var_01 = -b_norm ** 2 - b_norm ** 2 * complex(1 - (b_norm ** 2 / 27)) ** (0.5)
    # print(var_00)
    # print(var_01)
    # print(var_00 ** (1 / 3) + var_01 ** (1 / 3))
    return var_00 ** (1 / 3) + var_01 ** (1 / 3)


def Q(P):
    return ((P - 2 * MASS) * (P + 6 * MASS)) ** (1 / 2)


def m(P):
    return (Q(P) - P + 6 * MASS) / (2 * Q(P))


def b(P):
    return np.sqrt(P ** 3 / (P - 2 * MASS))


def zeta_inf(P):
    return np.arcsin(
        np.sqrt((Q(P) - P + 2 * MASS) / (Q(P) - P + 6 * MASS))
    )


def zeta_r(P, r):
    return np.arcsin(
        np.sqrt((Q(P) - P + 2 * MASS + (4 * MASS * P / r)) / (Q(P) - P + 6 * MASS))
    )


def function(b, r, phi, n=0):
    b = b[0]
    gamma_var = gamma(phi)
    P_var = P(b)
    Q_var = Q(P(b))
    m_var = m(P(b))
    print(gamma_var)
    print(P_var)
    print(Q_var)
    print(m_var)
    if n == 0:
        inner = gamma_var * complex(Q_var / P_var) ** (0.5) / 2 + mp.ellipf(zeta_inf(P_var), m_var)
    else:
        inner = (
            2 * mp.ellipk(m_var)
            - mp.ellipf(zeta_inf(P_var), m_var)
            - np.sqrt(Q_var / P_var) * (2 * np.pi * n - gamma_var) / 2
        )
    print(Q_var / P_var)
    print(inner)
    return abs(
        (Q_var - P_var + 6 * MASS) / (4 * MASS * P_var)
        * mp.ellipfun("sn", inner, m_var) ** 2
        - (Q_var - P_var + 2 * MASS) / (4 * MASS * P_var)
        - 1 / r
    )


def calculate_image(r, phi):
    f = lambda b: function(b, r, phi)
    b_var = minimize(f, [0], bounds=[(0 * MASS, 40 * MASS)])
    alpha_var = alpha(phi)
    return b_var, alpha_var
