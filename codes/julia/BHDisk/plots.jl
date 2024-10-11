# module
using .Consts: MASS
using .Utils: plot_disk_image, read_csv

# library
using Formatting
using Plots


DEG = 89
n = 0
r_list = [2, 6, 10, 20, 30].* MASS

init()

for i in 1:length(r_list)
    #path = format("./datas/{:d}/{:d}M_{:d}.csv", DEG, r_list[i] / MASS, n)
    path = format("./datas/{:d}M_{:d}.txt", r_list[i] / MASS, n)
    b_list, alpha_list = read_csv(path)
    plot_disk_image(plt, b_list, alpha_list, :red, false)
end

output()

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
