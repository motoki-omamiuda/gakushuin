# import numpy as np
# import matplotlib.pyplot as plt
# from statsmodels.nonparametric.smoothers_lowess import lowess

# # サンプルデータを作成（x に対して複数の y 値が存在するデータ）
# np.random.seed(42)
# x = np.linspace(0, 10, 100)
# y1 = np.sin(x) + np.random.normal(0, 0.2, size=len(x))
# y2 = np.cos(x) + np.random.normal(0, 0.2, size=len(x))

# # データを結合して複数の y 値を持つデータセットを作成
# x_combined = np.concatenate([x, x])
# y_combined = np.concatenate([y1, y2])

# # LOWESS 回帰を適用
# lowess_result = lowess(y_combined, x_combined, frac=0.2)

# # 回帰結果を取得
# x_smooth = lowess_result[:, 0]
# y_smooth = lowess_result[:, 1]

# # プロット
# plt.figure(figsize=(10, 6))
# plt.scatter(x_combined, y_combined, alpha=0.5, label="Original Data", color="gray")
# plt.plot(x_smooth, y_smooth, color="red", label="LOWESS Curve")
# plt.title("Curve with Multiple Y Values for Each X")
# plt.xlabel("X")
# plt.ylabel("Y")
# plt.legend()
# plt.grid()
# plt.show()

import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import Ridge

# サンプルデータを作成（x に対して複数の y 値が存在するデータ）
np.random.seed(42)
x = np.linspace(0, 10, 100)
y1 = np.sin(x) + np.random.normal(0, 0.2, size=len(x))
y2 = np.cos(x) + np.random.normal(0, 0.2, size=len(x))

# データを結合して複数の y 値を持つデータセットを作成
x_combined = np.concatenate([x, x])
y_combined = np.concatenate([y1, y2])

# リッジ回帰モデルを作成
model = Ridge()
print(x_combined.reshape(-1, 1))
model.fit(x_combined.reshape(-1, 1), y_combined)

# 実データにはない x の部分を予測
x_pred = np.linspace(-2, 12, 200).reshape(-1, 1)
y_pred = model.predict(x_pred)

# プロット
plt.figure(figsize=(10, 6))
plt.scatter(x_combined, y_combined, alpha=0.5, label="Original Data", color="gray")
plt.plot(x_pred, y_pred, color="green", label="Ridge Regression")
plt.title("Ridge Regression Predicting New X Values")
plt.xlabel("X")
plt.ylabel("Y")
plt.legend()
plt.grid()
plt.show()
