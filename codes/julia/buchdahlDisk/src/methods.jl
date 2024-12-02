module Methods

    include("./functions.jl")
    include("./constants.jl")
    using .Functions: gamma, integer_p_in_c, integer_p_not_in_c
    using .Constants: RADIAN, A


    function calc_a(phi)
        """
        calculate screen coordinate angle a
        """
        gamma_val = gamma(phi)
        inner_val = cos(phi) * cos(RADIAN) / sin(gamma_val)
        if abs(inner_val) > 1
            return NaN
        end
        return acos( inner_val )
    end

    function calc_b(r, phi, equator_count, p_and_v_list)
        """
        calculate screen coordinate distance b
        """
        b = 0
        if equator_count%2 == 0
            delta_phi = equator_count * pi + gamma(phi)
            b = search_b(r, delta_phi, p_and_v_list)
        elseif equator_count%2 == 1
            delta_phi = (equator_count + 1) * pi - gamma(phi)
            b = search_b(r, delta_phi, p_and_v_list)
        end
        if b == NaN
            return 3 * sqrt(3)
        end
        return b
    end

    function search_b(r, delta_phi, p_and_v_list)
        """
        search b from r and delta_phi
        """
        min_diff = 1e3
        valid_b = 10
        for i in 0.01: 0.01: 50
            # diff = abs(  - delta_phi )
            if diff < min_diff
                min_diff = diff
                valid_b = i
            end
        end
        return valid_b
    end

end
