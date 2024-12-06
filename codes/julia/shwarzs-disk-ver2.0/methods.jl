module Methods

    include("./functions.jl")
    include("./constants.jl")
    using .Functions: gamma, search_p, integer_p_in_c, integer_p_not_in_c
    using .Constants: RADIAN, A

    using Plots


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

    function calc_b(r, phi, equator_count, r_and_v_list)
        """
        calculate screen coordinate distance b
        """
        left_delta_phi = 0
        if equator_count%2 == 0
            left_delta_phi = equator_count * pi + gamma(phi)
        elseif equator_count%2 == 1
            left_delta_phi = (equator_count + 1) * pi - gamma(phi)
        end

        fir_right_delta_phi = 0
        sec_right_delta_phi = 0
        for b in 3 * sqrt(3): 0.01: 30
        # for b in 1: 0.01: 30
            p = search_p(b, r_and_v_list)
            if r < p
                continue
            end

            fir_right_delta_phi = integer_p_in_c(r, b, p)
            sec_right_delta_phi = integer_p_not_in_c(r, b)

            # print("left:\t", left_delta_phi, "\n")
            print("int_p_in_c:\t", fir_right_delta_phi, "\n")
            print("int_p_not_in_c:\t", sec_right_delta_phi, "\n")

            if abs(left_delta_phi - fir_right_delta_phi) < 0.1 || abs(left_delta_phi - sec_right_delta_phi) < 0.1
                return b
            end
        end
        return 10
    end

    function write_txt(path, x_list, y_list)
        """
        write x and y list to txt file
        """
        open(path, "w") do file
            for (x, y) in zip(x_list, y_list)
                println(file, join([x, y], ","))
            end
        end
    end

    function read_txt(path)
        """
        read x and y list from txt file
        """
        lines = readlines(path)
        x_list = []
        y_list = []
        for line in lines
            push!(x_list, parse(Float64, split(strip(line), ",")[1]))
            push!(y_list, parse(Float64, split(strip(line), ",")[2]))
        end
        return x_list, y_list
    end

end
