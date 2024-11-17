module Utils

include("./consts.jl")
include("./equas.jl")

# module
using .Consts: MASS
using .Equas: P, Q, m, zeta_inf, gamma, alpha, b


# library
using Elliptic
using Elliptic.Jacobi
using Plots


function calc_disk_image(r, phi)
    """
    降着円盤上の粒子に対応した像の位置を計算する
    """
    gamma_val = gamma(phi)

    alpha_val = alpha(phi)
    b_val = r * cos( gamma_val - pi / 2 )
    return b_val, alpha_val
end


function plot_disk_image(plt, r_list, theta_list, color)
    """
    極座標系のデータを直交座標系に変換して描画する
    """
    x = [-r_list[1] * sin(theta_list[1]), r_list[1] * sin(theta_list[1])]
    y = [-1 * r_list[1] * cos(theta_list[1]), -1 * r_list[1] * cos(theta_list[1])]
    plot!(plt, x, y, color=color)

    # 左右対称の描画
    for sign in [-1, 1]  # 符号を反転して左右対称に
        x = [sign * r * sin(theta) for (r, theta) in zip(r_list, theta_list)]
        y = [-1 * r * cos(theta) for (r, theta) in zip(r_list, theta_list)]
        plot!(plt, x, y, color=color)
    end

    x = [-r_list[end] * sin(theta_list[end]), r_list[end] * sin(theta_list[end])]
    y = [-1 * r_list[end] * cos(theta_list[end]), -1 * r_list[end] * cos(theta_list[end])]
    plot!(plt, x, y, color=color)

    return plt
end


export plot_disk_image, calc_disk_image

end