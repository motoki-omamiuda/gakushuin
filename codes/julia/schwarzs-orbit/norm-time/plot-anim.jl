include("consts.jl")
include("utils.jl")

# module
using .Consts: MASS
using .Utils: plot_orbit_gif

# library
using Formatting
using Plots

function output()
    dir_path = format("./gifs/{:d}/", DEG)
    if !isdir(dir_path)
        mkdir(dir_path)
    end
    gif(anim,  format("./gifs/{:d}/r={:.2f},E={:.2f},L={:.2f}.gif", DEG, r, E, L), fps=120)
end

DEG = 80
# r, E, L = 12.0, 0.964, 4.0
r, E, L = 200.0, 1.1, 4.0

global anim = plot_orbit_gif(DEG, r, E, L)
output()
