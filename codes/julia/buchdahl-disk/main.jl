using Revise: includet
using Format
using Plots

includet("./methods.jl")
includet("./constants.jl")
includet("./functions.jl")

using .Methods: calc_a, calc_b, write_txt, read_txt
using .Functions: v_eff
using .Constants: A, DEGREE


function main()
    x_list = []
    y_list = []

    diff = 0.1
    equator_count = 0

    # make r and v_eff(r) list
    r_and_v_list = [] # [r, v_eff(r)]
    for r in 0.01: 0.01: 1e3
        push!(r_and_v_list, [r, v_eff(r)])
    end


    for phi in diff: diff: pi
    # for phi in 2.0: diff: 2.0
        a_val = calc_a(phi)
        b_val = calc_b(20, phi, equator_count, r_and_v_list)

        print("a:\t", a_val, "\n")
        print("b:\t", b_val, "\n")

        push!(x_list, b_val)
        push!(y_list, a_val)
    end

    # create log file
    write_txt(format("./datas/{:.1f}-{:d}.txt", A, DEGREE), x_list, y_list)

end

main()
