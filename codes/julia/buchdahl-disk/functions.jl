module Functions
    using QuadGK: quadgk

    include("./constants.jl")
    using .Constants: RADIAN, A


    function gamma(phi)
        return acos( cos(phi) * sin(RADIAN) )
    end


    function f(r)
        return A / (2 * sqrt(1 + A^2 * r^2))
    end


    function v_eff(r)
        return ( 1 - f(r) )^2 / ( r^2 * ( 1 + f(r) )^6 )
    end


    function g(u, b)
        return ( 1 / b )^2 * ( 1 + f( 1 / u ) )^6 / ( 1 - f( 1 / u ) )^2 - u^2
    end


    function create_r_and_v_list()
        r_and_v_list = []

        diff_val = 1e-5
        for r_val in 0.002: diff_val: 0.1
            push!(r_and_v_list, [r_val, v_eff(r_val)])
        end

        diff_val = 1e-4
        for r_val in 0.1 + diff_val: diff_val: 1.0
            push!(r_and_v_list, [r_val, v_eff(r_val)])
        end

        diff_val = 1e-3
        for r_val in 1.0 + diff_val: diff_val: 35.0
            push!(r_and_v_list, [r_val, v_eff(r_val)])
        end

        local_max = 0
        local_r = 0
        for i in 2: length(r_and_v_list) - 1
            if (
                r_and_v_list[i-1][2] < r_and_v_list[i][2]
                && r_and_v_list[i+1][2] < r_and_v_list[i][2]
            )
                local_max = r_and_v_list[i][2]
                local_r = r_and_v_list[i][1]
            end
        end

        if local_max == 0
            return r_and_v_list
        end

        copy_r_and_v_list = copy(r_and_v_list)
        for i in reverse(eachindex(copy_r_and_v_list))
            r_and_v_val = copy_r_and_v_list[i]
            if (
                r_and_v_val[1] < local_r
                && r_and_v_val[2] < local_max
            )
                deleteat!(r_and_v_list, i)
            end
        end
        return r_and_v_list
    end


    function binary_search_p(b, r_and_v_list)
        left = 1
        right = length(r_and_v_list)

        if (
            (r_and_v_list[left][2] - 1 / b^2)
            * (r_and_v_list[right][2] - 1 / b^2) > 0
        )
            return r_and_v_list[left][1]
        end

        while left < right
            mid = div(left + right, 2)
            if r_and_v_list[mid][2] - 1 / b^2 > 0
                left = mid + 1
            else
                right = mid
            end
        end
        return r_and_v_list[right][1]
    end


    function integer_p_in_c(r, b, p)
        # print("r:\t", r, "\n")
        # print("b:\t", b, "\n")
        # print("p:\t", p, "\n")

        # print("g(1/p, b):\t", g(1/p, b), "\n")
        # print("g(1/r, b):\t", g(1/r, b), "\n")
        # print("g(0, b):\t", g(0, b), "\n")

        integer_val_00, error = quadgk( x -> 1 / sqrt( g(x, b) ), 1 / r, 1 / p)
        integer_val_01, error = quadgk( x -> 1 / sqrt( g(x, b) ), 0, 1 / p)
        return integer_val_00 + integer_val_01
    end

    function integer_p_not_in_c(r, b)
        # print("r:\t", r, "\n")

        # print("g(1/r, b):\t", g(1/r, b), "\n")
        # print("g(0, b):\t", g(0, b), "\n")

        integer_val, error = quadgk( x -> 1 / sqrt( g(x, b) ), 0, 1 / r)
        return integer_val
    end

end