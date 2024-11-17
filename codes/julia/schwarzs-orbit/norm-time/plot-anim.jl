include("consts.jl")
include("utils.jl")

# module
using .Consts: MASS
using .Utils: plot_orbit_gif, read_text

# library
using Formatting
using Plots

function output()
    dir_path = format("./gifs/{:d}/", DEG)
    if !isdir(dir_path)
        mkdir(dir_path)
    end
    gif(anim,  format("./gifs/{:d}/r={:d},E={:d},L={:d}.gif",DEG, r, E, L), fps=120)
end

DEG = 80
n_list = [0, 1]
r, E, L = 13.0, 1.00, 4.0

for i in 1:length(n_list)
    local path = format("./datas/{:d}/r={:d},E={:d},L={:d},n={:d}.txt",DEG, r, E, L, n_list[i])
    local b_list, alpha_list = read_text(path)
    if n_list[i] % 2 == 0
        global anim = plot_orbit_gif(b_list, alpha_list, false)
    # else
    #     global anim = plot_orbit_gif(b_list, alpha_list, true)
    end
end

output()
