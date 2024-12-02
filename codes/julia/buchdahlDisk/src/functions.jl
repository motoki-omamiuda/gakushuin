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
        return ( 1 - f(r) )^2 / ( r^2 * ( 1 + f(r) )^6 )
    end

    function search_p(b, p_and_v_list)
        """
        search p from b
        """
        min_diff = 1e3
        valid_p = 10
        for i in p_and_v_list
            diff = abs( (1 / b)^2 - i[2] )
            if diff < min_diff
                min_diff = diff
                valid_p = i[1]
            end
        end

        return valid_p
    end

    function g(u, b)
        return ( 1 / b )^2 * ( 1 + f( 1 / u ) )^6 / ( 1 - f( 1 / u ) )^2 - u^2
    end

    function integer_p_in_c(r, b, p_and_v_list)
        p_val = search_p(b, p_and_v_list)
        integer_val_00, error = quadgk( x -> 1 / sqrt( g(x, b) ), 1 / r, 1 / p_val)
        integer_val_01, error = quadgk( x -> 1 / sqrt( g(x, b) ), 0, 1 / p_val)
        return integer_val_00 + integer_val_01
    end

    function integer_p_not_in_c(r, b)
        integer_val, error = quadgk( x -> 1 / sqrt( g(x, b) ), 1 / p(b), 1 / r)
        return integer_val
    end

    export gamma, integer_p_in_c, integer_p_not_in_c

end
