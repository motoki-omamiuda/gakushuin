# build in
import csv

# pip libraries
import matplotlib.pyplot as plt
import numpy as np

from sklearn.linear_model import Ridge
from sklearn.linear_model import Lasso
from sklearn.linear_model import LinearRegression

from sklearn.preprocessing import PolynomialFeatures
from sklearn.pipeline import make_pipeline


def read_text(path: str) -> list:
    """
    read dataset from .txt file
    """
    data_list = None
    with open(path, "r") as file:
        reader = csv.reader(file)
        data_list = [
            [float(row[0]), float(row[1])] for row in reader
        ]
    return data_list


def test_plot(x: list, y: list) -> None:
    """
    temporary plot
    """
    plt.scatter(x, y, s=1)
    plt.savefig("./this_is_test.png")
    plt.show()
    return None


def regression(x: list, y: list, region: list) -> (list, list):
    """
    Ridge regression with polynomial features.
    """
    # model = make_pipeline(
    #     PolynomialFeatures(10),
    #     Ridge(alpha=0)
    # ).fit(np.array(x).reshape(-1, 1), np.array(y))
    model = make_pipeline(
        PolynomialFeatures(15),
        LinearRegression()
    ).fit(np.array(x).reshape(-1, 1), np.array(y))
    x_smooth = np.linspace(region[0], region[1], 200)
    y_smooth = model.predict(x_smooth.reshape(-1, 1))
    # return x_smooth.tolist(), y_smooth.tolist()
    return x_smooth, y_smooth
