include("functions.jl")
using .Functions: integer_p_not_in_c, integer_p_in_c, binary_search_p, create_r_and_v_list, gamma

using Plots

global plt = plot(
    xlim=(0, 23), ylim=(0, 5*pi),
    # aspect_ratio=:equal,
    legend=false, dpi=300
)

color_map = [
    (0, "#FF0000"),
    (1, "#FFA500"),
    (2, "#ADFF2F"),
    (3, "#00CED1"),
    (4, "#0000ff"),
]

# 計算
radian =  2 * pi * 80 / (360)
under_band = gamma(0, radian)
over_band = gamma(pi, radian)

print(under_band, "\t", over_band, "\n")

for (k, color) in color_map
    plot!(
        plt, [-1, 25, 25, -1], [under_band + k*pi, under_band + k*pi, over_band + k*pi, over_band + k*pi],
        linewidth=1, style=:dash, color=color, fillcolor=color, fillalpha=0.1, fillrange=0
    )
end

savefig(plt, "./test.png")