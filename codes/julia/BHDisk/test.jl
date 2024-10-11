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
using .Equas: P, Q, m, zeta_inf, gamma, alpha, b

# library
using Elliptic
using Elliptic.Jacobi

using Plots

using PyCall
mp = pyimport("mpmath")

function func_0(b, r, phi)
    p_val = P(b)
    q_val = Q(p_val)
    zeta_inf_val = zeta_inf(p_val)
    m_val = m(p_val)

    ellipf = @pycall mp.ellipf(zeta_inf_val, m_val)::Complex{Float64}
    inner = gamma(phi) * sqrt(q_val / p_val) / 2 + ellipf
    ellipfun = @pycall mp.ellipfun("sn", inner, m_val)::Complex{Float64}

    term1 = (q_val - p_val + 6 * MASS) / (4 * MASS * p_val)
    term2 = (q_val - p_val + 2 * MASS) / (4 * MASS * p_val)
    return real(term1 * ellipfun ^ 2 - term2 - 1 / r)::Float64
end

function binary_search_zero(func, left, right)
    global av
    av = 0
    for i in 0:50
        # log
        print("left: ", left, "\t")
        print("func(left): ", func(left), "\n")
        print("right: ", right, "\t")
        print("func(right): ", func(right), "\n")
        global av = (left + right) / 2
        if abs(func(av)) < 1.0e-3
            return av
        end
        if func(left) * func(av) < 0
            right = av
        else
            left = av
        end
    end
    return av
end


r = 2 * MASS

# for i in 0:0.01:pi
#     f = b_val -> func_0(b_val, r, i)
#     b_val = binary_search_zero(f, 0.01 * MASS, 40 * MASS)
#     print(i, "\t")
#     print(b_val, "\n")
# end

f = b_val -> func_0(b_val, r, 0.05)
b_val = binary_search_zero(f, 0.01 * MASS, 40 * MASS)
print(b_val, "\n")

# phi = 0.05
# plt = plot(
#     xlim=(0, 35), ylim=(-35, 35),
#     legend=false,
#     ratio=1, # アスペクト比を指定
#     dpi=800, # 解像度を指定
# )
# x_list = []
# y_list = []
# for i in 0.01:40
#     push!(x_list, i)
#     print(func_0(i * MASS, r, phi))
#     push!(y_list, func_0(i * MASS, r, phi))
# end
# plot!(plt, x_list, y_list)
# plt