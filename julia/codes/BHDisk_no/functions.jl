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

function P(b)
    y = b / MASS
    return (- y ^ 2 + y ^ 2 * sqrt( Complex( 1 - (y ^ 2 / 27) ) )) ^ (1 / 3) + (- y ^ 2 - y ^ 2 * sqrt( Complex( 1 - (y ^ 2 / 27) ) )) ^ (1 / 3)
    # if y > 3 * sqrt(3)
    #     return (- y ^ 2 + y ^ 2 * sqrt( Complex( 1 - (y ^ 2 / 27) ) )) ^ (1 / 3) + (- y ^ 2 - y ^ 2 * sqrt( Complex( 1 - (y ^ 2 / 27) ) )) ^ (1 / 3)
    # else
    #     return Complex(- y ^ 2 + y ^ 2 * sqrt(1 - (y ^ 2 / 27))) ^ (1 / 3) * ( - 1 / 2 + ( sqrt(3) / 2 )im) + Complex(- y ^ 2 - y ^ 2 * sqrt(1 - (y ^ 2 / 27))) ^ (1 / 3) * ( - 1 / 2 + ( sqrt(3) / 2 )im)
    # end
end

function Q(P)
    return sqrt( (P - 2 * MASS) * (P + 6 * MASS) )
end

function m(P)
    tmp_m = (Q(P) - P + 6 * MASS) / (2 * Q(P))
    # print("m: ", tmp_m, "\n")
    if abs(tmp_m) > 1
        return 1
    elseif abs(tmp_m) < 0
        return 0
    end
    return tmp_m
end

function b(P)
    return sqrt(P ^ 3 / (P - 2 * MASS))
end

function zeta_inf(P)
    return asin( sqrt((Q(P) - P + 2 * MASS) / (Q(P) - P + 6 * MASS)) )
end

function zeta_r(P, r)
    inner = sqrt((Q(P) - P + 2 * MASS + ( 4 * MASS * P / r )) / (Q(P) - P + 6 * MASS))
    # if inner > 1
    #     return 10^5
    # elseif inner < -1
    #     return 10^5
    # end
    return asin( inner )
end

export alpha, gamma, P, Q, m, b, zeta_inf, zeta_r

end