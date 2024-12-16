module Methods

    include("./functions.jl")
    include("./constants.jl")
    using .Functions: gamma, search_p, binary_search_p, integer_p_in_c, integer_p_not_in_c
    using .Constants: RADIAN, A

    using Plots
    using Format


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

    function calc_b(r, phi, equator_count, r_and_v_lists)
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

        min_b = []

        pre_p = binary_search_p(1, r_and_v_lists)
        pre_fir = left_delta_phi - integer_p_in_c(r, 1, pre_p)
        pre_sec = left_delta_phi - integer_p_not_in_c(r, 1)
        diff = 0.01
        for b in 1 + diff: diff: 30
            now_p = binary_search_p(b, r_and_v_lists)
            if r < now_p
                continue
            end

            now_fir = left_delta_phi - integer_p_in_c(r, b, now_p)
            now_sec = left_delta_phi - integer_p_not_in_c(r, b)
            if pre_fir * now_fir < 0
                push!(min_b, b)
            elseif pre_sec * now_sec < 0
                push!(min_b, b)
            end

            pre_p = now_p
            pre_fir = now_fir
            pre_sec = now_sec
        end
        return min_b

        min_diff = 1e3
        min_b = 1e3
        for b in 1: 0.01: 30
            # search_p(r, r_and_v_lists)
            # binary_search_p(r, r_and_v_lists)
            p = search_p(b, r_and_v_lists)
            if r < p
                continue
            end

            fir_right_delta_phi = integer_p_in_c(r, b, p)
            sec_right_delta_phi = integer_p_not_in_c(r, b)

            # print("left:\t", left_delta_phi, "\n")
            print("int_p_in_c:\t", fir_right_delta_phi, "\n")
            print("int_p_not_in_c:\t", sec_right_delta_phi, "\n")
            print("diff_in_p:\t", left_delta_phi - fir_right_delta_phi, "\n")
            print("diff_not_in_p:\t", left_delta_phi - sec_right_delta_phi, "\n")

            if abs(left_delta_phi - fir_right_delta_phi) < min_diff
                min_diff = abs(left_delta_phi - fir_right_delta_phi)
                min_b = b
            elseif abs(left_delta_phi - sec_right_delta_phi) < min_diff
                min_diff = abs(left_delta_phi - sec_right_delta_phi)
                min_b = b
            end
        end
        return min_b
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

    function plots(name, x_list, y_list)
        """
        plot x and y list
        """
        plt = plot( xlim=(0, 30), ylim=(0, 0.5), legend=false, dpi=1600)
        scatter!(plt, x_list, y_list, color=:black, markersize=0.1)
        savefig(plt, format("./images/{:s}.png", name))
    end

end
