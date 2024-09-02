include("./structs.jl")
include("./functions.jl")
include("./constants.jl")

# module
import Main.Struct
import Main.Function
import Main.Constant

# library
import Elliptic
import Elliptic.Jacobi

using Roots
using Printf
using Plots

# initialize
SITA = Constant.SITE
MASS = Constant.MASS

function caluculate_disk_image(disk_partial)
    """
    光を発する降着円盤における微小粒子が写真板に写す像の位置を計算する
    """
    # P の計算
    tmp_gamma = Function.gamma(disk_partial.phi)
    @printf("Gamma:\t%.3f\n", tmp_gamma)
    # f(P) = (Function.Q(P) - P + 6 * M) / (4 * M * P) * Elliptic.Jacobi.sn(tmp_gamma * sqrt(Function.Q(P) / P) / 2 + Elliptic.F(Function.zeta(P), Function.k(P) ^ 2), Function.k(P) ^ 2) ^ 2 - (Function.Q(P) - P + 6 * M) / (4 * M * P) - 1 / disk.r

    # f(P) = Elliptic.Jacobi.sn((tmp_gamma / 2) * sqrt(Function.Q(P) / P) + Elliptic.F(Function.zeta(P), Function.k(P) ^ 2), Function.k(P) ^ 2) ^ 2
    # -> 3.0

    f(P) = (Function.Q(P) - P + 6 * MASS) / (4 * MASS * P) * Elliptic.Jacobi.sn((tmp_gamma / 2) * sqrt(Function.Q(P) / P) + Elliptic.F(Function.zeta(P), Function.k(P) ^ 2), Function.k(P) ^ 2) ^ 2

    # f(P) = - (Function.Q(P) - P + 2 * MASS)
    # -> 2.0

    # 関数の分析
    x = []
    y = []
    for tmp in -300:0.01:300
        try
            y = push!(y, f(tmp))
            x = push!(x, tmp)
        catch
            continue
        end
    end
    return x, y
end

polar_b = []
polar_alpha = []

disk_partial = Struct.DiskParticle(5 * MASS, pi/3)
x, y = caluculate_disk_image(disk_partial)

# print(x, y)
plot(x, y)