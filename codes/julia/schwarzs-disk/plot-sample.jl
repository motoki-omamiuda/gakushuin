include("consts.jl")
include("utils.jl")

# module
using .Consts: MASS
using .Utils: plot_disk_image, read_text

# library
using Format
using Plots


function init()
    global plt = plot(
        xlim=(-25, 25), ylim=(-25, 25),
        legend=false,
        ratio=1, # アスペクト比を指定
        dpi=400, # 解像度を指定
        # grid=false,
    )
    theta = range(0, stop=2*pi, length=100)
    plot!(plt,  3 .* sqrt(3) .* MASS .* cos.(theta),  3 .* sqrt(3) .* MASS .* sin.(theta), color="black")
    # for (i, j) in zip([2, 3 * sqrt(3)], [0.6, 0.3])
    #     plot!(plt, i .* MASS .* cos.(theta), i .* MASS .* sin.(theta))
    # end
end


function output()
    savefig(plt, format("./images/{:d}-one.png", DEG))
end

DEG =  80

n_list = [0, 1]
r_list = [20].* MASS

n_list = [0, 1]
r_list = [20].* MASS

color_list = ["red", "blue", "black"]

init()
for i in 1:length(n_list)
    for j in 1:length(r_list)
        path = format("./datas/{:d}/{:d}M_{:d}.txt", DEG, r_list[j] / MASS, n_list[i])
        b_list, alpha_list = read_text(path)
        if n_list[i] % 2 == 0
            plot_disk_image(plt, b_list, alpha_list, color_list[i], false)
        else
            plot_disk_image(plt, b_list, alpha_list, color_list[i], true)
        end
    end
end

output()
