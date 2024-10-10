row = [1, 2]
open("./datas/test.csv", "w") do file
    println(file, "n=0,,")
    println(file, "r,b,")
    println(file, join(row, "\t"))
end