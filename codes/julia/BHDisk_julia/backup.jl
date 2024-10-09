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
using Formatting


# initialize
THETA = Constant.THETA
MASS = Constant.MASS

global plt = plot(
    xlim=(-35, 35),
    ylim=(-35, 35),
    legend=false,
    ratio=1, # アスペクト比を指定
    dpi=800, # 解像度を指定
)

theta = range(0, stop=2*pi, length=100)
for (i, j) in zip([2, 6], [0.6, 0.3])
    plot!(plt, i .* MASS .* cos.(theta), i .* MASS .* sin.(theta), linewidth=0, fillcolor=:black, fillalpha=j, fillrange=0)
end


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
    # P = serch_zero(f, 2 * MASS, 40 * MASS)
    res = optimize(f, 2 * MASS, 40 * MASS)
    P = Optim.minimizer(res)

    @printf("P:\t%.3f\t", P)
    return Struct.ImageParticle(Function.b(P), Function.alpha(disk_partial.phi))
end


function write_graph(plt, r, color)
    """
    グラフを描画する
    """
    polar_b = []
    polar_alpha = []

    diff = 0.001
    for phi in 0:diff:pi
        local disk_partial = Struct.DiskParticle(r, phi)
        local image_partial = caluculate_disk_image(disk_partial)

        push!(polar_b, image_partial.b)
        push!(polar_alpha, image_partial.alpha)
        @printf("b:\t%.3f\t", image_partial.b)
        @printf("alpha:\t%.3f\t", image_partial.alpha)
    end

    # 左右対称の描画
    for sign in [-1, 1]  # 符号を反転して左右対称に
        x = [sign * b * sin(alpha) for (b, alpha) in zip(polar_b, polar_alpha)]
        y = [-b * cos(alpha) for (b, alpha) in zip(polar_b, polar_alpha)]
        plot!(plt, x, y, color=color)
    end
    x = [ - polar_b[end] * sin(polar_alpha[end]), polar_b[end] * sin(polar_alpha[end])]
    y = [ - polar_b[end] * cos(polar_alpha[end]), - polar_b[end] * cos(polar_alpha[end])]
    plot!(plt, x, y, color=color)
    return plt
end


# 表示するグラフの色と降着円盤の半径を指定
color_list = ["#0000cd", "#4169e1", "#4682b4", "#2e8b57", "#006400"]
distance_list = [3, 6, 10, 20, 30]

for (color, distance) in zip(color_list, distance_list)
    global plt = write_graph(plt, distance * MASS, color)
end

savefig(plt, format("./images/{:3.0d}.png", Constant.DEGREE))