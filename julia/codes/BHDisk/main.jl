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


function calc_disk_image(disk_partial)
    """
    光を発する降着円盤における微小粒子が写真板に写す像の位置を計算する
    """
    tmp_gamma = Function.gamma(disk_partial.phi)

    f(b) = abs(
        ( Function.Q( Function.P(b) ) - Function.P(b) + 6 * MASS ) / ( 4 * MASS * Function.P(b) )
        * Elliptic.Jacobi.sn(
            (
                tmp_gamma * sqrt( Function.Q( Function.P(b) ) / Function.P(b) ) / 2
                + Elliptic.F(
                    Function.zeta_inf( Function.P(b) ),
                    Function.m( Function.P(b) )
                )
            ),
            Function.m( Function.P(b) )
        ) ^ 2
        - ( Function.Q( Function.P(b) ) - Function.P(b) + 2 * MASS ) / ( 4 * MASS * Function.P(b) )
        - 1 / disk_partial.r
    )

    # 高速な計算ができる。使用する時は abs をつける
    res = optimize(f, 3 * MASS, 40 * MASS)
    b = Optim.minimizer(res)

    return Struct.ImageParticle(b, Function.alpha(disk_partial.phi))
end


function calc_disk_image_n(disk_partial, n=1)
    """
    光を発する降着円盤における微小粒子が一周して写真板に写す像の位置を計算する
    """
    tmp_gamma = Function.gamma(disk_partial.phi)

    # f = P -> begin
    #     value = sqrt((Function.Q(P) - P + 2 * MASS + (4 * MASS * P / disk_partial.r)) / (Function.Q(P) - P + 6 * MASS))
    #     if !(1 >= value >= -1)
    #         return 1e10
    #     else
    #         term_elliptic = 2 * sqrt(P / Function.Q(P)) * (
    #             2 * Elliptic.K(sqrt(Function.m(P)))
    #             - Elliptic.F(Function.zeta_inf(P), Function.m(P))
    #             - Elliptic.F(Function.zeta_r(P, disk_partial.r), Function.m(P))
    #         )
    #         return abs(tmp_gamma - 2 * pi * n + term_elliptic)
    #     end
    # end

    # f(P) = abs(
    #     ( Function.Q(P) - P + 2 * MASS + ( 4 * MASS * P / disk_partial.r ) )/( Function.Q(P) - P + 6 * MASS )
    #     - Elliptic.Jacobi.sn(
    #         2 * Elliptic.K( Function.m(P) )
    #         - Elliptic.F( Function.zeta_inf(P), Function.m(P) )
    #         + 1 / 2 * sqrt( Function.Q(P) / P ) * ( tmp_gamma - 2 * pi * n ),
    #         Function.m(P)
    #     ) ^ 2
    # )

    f(P) = abs(
        ( Function.Q(P) - P + 6 * MASS )/( 4 * MASS * P )
        * Elliptic.Jacobi.sn(
            2 * Elliptic.K( Function.m(P) )
            - Elliptic.F( Function.zeta_inf(P), Function.m(P) )
            + 1 / 2 * sqrt( Function.Q(P) / P ) * ( tmp_gamma - 2 * pi * n ),
            Function.m(P)
        ) ^ 2
        - ( Function.Q(P) - P + 2 * MASS )/( 4 * MASS * P )
        - 1 / disk_partial.r
    )

    # 高速な計算ができる。使用する時は abs をつける
    res = optimize(f, 3 * MASS, 40 * MASS)
    P = Optim.minimizer(res)

    return Struct.ImageParticle(Function.b(P), Function.alpha(disk_partial.phi))
end


function plot_graph(plt, polar_r, polar_theta, color)
    """
    極座標系のデータを直交座標系に変換して描画する
    """
    # 左右対称の描画
    for sign in [-1, 1]  # 符号を反転して左右対称に
        x = [sign * r * sin(theta) for (r, theta) in zip(polar_r, polar_theta)]
        y = [-r * cos(theta) for (r, theta) in zip(polar_r, polar_theta)]
        plot!(plt, x, y, color=color)
    end
    x = [ - polar_r[end] * sin(polar_theta[end]), polar_r[end] * sin(polar_theta[end])]
    y = [ - polar_r[end] * cos(polar_theta[end]), - polar_r[end] * cos(polar_theta[end])]
    plot!(plt, x, y, color=color)
    return plt
end


function main(plt, r, color)
    """
    グラフを描画する
    """
    polar_b_00 = []
    polar_alpha_00 = []

    diff = 0.001
    for phi in 0:diff:pi
        local disk_partial = Struct.DiskParticle(r, phi)
        local image_partial_00 = calc_disk_image_n(disk_partial)

        push!(polar_b_00, image_partial_00.b)
        push!(polar_alpha_00, image_partial_00.alpha)

        # output log
        @printf("r:\t%.3f\t", r)
        @printf("phi:\t%.3f\t", phi)
        @printf("b:\t%.3f\t", image_partial_00.b)
        @printf("alpha:\t%.3f\t", image_partial_00.alpha)
        @printf("\n")
    end

    # 左右対称の描画
    # for sign in [-1, 1]  # 符号を反転して左右対称に
    #     x = [sign * b * sin(alpha) for (b, alpha) in zip(polar_b_00, polar_alpha_00)]
    #     y = [-b * cos(alpha) for (b, alpha) in zip(polar_b_00, polar_alpha_00)]
    #     plot!(plt, x, y, color=color)
    # end
    # x = [ - polar_b_00[end] * sin(polar_alpha_00[end]), polar_b_00[end] * sin(polar_alpha_00[end])]
    # y = [ - polar_b_00[end] * cos(polar_alpha_00[end]), - polar_b_00[end] * cos(polar_alpha_00[end])]
    # plot!(plt, x, y, color=color)
    # return plt
    plt = plot_graph(plt, polar_b_00, polar_alpha_00, color)
    return plt
end


# 表示するグラフの色と降着円盤の半径を指定
color_list = ["#0000cd", "#4169e1", "#4682b4", "#2e8b57", "#006400"]
distance_list = [3, 6, 10, 20, 30]

for (color, distance) in zip(color_list, distance_list)
    global plt = main(plt, distance * MASS, color)
end

savefig(plt, format("./images/{:2.0d}.png", Constant.DEGREE))