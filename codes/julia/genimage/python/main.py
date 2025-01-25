from utils import read_text, write_text

from sklearn.kernel_ridge import KernelRidge
import matplotlib.pyplot as plt
import numpy as np


a_list = [0.1, 0.3, 0.5, 0.7, 0.9, 1.1, 1.3, 1.5]
r_val = 20.0

# for a_val in a_list:
a_val = 1.5

base_path = "{:.1f}-{:.1f}-inC".format(r_val, a_val)
data = read_text("./data/{}.txt".format(base_path))
x_train = [x[0] for x in data]
y_train = [x[1] for x in data]
plt.plot(x_train, y_train)
plt.savefig("./images/{}.png".format(base_path))

x_train = np.array(x_train).reshape(-1, 1)
y_train = np.array(y_train)

krr = KernelRidge(alpha=0.1, kernel='rbf', gamma=0.01)
krr.fit(x_train, y_train)

x_list = np.linspace(0, 23, 500)
y_list = krr.predict(x_list.reshape(-1, 1))
print(y_list)

data = []
for (x, y) in zip(x_list, y_list):
    data.append("{}\t,{}".format(x, y))
write_text("./python/data/{}-python-inC.txt".format(base_path), data)

plt.plot(x_list, y_list)
plt.savefig("./images/{}-rbf.png".format(base_path))
