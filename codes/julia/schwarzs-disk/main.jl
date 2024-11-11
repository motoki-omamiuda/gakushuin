include("./consts.jl")
include("./equas.jl")
include("./utils.jl")

# module
using .Consts: MASS, DEGREE
using .Utils: calc_disk_image, plot_disk_image, write_text
using .Equas: alpha

# library
using Printf
using Plots
using Formatting
using Roots: find_zero

# python library
using PyCall
mp = pyimport("mpmath")


function init()
    global plt = plot(
        xlim=(-35, 35), ylim=(-35, 35),
        legend=false,
        ratio=1, # アスペクト比を指定
        dpi=800, # 解像度を指定
    )
    theta = range(0, stop=2*pi, length=100)
    for (i, j) in zip([2, 3 * sqrt(3)], [0.6, 0.3])
        plot!(plt, i .* MASS .* cos.(theta), i .* MASS .* sin.(theta), linewidth=0, fillcolor=:black, fillalpha=j, fillrange=0)
    end
end


function output()
    savefig(plt, format("./images/{:d}.png", DEGREE))
end

function main()

    r_list = [2, 6, 10, 20, 30].* MASS
    n = 1

    phi_list = []
    phi = 0.0
    while phi <= pi
        # phi_diff = 1 / 10 ^ ((1 + cos(phi) ^ 2) * 0.5) # 一瞬で終わらせたい場合
        phi_diff = 1 / 10 ^ ((1 + cos(phi) ^ 2) * 1.5)
        phi += phi_diff
        push!(phi_list, phi)
    end

    for r in r_list
        b_list = []
        alpha_list = []
        for phi in phi_list
            b_val, alpha_val = calc_disk_image(r, phi, n)
            if !isnan(b_val)
                push!(b_list, b_val)
                push!(alpha_list, alpha_val)
                println("r: ", r,  " phi: ", phi, " b: ", b_val, " alpha: ", alpha_val)
            end
        end

        # make directory
        dir_path = format("./datas/{:d}/", DEGREE)
        if !isdir(dir_path)
            mkdir(format("./datas/{:d}/", DEGREE))
        end

        # output csv
        path = format("./datas/{:d}/{:d}M_{:d}.txt", DEGREE, r / MASS, n)
        write_text(path, b_list, alpha_list)

        # plot
        plot_disk_image(plt, b_list, alpha_list, :green)
    end
end


init()
main()
output()
