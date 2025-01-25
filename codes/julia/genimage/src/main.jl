include("functions.jl")
using .Functions: integer_p_not_in_c, integer_p_in_c, binary_search_p, create_r_and_v_list, gamma

include("utils.jl")
using .Utils: write_text

using Plots
using Format

function main(a_val::Float64)
    r_val::Float64 = 20.0
    b_lim = 21.85

    # =================================
    # plot c not in P
    # =================================
    b_list = []
    phi_list = []
    diff = 0.01
    for b_val in diff: diff: b_lim
        phi_val = integer_p_not_in_c(r_val, b_val, a_val)
        push!(b_list, b_val)
        push!(phi_list, phi_val)

        print("b:\t", b_val, "\n")
        print("phi:\t", phi_val, "\n")

        # write_text([b_val, phi_val], "./data/test.txt")
        write_text([b_val, phi_val], format("./data/{:.1f}-{:.1f}.txt", r_val, a_val))
    end
    plot!(plt, b_list, phi_list, color=:red, width=2)
    # =================================
    # plot c in P
    # =================================
    b_list = []
    phi_list = []
    r_and_v_list = create_r_and_v_list(a_val)
    diff = 0.01
    for b_val in diff: diff: b_lim
        p_val = binary_search_p(b_val, r_and_v_list)
        phi_val = integer_p_in_c(r_val, b_val, p_val, a_val)

        push!(b_list, b_val)
        push!(phi_list, phi_val)

        print("b:\t", b_val, "\n")
        print("phi:\t", phi_val, "\n")

        write_text([b_val, phi_val], format("./data/{:.1f}-{:.1f}-inC.txt", r_val, a_val))
    end
    plot!(plt, b_list, phi_list, color=:green, width=2)
    return plt
end

global plt = plot(
    xlim=(0, 23), ylim=(0, 5*pi),
    # aspect_ratio=:equal,
    legend=false, dpi=300
)

# for a in [1.5, 1.1, 0.8, 0.2]
# for a in [1.5, 1.2, 0.9, 0.6, 0.3, 0.1]
for a::Float64 in 0.1: 0.2: 1.5
    plt = main(a)
end

color_map = [
    (0, "#FF0000"),
    (1, "#FFA500"),
    (2, "#ADFF2F"),
    (3, "#00CED1"),
    (4, "#0000ff"),
]

# 計算
radian =  2 * pi * 60 / (360)
under_band = gamma(0, radian)
over_band = gamma(pi, radian)

print(under_band, "\t", over_band, "\n")

for (k, color) in color_map
    plot!(
        plt, [-1, 25, 25, -1], [under_band + k*pi, under_band + k*pi, over_band + k*pi, over_band + k*pi],
        linewidth=1, style=:dash, color=color, fillcolor=color, fillalpha=0.1, fillrange=0
    )
end

# savefig(plt, format("./{:d}-image/{:.1f}-{:d}.png", deg, a_val, deg))
# savefig(plt, "./images/plot.png")
savefig(plt, "./test.png")
