# library
import numpya as np
import mpmath as mp
from sympy import nsolve

# constants
from consts import THETA, MASS


def alpha(phi):
    return np.acos(
        (np.cos(phi) * np.cos(THETA))
        / np.sqrt(1 - np.cos(phi) ** 2 * np.sin(THETA) ** 2)
    )


def gamma(phi):
    return np.acos(
        np.cos(alpha(phi))
        / np.sqrt(np.cos(alpha(phi)) ** 2 + (np.cos(THETA) / np.sin(THETA)) ** 2)
    )


def P(b):
    y = b / MASS
    return (
        (-y ** 2 + y ** 2 * np.sqrt(1 - (y ** 2 / 27))) ** (1 / 3)
        + (-y ** 2 - y ** 2 * np.sqrt(1 - (y ** 2 / 27))) ** (1 / 3)
    )


def Q(P):
    return np.sqrt((P - 2 * MASS) * (P + 6 * MASS))


def m(P):
    return (Q(P) - P + 6 * MASS) / (2 * Q(P))


def b(P):
    return np.sqrt(P ** 3 / (P - 2 * MASS))


def zeta_inf(P):
    return np.asin(
        np.sqrt((Q(P) - P + 2 * MASS) / (Q(P) - P + 6 * MASS))
    )


def zeta_r(P, r):
    return np.asin(
        np.sqrt((Q(P) - P + 2 * MASS + (4 * MASS * P / r)) / (Q(P) - P + 6 * MASS))
    )


def function(b, r, phi, n=0):
    tmp_gamma = gamma(phi)
    if n == 0:
        inner = tmp_gamma * np.sqrt(Q(P(b)) / P(b)) / 2 + mp.ellipf(zeta_inf(P(b)), m(P(b)))
    else:
        inner = (
            2 * mp.ellipk(m(P(b)))
            - mp.ellipf(zeta_inf(P(b)), m(P(b)))
            - np.sqrt(Q(P) / P(b)) * (2 * np.pi * n - tmp_gamma) / 2
        )
    return (
        (Q(P(b)) - P(b) + 6 * MASS) / (4 * MASS * P(b))
        * mp.ellipfun("sn", inner, m(P(b))) ** 2
        - (Q(P(b)) - P(b) + 2 * MASS) / (4 * MASS * P(b))
        - 1 / r
    )


def calculate_image(r, phi):
    f = lambda b: function(b, r, phi)

    return b, alpha
