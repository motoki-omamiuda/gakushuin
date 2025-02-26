module Utils

include("./consts.jl")
include("./equas.jl")

# module
using .Consts: MASS
using .Equas: P, Q, m, zeta_inf, gamma, alpha, b


# library
using Elliptic
using Elliptic.Jacobi
using Plots
using Formatting

using PyCall
mp = pyimport("mpmath")


function search_zero(f, min, max)
    """
    関数の零点を求める
    """
    tmp_max = 1e10
    rtv = 0
    for i in min:0.025:max
        if f(i) < tmp_max
            tmp_max = f(i)
            rtv = i
        end
    end
    return rtv
end


function func_0(b, r, phi)
    p_val = P(b)
    q_val = Q(p_val)
    zeta_inf_val = zeta_inf(p_val)
    m_val = m(p_val)

    ellipf = @pycall mp.ellipf(zeta_inf_val, m_val)::Complex{Float64}
    inner = gamma(phi) * sqrt(q_val / p_val) / 2 + ellipf
    ellipfun = @pycall mp.ellipfun("sn", inner, m_val)::Complex{Float64}

    term1 = (q_val - p_val + 6 * MASS) / (4 * MASS * p_val)
    term2 = (q_val - p_val + 2 * MASS) / (4 * MASS * p_val)
    return abs(term1 * ellipfun ^ 2 - term2 - 1 / r)
    # return real(term1 * ellipfun ^ 2 - term2 - 1 / r)
end


function func_n(p_val, r, phi, n)
    q_val = Q(p_val)
    zeta_inf_val = zeta_inf(p_val)
    m_val = m(p_val)

    ellipf = F(zeta_inf_val, m_val)
    inner = 2 * K(m_val) - ellipf - (1 / 2) * sqrt(q_val / p_val) * (2 * pi * n - gamma(phi))
    ellipfun = sn(inner, m_val)

    term1 = (q_val - p_val + 6 * MASS) / (4 * MASS * p_val)
    term2 = (q_val - p_val + 2 * MASS) / (4 * MASS * p_val)
    return abs(term1 * ellipfun ^ 2 - term2 - 1 / r)
end


function calc_partial_image(r, phi, n=0)
    """
    降着円盤上の粒子に対応した像の位置を計算する
    """
    alpha_val = alpha(phi)
    if n == 0
        f = b -> func_0(b, r, phi)
        b_val = search_zero(f, 0.01 * MASS, 40 * MASS)
        # b_val = binary_search_zero(f, 0.01 * MASS, 40 * MASS)
    else
        f = p -> func_n(p, r, phi, n)
        p_val = search_zero(f, 3 * MASS, 40 * MASS)
        b_val = b(p_val)
    end
    return b_val, alpha_val
end


function plot_orbit_image(plt, b_list, alpha_list, reverse=false)
    """
    極座標系のデータを直交座標系に変換して描画する
    """
    y_sign = reverse ? 1 : -1
    x_sign = 1
    x_list, y_list = [], []

    for i in 1:length(b_list)
        if i > 2
            # theta の増減が逆転したら符号を反転
            before_step = alpha_list[i - 1] - alpha_list[i - 2]
            now_step = alpha_list[i] - alpha_list[i - 1]
            if before_step * now_step < 0
                x_sign *= -1
            end
            x = x_sign * b_list[i] * sin(alpha_list[i])
            y = y_sign * b_list[i] * cos(alpha_list[i])
            push!(x_list, x)
            push!(y_list, y)
        else
            x = x_sign * b_list[i] * sin(alpha_list[i])
            y = y_sign * b_list[i] * cos(alpha_list[i])
            push!(x_list, x)
            push!(y_list, y)
        end
    end
    color_values = range(0, stop=1, length=length(x_list))
    plot!(plt, x_list, y_list, line_z=color_values, c=:viridis)

    return plt
end


function plot_orbit_gif(DEG, r, E, L)
    """
    極座標系のデータを直交座標系に変換して描画する
    """
    n_list = [0, 1]
    x_list, y_list = [], []

    for i in 1:length(n_list)
        push!(x_list, [])
        push!(y_list, [])

        if n_list[i] % 2 == 0
            global reverse = false
        else
            global reverse = true
        end

        y_sign = reverse ? 1 : -1
        x_sign = reverse ? -1 : 1
        # x_sign = 1

        local path = format("./datas/r={:.2f},E={:.2f},L={:.2f},n={:.2f}", r, E, L, n_list[i])
        local b_list, alpha_list = read_text(path)

        for j in 1:length(b_list)
            if j > 2
                # theta の増減が逆転したら符号を反転
                before_step = alpha_list[j - 1] - alpha_list[j - 2]
                now_step = alpha_list[j] - alpha_list[j - 1]
                if before_step * now_step < 0
                    x_sign *= -1
                end
                x = x_sign * b_list[j] * sin(alpha_list[j])
                y = y_sign * b_list[j] * cos(alpha_list[j])
                push!(x_list[i], x)
                push!(y_list[i], y)
            else
                x = x_sign * b_list[i] * sin(alpha_list[j])
                y = y_sign * b_list[i] * cos(alpha_list[j])
                push!(x_list[i], x)
                push!(y_list[i], y)
            end
        end
    end

    anim = @animate for i in 1:length(x_list[1])
        plot(x_list[1][1:i], y_list[1][1:i], xlim=(-35, 35), ylim=(-35, 35), ratio=1, linewidth=2, dpi=600, legend=false, color="#ff7f50")
        plot!(x_list[2][1:i], y_list[2][1:i], xlim=(-35, 35), ylim=(-35, 35), ratio=1, linewidth=2, dpi=600, legend=false, color="#4169e1")
    end

    return anim
end


function write_text(path, b_list, alpha_list)
    """
    テキストファイルに書き込む
    """
    open(path, "w") do file
        println(file, "b,alpha")
        for (b, alpha) in zip(b_list, alpha_list)
            println(file, join([b, alpha], ","))
        end
    end
end


function read_text(path)
    """
    テキストファイルを読み込む
    """
    lines = readlines(path)
    split(strip(lines[1]), ",") # delete header
    b_list = []
    alpha_list = []
    for line in lines[2:end]
        push!(b_list, parse(Float64, split(strip(line), ",")[1]))
        push!(alpha_list, parse(Float64, split(strip(line), ",")[2]))
    end
    return b_list, alpha_list
end

export plot_orbit_image, plot_orbit_gif ,read_text, write_text, calc_partial_image

end