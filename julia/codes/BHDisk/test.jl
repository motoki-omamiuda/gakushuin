# include("./structs.jl")
# include("./functions.jl")
# include("./constants.jl")

# # module
# import Main.Struct
# import Main.Function
# import Main.Constant

# # library
# import Elliptic
# import Elliptic.Jacobi

# # using library
# using Optim
# using Printf
# using Plots
# using Formatting

# # initialize
# THETA = Constant.THETA
# MASS = Constant.MASS


# tmp_gamma = Function.gamma(2.138)
# n = 1
# f(P) = 10 * abs(
#     ( Function.Q(P) - P + 6 * MASS )/( 4 * MASS * P )
#     * Elliptic.Jacobi.sn(
#         2 * Elliptic.K( Function.m(P) )
#         - Elliptic.F(
#             Function.zeta_inf(P),
#             Function.m(P)
#         )
#         - sqrt( Function.Q(P) / P ) * ( pi * n - tmp_gamma/ 2 ),
#         Function.m(P)
#     ) ^ 2
#     - ( Function.Q(P) - P + 2 * MASS )/( 4 * MASS * P )
#     - 1 / 30
# )

# x = []
# y = []
# for i in 3:0.01:45
#     push!(x, i)
#     push!(y, f(i))
# end
# plt = plot(
#     xlim=(3, 40), ylim=(-1, 2),
#     legend=false,
#     dpi=800, # 解像度を指定
# )
# print(f(39.999998891727195))
# plot!(plt, x, y)
# plt
a = [1, 2]
print(a[1])