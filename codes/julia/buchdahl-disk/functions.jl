module Functions
    using QuadGK: quadgk

    include("./constants.jl")
    using .Constants: RADIAN, A


    function gamma(phi)
        """
        gamma
        """
        inner_val = cos(phi) * sin(RADIAN)
        return acos( inner_val )
    end

    function f(r)
        return A / (2 * sqrt(1 + A^2 * r^2))
    end

    function v_eff(r)
        """
        effective potential
        """
        # buchdahl
        return ( 1 - f(r) )^2 / ( r^2 * ( 1 + f(r) )^6 )

        # schwarzschild
        # return (1 / r)^2 * (1 - 2 / r)
    end

    function g(u, b)
        # buchdahl
        return ( 1 / b )^2 * ( 1 + f( 1 / u ) )^6 / ( 1 - f( 1 / u ) )^2 - u^2

        # schwarzschild
        # return 2 * u^3 - u^2 + ( 1 / b )^2
    end

    function integer_p_in_c(r, b, p)
        print("r:\t", r, "\n")
        print("b:\t", b, "\n")
        print("p:\t", p, "\n")

        print("g(1/p, b):\t", g(1/p, b), "\n")
        print("g(1/r, b):\t", g(1/r, b), "\n")
        print("g(0, b):\t", g(0, b), "\n")

        integer_val_00, error = quadgk( x -> 1 / sqrt( g(x, b) ), 1 / r, 1 / p)
        integer_val_01, error = quadgk( x -> 1 / sqrt( g(x, b) ), 0, 1 / p)
        return integer_val_00 + integer_val_01

        # try
        #     integer_val_00, error = quadgk( x -> 1 / sqrt( g(x, b) ), 1 / r, 1 / p)
        #     integer_val_01, error = quadgk( x -> 1 / sqrt( g(x, b) ), 0, 1 / p)
        #     return integer_val_00 + integer_val_01
        # catch
        #     return 1e3
        # end
    end

    function integer_p_not_in_c(r, b)
        print("r:\t", r, "\n")

        print("g(1/r, b):\t", g(1/r, b), "\n")
        print("g(0, b):\t", g(0, b), "\n")

        integer_val, error = quadgk( x -> 1 / sqrt( g(x, b) ), 0, 1 / r)
        return integer_val

        # try
        #     integer_val, error = quadgk( x -> 1 / sqrt( g(x, b) ), 0, 1 / r)
        #     return integer_val
        # catch
        #     return 1e3
        # end
    end

    function search_p(b, r_and_v_lists)
        """
        search p from b
        """
        min_diff = 1e3
        valid_p = 10
        for i in r_and_v_lists
            diff = abs( (1 / b)^2 - i[2] )
            if diff < min_diff && 0 < g(1 / i[1], b)
                min_diff = diff
                valid_p = i[1]
            end
        end
        return valid_p
    end

    function create_r_and_v_list()
        """
        create r and v_eff(r) list
        """
        r_and_v_lists = []

        local_max = 0
        before_diff = 0
        after_diff = 0

        diff = 0.001
        for r in 2 * diff: diff: 30 - diff
            v_eff_val = v_eff(r)
            push!(r_and_v_lists, [r, v_eff_val])

            before_diff = v_eff_val - v_eff(r - diff)
            after_diff = v_eff(r + diff) - v_eff_val
            if 0 < before_diff && after_diff < 0
                local_max = [r, v_eff(r)]
            end
        end

        if local_max == 0
            return r_and_v_lists
        end

        copy_obj = copy(r_and_v_lists)
        for i in reverse(eachindex(copy_obj))
            r_and_v_list = copy_obj[i]
            if r_and_v_list[1] < local_max[1] && r_and_v_list[2] < local_max[2]
                deleteat!(r_and_v_lists, i)
            end
        end
        return r_and_v_lists
    end

end
