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

    output_data = []
    diff = pi / 200
    for phi in 0: diff: pi
        a_val = calc_a(phi)
        b_val = calc_b(20, phi, equator_count, r_and_v_list)
        print("a:\t", a_val, "\n")
        print("b:\t", b_val, "\n")

        push!(output_data, create_output_data(a_val, b_val))
    end

    write_txt(
        format("./data/{:.1f}/{:d}-{:d}.txt",A, DEGREE, equator_count),
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


for i in 0:1
    main(i)
end
