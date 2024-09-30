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

# using library
using Optim
using Printf
using Plots
using Formatting

# initialize
THETA = Constant.THETA
MASS = Constant.MASS

global plt = plot(
    xlim=(-35, 35), ylim=(-35, 35),
    legend=false,
    ratio=1, # アスペクト比を指定
    dpi=800, # 解像度を指定
)

theta = range(0, stop=2*pi, length=100)
for (i, j) in zip([2, 3 * sqrt(3)], [0.6, 0.3])
    plot!(plt, i .* MASS .* cos.(theta), i .* MASS .* sin.(theta), linewidth=0, fillcolor=:black, fillalpha=j, fillrange=0)
end


function caluculate_disk_image(disk_partial)
    """
    光を発する降着円盤における微小粒子が写真板に写す像の位置を計算する
    """
    tmp_gamma = Function.gamma(disk_partial.phi)

    # f(b) = abs(
    #     ( Function.Q(Function.P(b)) - Function.P(b) + 6 * MASS ) / ( 4 * MASS * Function.P(b) )
    #     * Elliptic.Jacobi.sn(
    #         (
    #             tmp_gamma * sqrt( Function.Q(Function.P(b)) / Function.P(b) ) / 2
    #             + Elliptic.F(
    #                 Function.zeta(Function.P(b)),
    #                 Function.m(Function.P(b))
    #             )
    #         ),
    #         Function.m(Function.P(b))
    #     ) ^ 2
    #     - ( Function.Q(Function.P(b)) - Function.P(b) + 2 * MASS ) / ( 4 * MASS * Function.P(b) )
    #     - 1 / disk_partial.r
    # )

    # # 高速な計算ができる。使用する時は abs をつける
    # res = optimize(f, 3 * MASS, 40 * MASS)
    # b = Optim.minimizer(res)

    f(P) = (
    if !(
        1 >= (Function.Q(P) - P + 2 * MASS + (4 * MASS * P / disk_partial.r)) / (Function.Q(P) - P + 6 * MASS)
        && (Function.Q(P) - P + 2 * MASS + (4 * MASS * P / disk_partial.r)) / (Function.Q(P) - P + 6 * MASS) >= -1
    )
        return 10
    else
        return abs(
            2 * sqrt(P / Function.Q(P)) * (
                Elliptic.F(
                    Function.zeta_r(P, disk_partial.r),
                    Function.m(P)
                ) - Elliptic.F(
                    Function.zeta_inf(P),
                    Function.m(P)
                )
            ) - tmp_gamma
        )
    end
    )

    # 高速な計算ができる。使用する時は abs をつける
    res = optimize(f, 3 * MASS, 40 * MASS)
    P = Optim.minimizer(res)
    b = Function.b(P)

    return Struct.ImageParticle(b, Function.alpha(disk_partial.phi))
end


function main(plt, r, color)
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

        # output log
        @printf("r:\t%.3f\t", r)
        @printf("phi:\t%.3f\t", phi)
        @printf("b:\t%.3f\t", image_partial.b)
        @printf("alpha:\t%.3f\t", image_partial.alpha)
        @printf("\n")
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
    global plt = main(plt, distance * MASS, color)
end

savefig(plt, format("./images/{:2.0d}.png", Constant.DEGREE))