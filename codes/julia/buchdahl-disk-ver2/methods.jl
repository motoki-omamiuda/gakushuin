module Methods

    include("./functions.jl")
    include("./constants.jl")
    using .Functions: gamma, binary_search_p, integer_p_in_c, integer_p_not_in_c
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

    function calc_b(r, phi, equator_count, r_and_v_list)
        """
        calculate screen coordinate distance b
        """
        # calculate delta phi from geometric considerations
        left_delta_phi = 0
        if equator_count%2 == 0
            left_delta_phi = equator_count * pi + gamma(phi)
        elseif equator_count%2 == 1
            left_delta_phi = (equator_count + 1) * pi - gamma(phi)
        end

        # calculate delta phi from geometric considerations
        fir_list = []
        sec_list = []
        b_list = []
        for b_val in 0.1: 0.01: 30
            p = binary_search_p(b_val, r_and_v_list)
            if r < p
                continue
            end
            push!(
                fir_list,
                left_delta_phi - integer_p_in_c(r, b_val, p)
            )
            push!(
                sec_list,
                left_delta_phi - integer_p_not_in_c(r, b_val)
            )
            push!(b_list, b_val)
        end

        # calculate b value
        b_return_value = []
        pre_fir_sum = (
            fir_list[1]
            + fir_list[2]
            + fir_list[3]
            + fir_list[4]
            + fir_list[5]
        )
        pre_sec_sum = (
            sec_list[1]
            + sec_list[2]
            + sec_list[3]
            + sec_list[4]
            + sec_list[5]
        )
        for i in 5: length(fir_list) - 5
            next_fir_sum = (
                fir_list[i+4]
                + fir_list[i+3]
                + fir_list[i+2]
                + fir_list[i+1]
                + fir_list[i]
            )
            next_sec_sum = (
                sec_list[i+4]
                + sec_list[i+3]
                + sec_list[i+2]
                + sec_list[i+1]
                + sec_list[i]
            )
            if pre_fir_sum * next_fir_sum < 0
                push!(b_return_value, b_list[i])
            elseif pre_sec_sum * next_sec_sum < 0
                push!(b_return_value, b_list[i])
            end
            pre_fir_sum = next_fir_sum
            pre_sec_sum = next_sec_sum
        end
        return b_return_value
    end


    function write_txt(path, list_data)
        """
        write x and y list to txt file
        """
        open(path, "w") do file
            for data in list_data
                println(file, join(data, ","))
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
        print(x_list, "\n")
        print(y_list, "\n")
        return x_list, y_list
    end

    function plots(name, x_list, y_list, color)
        """
        plot x and y list
        """
        plt = plot( xlim=(0, 30), ylim=(0, 0.5), legend=false, dpi=1600)
        plot!(plt, x_list, y_list, color=color)
        savefig(plt, format("./images/{:s}.png", name))
    end

end
