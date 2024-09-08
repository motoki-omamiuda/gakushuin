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
THETA = Constant.THETA
MASS = Constant.MASS

global plt = plot(
    xlim=(-35, 35),
    ylim=(-35, 35),
    legend=false,
    ratio=1,
)

theta = range(0, stop=2*pi, length=100)
plot!(
    plt,
    2 .* MASS .* cos.(theta),
    2 .* MASS .* sin.(theta),
    linewidth=0,
    fillcolor=:black,
    fillalpha=0.4,
    fillrange=0,
)

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

function write_graph(plt, r, color)
    """
    グラフを描画する
    """
    polar_b = []
    polar_alpha = []

    for phi in 0:0.01:pi
        local disk_partial = Struct.DiskParticle(r, phi)
        local image_partial = caluculate_disk_image(disk_partial)

        push!(polar_b, image_partial.b)
        push!(polar_alpha, image_partial.alpha)
        @printf("b:\t%.3f \talpha:\t%.3f\n", image_partial.b, image_partial.alpha)
    end

    x = [ b * sin(alpha)  for (b, alpha) in zip(polar_b, polar_alpha) ]
    y = [ - b * cos(alpha)  for (b, alpha) in zip(polar_b, polar_alpha) ]
    plot!(plt, x, y, color=color)
    x = [ - b * sin(alpha)  for (b, alpha) in zip(polar_b, polar_alpha) ]
    y = [ - b * cos(alpha)  for (b, alpha) in zip(polar_b, polar_alpha) ]
    plot!(plt, x, y, color=color)
    return plt
end

color_list = ["#0000cd", "#4169e1", "#4682b4", "#2e8b57", "#006400"]
distance_list = [2, 6, 10, 20, 30]
for (color, distance) in zip(color_list, distance_list)
    global plt = write_graph(plt, distance * MASS, color)
end
plt
