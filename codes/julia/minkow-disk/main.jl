include("./consts.jl")
include("./equas.jl")
include("./utils.jl")

# module
using .Consts: MASS, DEGREE
using .Utils: calc_disk_image, plot_disk_image

# library
using Printf
using Plots
using Formatting


function init()
    global plt = plot(
        xlim=(-35, 35), ylim=(-35, 35),
        legend=false,
        ratio=1, # アスペクト比を指定
        dpi=800, # 解像度を指定
    )
end


function output()
    savefig(plt, format("./images/{:d}.png", DEGREE))
end

function main()

    r_list = [2, 6, 10, 20, 30] .* MASS

    color_list = [
        ["#ff7f50", "#ff6347", "#ff4500", "#ff0000", "#dc143c"], # 赤系
        ["#4169e1", "#191970", "#000080", "#00008b", "#0000cd"], # 青系
        ["#0000cd", "#4169e1", "#4682b4", "#2e8b57", "#006400"], # 緑系
        ["#a0522d", "#8b4513", "#800000", "#8b0000", "#a52a2a"], # 茶系
        ["#ffa500", "#f4a460", "#ff8c00", "#daa520", "#cd853f"], # オレンジ系
        ["#800000", "#a52a2a", "#cd5c5c", "#dc143c", "#ff4500"], # 赤系
    ]

    for i in 1:length(r_list)
        b_list = []
        alpha_list = []

        diff = pi / 1e3
        for phi in 0:diff:pi
            b_val, alpha_val = calc_disk_image(r_list[i], phi)
            push!(b_list, b_val)
            push!(alpha_list, alpha_val)
        end

        # plot
        plot!(plt, plot_disk_image(plt, b_list, alpha_list, color_list[1][i]))
    end
end


init()
main()
output()
