include("./consts.jl")
include("./equas.jl")
include("./utils.jl")

# module
using .Consts: MASS, DEGREE
using .Utils: calc_partial_image, write_text
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


function main(n)
    # r, E, L = 12.0, 0.964, 4.0
    r, E, L = 200.0, 1.1, 4.0

    function f!(du, u, p, t)
        du[1] = u[4]
        du[2] = u[5]
        du[3] = u[6]
        du[4] = - 2 / u[2]^2 * 1 / (1 - 2/u[2]) * u[4] * u[5]
        du[5] = - 1 / u[2]^2 * (1 - 2/u[2]) * u[4]^2 + 1 / (u[2]^2 * (1 - 2/u[2])) * u[5]^2 + (1 - 2/u[2]) * u[2] * u[6]^2
        du[6] = - 2 / u[2] * u[5] * u[6]
    end

    dot_t = E / ( 1 - 2/r )
    dot_phi = L / r^2
    dot_r = - sqrt(E^2 + 2 * L^2 / r^3 - L^2 / r^2 + 2 / r - 1)

    u0 = [0.0, r,  0.0, dot_t, dot_r, dot_phi] # t, r, phi, dot_t, dot_r, dot_phi
    tspan = (0.0, 600)
    dt = 0.1

    prob = ODEProblem(f!, u0, tspan, p=[])
    sol = solve(prob, Tsit5(), saveat=dt)

    b_list = []
    alpha_list = []
    for i in 1:10:length(sol)
        b_val, alpha_val = calc_partial_image(sol[i][2], sol[i][3], n)
        if !isnan(b_val)
            push!(b_list, b_val)
            push!(alpha_list, alpha_val)
            println("r: ", sol[i][2],  " phi: ", sol[i][3], " b: ", b_val, " alpha: ", alpha_val)
        end
    end

    # output csv
    path = format("./datas/r={:.2f},E={:.2f},L={:.2f},n={:.2f}", r, E, L, n)
    write_text(path, b_list, alpha_list)

end

# n=0, n=1 を実行
main(0)
main(1)
