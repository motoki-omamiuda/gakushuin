include("consts.jl")
include("utils.jl")

# module
using .Consts: MASS
using .Utils: plot_orbit_image, read_text

# library
using Formatting
using Plots


function init()
    global plt = plot(
        xlim=(-35, 35), ylim=(-35, 35),
        legend=false,
        ratio=1, # アスペクト比を指定
        dpi=1600, # 解像度を指定
        # grid=false,
        # framestyle=:none, # 軸を消す
    )
    theta = range(0, stop=2*pi, length=100)
    for (i, j) in zip([2, 3 * sqrt(3)], [0.6, 0.3])
        plot!(plt, i .* MASS .* cos.(theta), i .* MASS .* sin.(theta), linewidth=0, fillcolor=:black, fillalpha=j, fillrange=0)
    end
end


function output()
    dir_path = format("./images/{:d}/", DEG)
    if !isdir(dir_path)
        mkdir(dir_path)
    end
    savefig(plt, format("./images/{:d}/r={:d},E={:d},L={:d}.png",DEG, r, E, L))
end

DEG = 80
n_list = [0, 1]
r, E, L = 13.0, 1.00, 4.0

init()
for i in 1:length(n_list)
    local path = format("./datas/{:d}/r={:d},E={:d},L={:d},n={:d}.txt",DEG, r, E, L, n_list[i])
    local b_list, alpha_list = read_text(path)
    if n_list[i] % 2 == 0
        plot_orbit_image(plt, b_list[1:1500], alpha_list[1:1500], false)
    else
        plot_orbit_image(plt, b_list[1:1500], alpha_list[1:1500], true)
    end
end

output()
