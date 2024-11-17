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
using DifferentialEquations

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

    n = 0
    r, E, L = 13.0, 1.00, 4.0


    function f!(du, u, p, t)
        du[1] = u[4]
        du[2] = u[5]
        du[3] = - 2 / u[1]^2 * 1 / (1 - 2/u[1]) * u[3] * u[4]
        du[4] = - 1 / u[1]^2 * (1 - 2/u[1]) * u[3]^2 + 1 / (u[1]^2 * (1 - 2/u[1])) * u[4]^2 + (1 - 2/u[1]) * u[1] * u[5]^2
        du[5] = - 2 / u[1] * u[4] * u[5]
    end

    dot_t = E / ( 1 - 2/r )
    dot_phi = L / r^2
    dot_r = sqrt(E^2 + 2 * L^2 / r^3 - L^2 / r^2 + 2 / r - 1)

    u0 = [r,  0.0, dot_t, 0.0, dot_phi] # r, phi, dot_t, dot_r, dot_phi
    tspan = (0.0, 500)
    dt = 0.1

    prob = ODEProblem(f!, u0, tspan, p=[])
    sol = solve(prob, Tsit5(), saveat=dt)

    b_list = []
    alpha_list = []
    for i in 1:100:length(sol)
        b_val, alpha_val = calc_disk_image(sol[i][1], sol[i][2], n)
        if !isnan(b_val)
            push!(b_list, b_val)
            push!(alpha_list, alpha_val)
            println("r: ", sol[i][1],  " phi: ", sol[i][2], " b: ", b_val, " alpha: ", alpha_val)
        end
    end

    # make directory
    dir_path = format("./datas/{:d}", DEGREE)
    if !isdir(dir_path)
        mkdir(format("./datas/{:d}", DEGREE))
    end

    # output csv
    path = format("./datas/r={:d},E={:d},L={:d},n={:d}", r, E, L, n)
    write_text(path, b_list, alpha_list)

    # plot
    plot_disk_image(plt, b_list, alpha_list, :green)
end


init()
main()
output()
