# row = [1, 2]
# open("./datas/test.csv", "w") do file
#     println(file, "n=0,,")
#     println(file, "r,b,")
#     println(file, join(row, "\t"))
# end

include("./consts.jl")
include("./equas.jl")

# module
using .Consts: MASS
using .Equas: P, Q, m, zeta_inf, gamma, alpha, b, zeta_r

# library
using Elliptic
using Elliptic.Jacobi

using Plots

using PyCall
mp = pyimport("mpmath")

function func_n(p_val, r, phi, n)
    q_val = Q(p_val)
    zeta_inf_val = zeta_inf(p_val)
    m_val = m(p_val)

    ellipf = F(zeta_inf_val, m_val)
    inner = 2 * K(m_val) - ellipf - (1 / 2) * sqrt(q_val / p_val) * (2 * pi * n - gamma(phi))
    ellipfun = sn(inner, m_val)
    return ellipfun

    # term1 = (q_val - p_val + 6 * MASS) / (4 * MASS * p_val)
    # term2 = (q_val - p_val + 2 * MASS) / (4 * MASS * p_val)
    # return (term1 * ellipfun ^ 2 - term2 - 1 / r)
end

r =6 * MASS
phi = 0

plt = plot(
    # xlim=(3, 10), ylim=(-0.5, 0.5),

    legend=false,
    dpi=800, # 解像度を指定
)
x_list = []
y_list = []

for i in 3:0.01:10
    push!(x_list, b(i))
    print(func_n(i * MASS, r, phi, 3))
    # push!(y_list, gamma(phi))
    # push!(y_list, zeta_inf(i * MASS))
    # push!(y_list, K(m(i)))
    push!(y_list, func_n(i * MASS, r, phi, 3))
    # push!(y_list, func_n(i * MASS, r, phi, 3))
end
plot!(plt, x_list, y_list)
plt