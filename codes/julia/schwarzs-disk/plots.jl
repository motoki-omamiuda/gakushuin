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
        xlim=(-35, 35), ylim=(-35, 35),
        legend=false,
        ratio=1, # アスペクト比を指定
        dpi=400, # 解像度を指定
        # grid=false,
        # framestyle=:none, # 軸を消す
    )
    # theta = range(0, stop=2*pi, length=100)
    # for (i, j) in zip([2, 3 * sqrt(3)], [0.6, 0.3])
    #     plot!(plt, i .* MASS .* cos.(theta), i .* MASS .* sin.(theta), linewidth=0, fillcolor=:black, fillalpha=j, fillrange=0)
    # end
end


function output()
    savefig(plt, format("./images/{:d}-disk.png", DEG))
end

DEG =  80

n_list = [0, 1]
# r_list = [2, 6, 10, 20, 30].* MASS
r_list = [6, 10, 20, 30].* MASS

color_list = [
    ["red", "red", "red", "red", "red"], # 赤系
    ["blue", "blue", "blue", "blue", "blue"], # 青系
    ["#0000cd", "#4169e1", "#4682b4", "#2e8b57", "#006400"], # 緑系
    ["#a0522d", "#8b4513", "#800000", "#8b0000", "#a52a2a"], # 茶系
    ["#ffa500", "#f4a460", "#ff8c00", "#daa520", "#cd853f"], # オレンジ系
    ["#800000", "#a52a2a", "#cd5c5c", "#dc143c", "#ff4500"], # 赤系
]

init()
for i in 1:length(n_list)
    for j in 1:length(r_list)
        path = format("./datas/{:d}/{:d}M_{:d}.txt", DEG, r_list[j] / MASS, n_list[i])
        b_list, alpha_list = read_text(path)
        if n_list[i] % 2 == 0
            plot_disk_image(plt, b_list, alpha_list, color_list[i][j], false)
        else
            plot_disk_image(plt, b_list, alpha_list, color_list[i][j], true)
        end
    end
end

# DEG =  60

# n_list = [0, 1, 2]
# r_list = [20].* MASS

# color_list = ["red", "blue", "black"]

# init()
# for i in 1:length(n_list)
#     for j in 1:length(r_list)
#         path = format("./datas/{:d}/{:d}M_{:d}.txt", DEG, r_list[j] / MASS, n_list[i])
#         b_list, alpha_list = read_text(path)
#         if n_list[i] % 2 == 0
#             plot_disk_image(plt, b_list, alpha_list, color_list[i], false)
#         else
#             plot_disk_image(plt, b_list, alpha_list, color_list[i], true)
#         end
#     end
# end

output()
