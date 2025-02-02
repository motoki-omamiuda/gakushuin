include("functions.jl")
using .Functions: integer_p_not_in_c, integer_p_in_c, binary_search_p, create_r_and_v_list, gamma

using Plots
using Format

global plt = plot(
    # xlim=(0, 2*pi), ylim=(0, 7*pi),
    xlim=(0, 23), ylim=(0, 7*pi),
    # aspect_ratio=:equal,
    legend=false, dpi=300
)

color_map = [
    (0, "#FF0000"),
    (1, "#ff69b4"),
    (2, "#ff8c00"),
    (3, "#0000ff"),
    (4, "#9400d3"),
    (5, "#0000cd"),
    (6, "#00008b"),
]
color_map = [
    (0, "#ff7f50"),
    (1, "#ff69b4"),
    (2, "#ff00ff"),
    (3, "#9400d3"),
    (4, "#0000ff"),
    (5, "#008b8b"),
    (6, "#008000"),
]

# color_map = [
#     (0, "#FF0000"),
#     (1, "#0000ff"),
#     (2, "#000000")
# ]

# 計算
theta = 60
radian =  2 * pi * theta / (360)
under_band = gamma(0, radian)
over_band = gamma(pi, radian)

print(under_band, "\t", over_band, "\n")

for (k, color) in color_map
    plot!(
        plt, [-1, 25, 25, -1], [under_band + k*pi, under_band + k*pi, over_band + k*pi, over_band + k*pi],
        linewidth=1, style=:dash, color=color, fillcolor=color, fillalpha=0.1, fillrange=0
    )
end

# x_01 = 0.67
# x_02 = 1.24
# plot!(plt, [x_01, x_01], [-100, 100], linewidth=1, style=:dot, color="black")
# plot!(plt, [x_02, x_02], [-100, 100], linewidth=1, style=:dot, color="black")

savefig(plt, format("./images/{:d}-color.png", theta))