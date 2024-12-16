using Revise: includet
using Format

includet("./methods.jl")
includet("./constants.jl")
includet("./functions.jl")

using .Methods: calc_a, calc_b, write_txt, read_txt, plots
using .Functions: create_r_and_v_list
using .Constants: A, DEGREE


function main()
    x_list = []
    y_list = []

    diff = 0.1
    equator_count = 0

    # create r and v_eff(r) list
    r_and_v_lists = create_r_and_v_list()

    # # test plot
    # x_list = []
    # y_list = []
    # for r_and_v in r_and_v_lists
    #     push!(x_list, r_and_v[1])
    #     push!(y_list, r_and_v[2])
    # end
    # plots("r and Veff", x_list, y_list)


    for phi in diff: diff: pi
        a_val = calc_a(phi)
        b_val = calc_b(20, phi, equator_count, r_and_v_lists)

        print("a:\t", a_val, "\n")
        print("b:\t", b_val, "\n")

        push!(x_list, b_val)
        push!(y_list, a_val)
    end

    # create log file
    write_txt(format("./datas/{:.1f}-{:d}-{:d}.txt", A, DEGREE, equator_count), x_list, y_list)

end

main()
