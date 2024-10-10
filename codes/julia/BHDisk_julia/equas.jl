module Equas

include("./consts.jl")

# module
using .Consts: MASS, THETA

function alpha(phi)
    cos_alpha = ( cos(phi) * cos(THETA) ) / sqrt( 1 - cos(phi) ^ 2 * sin(THETA) ^ 2 )
    if cos_alpha > 1
        return acos(1)
    elseif cos_alpha < -1
        return acos(-1)
    end
    return acos(cos_alpha)
end

function gamma(phi)
    return acos( cos(alpha(phi)) / sqrt( cos(alpha(phi)) ^ 2 + (cos(THETA) / sin(THETA)) ^ 2 ) )
end

function P(b)
    b_norm = b / MASS
    var_00 = b_norm ^ 2 * sqrt( Complex(1 - (b_norm ^ 2 / 27)) )
    return (
        (- b_norm ^ 2 + var_00) ^ (1 / 3) + (- b_norm ^ 2 - var_00) ^ (1 / 3)
    )
end

function Q(P)
    return sqrt( (P - 2 * MASS) * (P + 6 * MASS) )
end

function m(P)
    m_var = (Q(P) - P + 6 * MASS) / (2 * Q(P))
    if abs(m_var) > 1
        return 1
    elseif abs(m_var) < 0
        return 0
    end
    return m_var
end

function b(P)
    return sqrt(P ^ 3 / (P - 2 * MASS))
end

function zeta_inf(P)
    return asin( sqrt((Q(P) - P + 2 * MASS) / (Q(P) - P + 6 * MASS)) )
end

function zeta_r(P, r)
    inner = sqrt((Q(P) - P + 2 * MASS + ( 4 * MASS * P / r )) / (Q(P) - P + 6 * MASS))
    return asin( inner )
end

export alpha, gamma, P, Q, m, b, zeta_inf, zeta_r

end