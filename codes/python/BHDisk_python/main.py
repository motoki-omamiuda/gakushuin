# library
import matplotlib.pyplot as plt
import numpy as np

# utils
from utils import (
    calculate_image,
)

# constants
from consts import (
    THETA,
    MASS,
)


def initialize():
    """
    Initialize the plot.
    """
    global fig, ax
    fig, ax = plt.subplots()
    ax.set_xlim(-35, 35)
    ax.set_ylim(-35, 35)
    ax.set_aspect('equal')  # アスペクト比を指定
    # ax.legend().set_visible(False)  # 凡例を非表示にする

    theta = np.linspace(0, 2 * np.pi, 100)
    for i, j in zip([2, 3 * np.sqrt(3)], [0.6, 0.3]):
        x = i * MASS * np.cos(theta)
        y = i * MASS * np.sin(theta)
        plt.fill(x, y, color='black', alpha=j)
    return None


def main():
    b_list = []
    alpha_list = []

    r = 2 * MASS
    phi = 2 * np.pi / 3
    b, alpha = calculate_image(r, phi)
    print(f"b\t{b}", end="\t")
    print(f"alpha\t{alpha}", end="\t")
    return None


def output():
    """
    output the plot.
    """
    plt.savefig("output.png", dpi=800)
    # plt.show()
    return None


if __name__ == "__main__":
    initialize()
    main()
    plt.plot([0, 2 * MASS * np.cos(THETA)], [0, 2 * MASS * np.sin(THETA)], color='black')
    output()
