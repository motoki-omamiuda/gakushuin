using Revise: includet
using Format: printfmt
using Plots

includet("./methods.jl")
includet("./constants.jl")
includet("./functions.jl")

using .Methods: calc_a, calc_b
using .Functions: v_eff


function main()
    plt = plot(
        xlim=(-35, 35), ylim=(-35, 35),
        legend=false,  #grid=false, framestyle=:none,
        ratio=1, dpi=1600,
    )

    x_list = []
    y_list = []

    diff = 0.1
    equator_count = 0

    # make p and v_eff(p) list
    p_and_v_list = [] # [p, v_eff(p)]
    for i in 0.01: 0.01: 500
        push!(p_and_v_list, [i, v_eff(i)])
    end

    # test
    phi = 1
    a_val = calc_a(phi)
    b_val = calc_b(15, phi, equator_count, p_and_v_list)

    print(a_val, "\n")
    print(b_val, "\n")


    # for phi in 0: diff: pi
    #     a_val = calc_a(phi)
    #     b_val = calc_b(15, phi, equator_count)

    #     if a_val != NaN && b_val != NaN
    #         push!(x_list, - b_val * sin(a_val))
    #         push!(y_list, - b_val * cos(a_val))
    #     end
    # end
    # print(x_list)
    # print(y_list)

    scatter!(plt, x_list, y_list, color=:black)

    savefig(plt, "output_plot.png")
end

main()
