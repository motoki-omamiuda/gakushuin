from utils import (
    read_text, test_plot, regression
)

# pip libraries
import numpy as np
import matplotlib.pyplot as plt


def main() -> None:
    # data = read_text("./julia/buchdahl-disk/datas/0.3-80-1-00.txt")
    data = read_text("./julia/buchdahl-disk-ver2/data/1.5-80-0-00.txt")

    a_list = []
    b_list = []
    for data_element in data:
        a_list.append(data_element[0])
        b_list.append(data_element[1])

    a_list = np.array(a_list)
    b_list = np.array(b_list)
    # test_plot(a_list, b_list)

    region = [a_list[0], a_list[-1]]
    a_smooth, b_smooth = regression(a_list, b_list, region)
    # test_plot(a_smooth, b_smooth)

    plt.scatter(a_list, b_list, s=1)
    plt.scatter(a_smooth, b_smooth, s=1, color="red")
    plt.savefig("./this_is_test.png")

    x_list = - b_smooth * np.sin(a_smooth)
    y_list = - b_smooth * np.cos(a_smooth)
    # test_plot(x_list, y_list)
    return None


main()
# test_plot([1], [1])
