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
    return abs(term1 * ellipfun ^ 2 - term2 - 1 / r)
end


r = 2 * MASS
phi = 0.001

f = b -> func_0(b, r, phi)

global left, right

left = 0 * MASS
right = 40 * MASS

for i in 0:100
    av = (left + right) / 2
    println("$i : $left, $right : $(f(av))")
    if abs(f(av)) < 1.0e-8
        break
    end
    if f(left) * f(av) < 0
        global right = av
    else
        global left = av
    end
end