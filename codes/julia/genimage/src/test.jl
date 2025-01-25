include("./utils.jl")
using .Utils: read_text

using Format: format

a_list = 0.1: 0.2: 1.5
r_val = 20.0
# for a_val in a_list
#     path = format("./data/{:.1f}-{:.1f}.txt", r_val, a_val)
#     print(read_text(path))
# end

path = format("./data/{:.1f}-{:.1f}.txt", r_val, a_val[1])
read_text(path)
