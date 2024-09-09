module Function

include("./constants.jl")

# module
import Main.Constant

# initialize
THETA = Constant.THETA
MASS = Constant.MASS

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

function Q(P)
    return sqrt((P - 2 * MASS) * (P + 6 * MASS))
end

function m(P)
    tmp_m = (Q(P) - P + 6 * MASS) / (2 * Q(P))
    if tmp_m > 1
        return 1
    elseif tmp_m < 0
        return 0
    end
    return tmp_m
end

function b(P)
    return sqrt(P ^ 3 / (P - 2 * MASS))
end

function zeta(P)
    return asin(sqrt((Q(P) - P + 2 * MASS)/(Q(P) - P + 6 * MASS)))
end

export alpha, gamma, Q, m, b, zeta

end