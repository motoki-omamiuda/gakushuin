using Format
using Plots

####################################
# 平均計算
####################################
# degree = 80
# a_val = 0.1
# equator_count = 0

# new_data = []
# open(format("./{:d}-data/{:.1f}/{:d}-{:d}.txt", degree, a_val, degree, equator_count), "r") do file
#     lines = readlines(file)
#     for line in lines
#         split_line = []
#         for element in split(line, ",")
#             parse_ele = parse(Float64, element)
#             push!(split_line, parse_ele)
#         end
#         average = sum(split_line[2:end]) / length(split_line[2:end])
#         push!(new_data, [split_line[1], average])
#     end
# end

# open(format("./{:d}-data/{:.1f}/new-{:d}-{:d}.txt", degree, a_val, degree, equator_count), "w") do file
#     for data in new_data
#         print(file, join(data, ","))
#         print(file, "\n")
#     end
# end

####################################
# テストプロット
####################################
degree = 80
a_val = 0.3
equator_count = 0

a_list = []
b_list = []
open(format("./{:d}-data/{:.1f}/{:d}-{:d}.txt", degree, a_val, degree, equator_count), "r") do file
    lines = readlines(file)
    for line in lines
        push!(a_list, parse(Float64, split(line, ",")[1]))
        push!(b_list, parse(Float64, split(line, ",")[2]))
    end
end

plt = plot(xlim=(0, pi), label=NaN, legend=false)
scatter!(plt, a_list, b_list, color=:red, ms=2, msw=0)
savefig(plt, "test.png")
