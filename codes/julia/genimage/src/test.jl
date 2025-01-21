include("functions.jl")
using .Functions: integer_p_not_in_c, integer_p_in_c, binary_search_p, create_r_and_v_list

using Plots
using Format

function main(a_val)
    # =================================
    # plot not in P
    # =================================
    b_list = []
    phi_list = []
    diff = 0.1
    for b_val in diff: diff: 22
        phi_val = integer_p_not_in_c(20, b_val, a_val)
        push!(b_list, b_val)
        push!(phi_list, phi_val)
        print("b:\t", b_val, "\n")
        print("phi:\t", phi_val, "\n")
    end
    plot!(plt, b_list, phi_list, color=:red, width=1)

    # =================================
    # plot in P
    # =================================
    b_list = []
    phi_list = []
    r_and_v_list = create_r_and_v_list(a_val)
    diff = 0.05
    for b_val in diff: diff: 4.9
        p_val = binary_search_p(b_val, r_and_v_list)
        phi_val = integer_p_in_c(20, b_val, p_val, a_val)
        push!(b_list, b_val)
        push!(phi_list, phi_val)
        print("b:\t", b_val, "\n")
        print("phi:\t", phi_val, "\n")
    end
    diff = 0.01
    for b_val in 4.9: diff: 5.0
        p_val = binary_search_p(b_val, r_and_v_list)
        phi_val = integer_p_in_c(20, b_val, p_val, a_val)
        push!(b_list, b_val)
        push!(phi_list, phi_val)
        print("b:\t", b_val, "\n")
        print("phi:\t", phi_val, "\n")
    end
    diff = 0.05
    for b_val in 5.0: diff: 22.0
        p_val = binary_search_p(b_val, r_and_v_list)
        phi_val = integer_p_in_c(20, b_val, p_val, a_val)
        push!(b_list, b_val)
        push!(phi_list, phi_val)
        print("b:\t", b_val, "\n")
        print("phi:\t", phi_val, "\n")
    end
    plot!(plt, b_list, phi_list, color=:blue, width=1)
    return plt
end

plt = plot(
    x_lim=(0, 22), y_lim=(0, 3 * pi),
    aspect_ratio=:equal,
    legend=false, dpi=300
)

for a in [1.5, 1.1, 0.8, 0.2]
    plt = main(a)
end

# savefig(plt, format("./{:d}-image/{:.1f}-{:d}.png", deg, a_val, deg))
savefig(plt, "./test.png")