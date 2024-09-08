module Function

include("./constants.jl")

# module
import Main.Constant

# initialize
THETA = Constant.THETA
MASS = Constant.MASS

function alpha(phi)
    return acos(cos(phi) * cos(THETA) * ( 1 - cos(phi) ^ 2 * sin(THETA) ^ 2 ) ^ ( - 1 / 2 ))
end

function gamma(phi)
    return acos(cos(alpha(phi)) * (cos(alpha(phi)) ^ 2 + (cos(THETA) / sin(THETA)) ^ 2) ^ ( - 1 / 2 ))
end

function Q(P)
    return sqrt((P - 2 * MASS) * (P + 6 * MASS))
end

function m(P)
    return (Q(P) - P + 6 * MASS) / (2 * Q(P))
end

function b(P)
    return sqrt(P ^ 3 / (P - 2 * MASS))
end

function zeta(P)
    return asin(sqrt((Q(P) - P + 2 * MASS)/(Q(P) - P + 6 * MASS)))
end

export alpha, gamma, Q, m, b, zeta

end