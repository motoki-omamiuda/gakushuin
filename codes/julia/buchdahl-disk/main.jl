using Revise: includet
using Format

includet("./methods.jl")
includet("./constants.jl")
includet("./functions.jl")

using .Methods: calc_a, calc_b, write_txt, read_txt, plots
using .Functions: create_r_and_v_list
using .Constants: A, DEGREE


function main(equator_count)
    r_and_v_list = create_r_and_v_list()

    # r_val = 30
    # r_val = 20
    # r_val = 10
    # r_val = 6
    r_val = 3

    output_data = []
    diff = pi / 200
    for phi in 0: diff: pi
        a_val = calc_a(phi)
        b_val = calc_b(r_val, phi, equator_count, r_and_v_list)
        print("a:\t", a_val, "\n")
        print("b:\t", b_val, "\n")

        push!(output_data, create_output_data(a_val, b_val))
    end

    write_txt(
        format("./{:d}-data/{:.1f}/{:d}-{:d}-{:d}.txt", DEGREE, A, DEGREE, equator_count, r_val),
        output_data
    )
end

function create_output_data(a_val, b_val)
    return_value = []
    push!(return_value, a_val)
    for b in b_val
        push!(return_value, b)
    end
    return return_value
end

main(0)
main(1)