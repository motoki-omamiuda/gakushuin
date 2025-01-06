using Format

include("./methods.jl")
include("./constants.jl")
using .Methods: read_txt, write_txt
using .Constants: A, DEGREE

a_list, b_list = read_txt(format("./datas/{:.1f}-{:d}-{:d}.txt", A, DEGREE, 1))
list_data = []
for (a_val, b_val) in zip(a_list, b_list)
    push!(list_data, [a_val, b_val])
end

open("./datas/0.9-80-1-01.txt", "w") do file
    for data in list_data
        println(file, join(data, ","))
    end
end
