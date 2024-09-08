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

using Optim
using Printf
using Plots

# initialize
SITA = Constant.SITE
MASS = Constant.MASS

function serch_zero(f, lower, upper)
    """
    範囲内で関数の零点に最も近い部分を探す
    """
    min = 1e10
    x = 0
    for tmp in lower:0.01:upper
        try
            if abs(f(tmp)) < min
                min = abs(f(tmp))
                x = tmp
            end
        catch
            continue
        end
    end
    return x
end

function caluculate_disk_image(disk_partial)
    """
    光を発する降着円盤における微小粒子が写真板に写す像の位置を計算する
    """
    tmp_gamma = Function.gamma(disk_partial.phi)
    @printf("Gamma:\t%.3f\n", tmp_gamma)

    f(P) = (
        (Function.Q(P) - P + 6 * MASS) / (4 * MASS * P)
        * Elliptic.Jacobi.sn(
            tmp_gamma * sqrt(Function.Q(P) / P) / 2
            + Elliptic.F(
                Function.zeta(P),
                Function.m(P)
                ),
            Function.m(P)
        ) ^ 2
        - (Function.Q(P) - P + 2 * MASS) / (4 * MASS * P)
        - 1 / disk_partial.r
    )

    # 探索する範囲を指定
    P = serch_zero(f, 2 * MASS, 40 * MASS)

    @printf("P:\t%.3f\n", P)
    return Struct.ImageParticle(Function.b(P), Function.alpha(disk_partial.phi))
end

polar_b = []
polar_alpha = []

for phi in 0:0.01:pi
    local disk_partial = Struct.DiskParticle(30 * MASS, phi)
    local image_partial = caluculate_disk_image(disk_partial)

    push!(polar_b, image_partial.b)
    push!(polar_alpha, image_partial.alpha)
    @printf("b:\t%.3f \talpha:\t%.3f\n", image_partial.b, image_partial.alpha)
end

print(polar_b)
print(polar_alpha)
x = [ b * sin(alpha)  for (b, alpha) in zip(polar_b, polar_alpha) ]
y = [ - b * cos(alpha)  for (b, alpha) in zip(polar_b, polar_alpha) ]
plot(x, y, seriestype=:scatter)
