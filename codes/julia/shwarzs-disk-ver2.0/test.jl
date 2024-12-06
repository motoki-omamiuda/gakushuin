using QuadGK: quadgk
using Roots: find_zero

A = 1.0

function f(r)
    return A / (2 * sqrt(1 + A^2 * r^2))
end

function g(u, b)
    # return ( 1 / b )^2 * ( 1 + f(1/u) )^6 / ( 1 - f(1/u) )^2 - u^2
    return u^3 - u-2 + 1/b^2
end

function integer_g(u, b)
    integer_g_val, error = quadgk( x -> 1 / sqrt( g(x, b) ), 0, u)
    return integer_g_val
end

for b in 1: 0.01: 20
    diff = integer_g(1 / 10, b) - pi/2
    println(diff)
    if abs(diff) < 0.01
        println(b)
        break
    end
end


# result = find_zero(b -> integer_g(1 / 10, b) - 10, [0.0, 100])

# # function h(x)
# #     return 1 / x^2
# # end

# # # result, error = quadgk(b -> 1 / sqrt( g(10, b) ), 0, 1)
# # result = find_zero(x -> h(x) - 10, [0.0, 100])

# println(result)