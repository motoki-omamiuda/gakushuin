using Format

include("./methods.jl")
include("./constants.jl")
using .Methods: write_txt
using .Constants: A, DEGREE


function read_text(path)
    """
    read x and y list from txt file
    """
    lines = readlines(path)
    x_list = []
    y_list = []
    for line in lines
        push!(x_list, parse(Float64, split(strip(line), ",")[1]))
        push!(y_list, parse(Float64, split(strip(line), ",")[2]))
    end
    print(x_list, "\n")
    print(y_list, "\n")
    return x_list, y_list
end


equator_count = 1
a_list, b_list = read_text(format("./data/{:.1f}/{:d}-{:d}.txt", A, DEGREE, equator_count))
list_data = []
for (a_val, b_val) in zip(a_list, b_list)
    push!(list_data, [a_val, b_val])
end

open(format("./data/{:.1f}/{:d}-{:d}-00.txt", A, DEGREE, equator_count), "w") do file
    for data in list_data
        println(file, join(data, ","))
    end
end
