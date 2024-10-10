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

using Roots # find_zero

using PyCall
mp = pyimport("mpmath")

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


function func(b, disk_partial)

    py_inner_ellipf = mp.ellipf(
        Function.zeta_inf( Function.P(b) ),
        Function.m( Function.P(b) )
    )
    inner_ellipf = Complex( pycall(py_inner_ellipf.real.__float__, Float64), pycall(py_inner_ellipf.imag.__float__, Float64) )
    inner = (
        Function.gamma(disk_partial.phi) * sqrt( Function.Q( Function.P(b) ) / Function.P(b) ) / 2
        + inner_ellipf
    )

    py_inner_ellipfun = mp.ellipfun(
        "sn", inner, Function.m( Function.P(b) )
    )
    inner_ellipfun = Complex( pycall(py_inner_ellipfun.real.__float__, Float64), pycall(py_inner_ellipfun.imag.__float__, Float64) )

    return 1e2 * abs(
        ( Function.Q( Function.P(b) ) - Function.P(b) + 6 * MASS ) / ( 4 * MASS * Function.P(b) )
        * inner_ellipfun ^ 2
        - ( Function.Q( Function.P(b) ) - Function.P(b) + 2 * MASS ) / ( 4 * MASS * Function.P(b) )
        - 1 / disk_partial.r
    )
end


function calc_disk_image(disk_partial)
    """
    光を発する降着円盤における微小粒子が写真板に写す像の位置を計算する
    """

    g = b -> func(b, disk_partial)

    # f(P) = abs(
    #     ( Function.Q( P ) - P + 6 * MASS ) / ( 4 * MASS * P )
    #     * Elliptic.Jacobi.sn(
    #         (
    #             tmp_gamma * sqrt( Function.Q( P ) / P ) / 2
    #             + Elliptic.F(
    #                 Function.zeta_inf( P ),
    #                 Function.m( P )
    #             )
    #         ),
    #         Function.m( P )
    #     ) ^ 2
    #     - ( Function.Q( P ) - P + 2 * MASS ) / ( 4 * MASS * P )
    #     - 1 / disk_partial.r
    # )

    # 高速な計算ができる。使用する時は abs をつける
    # res = optimize(g, 0 * MASS, 40 * MASS)
    # b = Optim.minimizer(res)
    b = search_zero(g, 0 * MASS, 30 * MASS)
    # res = optimize(f, 3 * MASS, 30 * MASS)
    # P = Optim.minimizer(res)

    return Struct.ImageParticle(b, Function.alpha(disk_partial.phi))
    # return Struct.ImageParticle(Function.b(P), Function.alpha(disk_partial.phi))
end


function search_zero(f, min, max)
    """
    関数の零点を求める
    """
    tmp_max = 1e10
    rtv = 0
    for i in min:0.025:max
        if f(i) < tmp_max
            tmp_max = f(i)
            rtv = i
        end
    end
    return rtv
end


function calc_disk_image_n(disk_partial, n)
    """
    光を発する降着円盤における微小粒子が一周して写真板に写す像の位置を計算する
    """
    tmp_gamma = Function.gamma(disk_partial.phi)

    # f(P) = abs(
    #     ( Function.Q(P) - P + 2 * MASS + ( 4 * MASS * P / disk_partial.r ) )/( Function.Q(P) - P + 6 * MASS )
    #     - Elliptic.Jacobi.sn(
    #         2 * Elliptic.K( Function.m(P) )
    #         - Elliptic.F( Function.zeta_inf(P), Function.m(P) )
    #         + 1 / 2 * sqrt( Function.Q(P) / P ) * ( tmp_gamma - 2 * pi * n ),
    #         Function.m(P)
    #     )^2
    # )

    g(P) = abs(
        ( Function.Q(P) - P + 6 * MASS )/( 4 * MASS * P )
        * Elliptic.Jacobi.sn(
            2 * Elliptic.K( Function.m(P) )
            - Elliptic.F(
                Function.zeta_inf(P),
                Function.m(P)
            )
            - ( 1 / 2 ) * sqrt( Function.Q(P) / P ) * ( 2 * pi * n - tmp_gamma ),
            Function.m(P)
        ) ^ 2
        - ( Function.Q(P) - P + 2 * MASS )/( 4 * MASS * P )
        - 1 / disk_partial.r
    )

    # 高速な計算ができる。使用する時は abs をつける
    # res = optimize(g, 3 * MASS, 40 * MASS)
    # P = Optim.minimizer(res)
    P = search_zero(g, 3 * MASS, 30 * MASS)

    return Struct.ImageParticle(Function.b(P), Function.alpha(disk_partial.phi))
end


function plot_graph(plt, polar_r, polar_theta, color, reverse=false)
    """
    極座標系のデータを直交座標系に変換して描画する
    """
    # 左右対称の描画
    for sign in [-1, 1]  # 符号を反転して左右対称に
        y_sign = reverse ? 1 : -1
        x = [sign * r * sin(theta) for (r, theta) in zip(polar_r, polar_theta)]
        y = [y_sign * r * cos(theta) for (r, theta) in zip(polar_r, polar_theta)]
        plot!(plt, x, y, color=color)
    end

    y_sign = reverse ? 1 : -1
    x = [-polar_r[end] * sin(polar_theta[end]), polar_r[end] * sin(polar_theta[end])]
    y = [y_sign * polar_r[end] * cos(polar_theta[end]), y_sign * polar_r[end] * cos(polar_theta[end])]
    plot!(plt, x, y, color=color)

    return plt
end


function main(plt, r, color_list)
    """
    グラフを描画する
    """
    polar_b_00 = []
    polar_alpha_00 = []

    polar_b_01 = []
    polar_alpha_01 = []

    diff = 0.001
    for phi in 0:diff:pi
        local disk_partial = Struct.DiskParticle(r, phi)
        local image_partial_00 = calc_disk_image(disk_partial)
        local image_partial_01 = calc_disk_image_n(disk_partial, 1)

        push!(polar_b_00, image_partial_00.b)
        push!(polar_alpha_00, image_partial_00.alpha)

        push!(polar_b_01, image_partial_01.b)
        push!(polar_alpha_01, image_partial_01.alpha)

        # output log
        @printf("r:\t%.3f\t", r)
        @printf("phi:\t%.3f\t", phi)
        @printf("\n")

        @printf("n=0\t")
        @printf("b:\t%.3f\t", image_partial_00.b)
        @printf("alpha:\t%.3f\t", image_partial_00.alpha)
        @printf("\n")

        # output log
        @printf("n=1\t")
        @printf("b:\t%.3f\t", image_partial_01.b)
        @printf("alpha:\t%.3f\t", image_partial_01.alpha)
        @printf("\n")
    end

    plt = plot_graph(plt, polar_b_00, polar_alpha_00, color_list[1])
    #plt = plot_graph(plt, polar_b_01, polar_alpha_01, color_list[2], true)
    return plt
end


# 表示するグラフの色と降着円盤の半径を指定
distance_list = [3, 6, 10, 20, 30]
color_inner_list = [
    ["#0000cd", "#0000ff"],
    ["#4169e1", "#1e90ff"],
    ["#4682b4", "#5f9ea0"],
    ["#2e8b57", "#4682b4"],
    ["#006400", "#87cefa"],
]
for (color_list, distance) in zip(color_inner_list, distance_list)
    global plt = main(plt, distance * MASS, color_list)
end

savefig(plt, format("./images/test{:2.0d}.png", Constant.DEGREE))