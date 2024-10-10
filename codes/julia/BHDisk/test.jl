# using PyCall
# mp = pyimport("mpmath")

# f = mp.ellipfun("sn", 1 + 3im, 0.5)
# # print(keys(f))

# for i in keys( f )
#     print(i, "\t")
#     print(f[i], "\n")
# end

# print("this is ")
# print( pycall(f.real.__float__, Float64) )
# print( pycall(f.imag.__float__, Float64) )
# print( Complex( pycall(f.real.__float__, Float64), pycall(f.imag.__float__, Float64) ) )
# # print(keys(f["__complex__"]))
# # print(f["__complex__"])
# # print(Complex(1 + f))

using PyCall
math = pyimport("math")
math.sin(1.0)::Float64