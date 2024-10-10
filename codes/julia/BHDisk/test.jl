# row = [1, 2]
# open("./datas/test.csv", "w") do file
#     println(file, "n=0,,")
#     println(file, "r,b,")
#     println(file, join(row, "\t"))
# end

using Formatting

a = 1
b = 2
path = format("./datas/test/{:d}M_{:d}.csv", a, b)
mkdir("./datas/test/")
open(path, "w") do file
    println(file, "b,alpha")
end