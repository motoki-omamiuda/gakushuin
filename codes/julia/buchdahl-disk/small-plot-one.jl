using Plots
using Format

function read_txt_first(path)
    """
    read x and y list from txt file
    """
    lines = readlines(path)
    x_list = []
    y_list = []
    for line in lines
        push!(x_list, parse(Float64, split(strip(line), ",")[1]))
        push!(y_list, parse(Float64, split(strip(line), ",")[2]))
    end
    print(x_list, "\n")
    print(y_list, "\n")
    return x_list, y_list
end

function read_txt_last(path)
    """
    read x and y list from txt file
    """
    lines = readlines(path)
    x_list = []
    y_list = []
    for line in lines
        push!(x_list, parse(Float64, split(strip(line), ",")[1]))
        push!(y_list, parse(Float64, split(strip(line), ",")[end]))
    end
    print(x_list, "\n")
    print(y_list, "\n")
    return x_list, y_list
end


function plot_closed_curve(plt, a_list, b_list, equator_count, color)
    x_list = []
    y_list = []
    for (b_val, a_val) in zip(b_list, a_list)
        if equator_count%2 == 0
            push!(x_list, - b_val * sin(a_val))
            push!(y_list, - b_val * cos(a_val))
        else
            push!(x_list, - b_val * sin(a_val))
            push!(y_list, b_val * cos(a_val))
        end
    end
    plot!(plt, x_list, y_list, color=color)

    x_list = []
    y_list = []
    for (b_val, a_val) in zip(b_list, a_list)
        if equator_count%2 == 0
            push!(x_list, b_val * sin(a_val))
            push!(y_list, - b_val * cos(a_val))
        else
            push!(x_list, b_val * sin(a_val))
            push!(y_list, b_val * cos(a_val))
        end
    end
    plot!(plt, x_list, y_list, color=color)

    plot!(plt, [x_list[end], -x_list[end]], [y_list[end], y_list[end]], y_list, color=color)
    return plt
end

function plot_curve(plt, a_list, b_list, equator_count, color)
    x_list = []
    y_list = []
    for (b_val, a_val) in zip(b_list, a_list)
        if equator_count%2 == 0
            push!(x_list, - b_val * sin(a_val))
            push!(y_list, - b_val * cos(a_val))
        else
            push!(x_list, - b_val * sin(a_val))
            push!(y_list, b_val * cos(a_val))
        end
    end
    plot!(plt, x_list, y_list, color=color)

    x_list = []
    y_list = []
    for (b_val, a_val) in zip(b_list, a_list)
        if equator_count%2 == 0
            push!(x_list, b_val * sin(a_val))
            push!(y_list, - b_val * cos(a_val))
        else
            push!(x_list, b_val * sin(a_val))
            push!(y_list, b_val * cos(a_val))
        end
    end
    plot!(plt, x_list, y_list, color=color)
    return plt
end

plt = plot(
    xlim=(-7, 7), ylim=(-7, 7),
    legend=false,  #grid=false, framestyle=:none,
    ratio=1, dpi=1600,
)

# initialize
deg = 80
a_val = 1.5

# color = "#191970" #2
# equator_count = 2

# color = "#000080"  #3
# equator_count = 3

# color = "#00008b" # 4
# equator_count = 4

# color = "#008b8b" # 5
# equator_count = 5

# color = "#2f4f4f" # 6
# equator_count = 6


# a_list, b_list = read_txt_first(format("./{:d}-data/{:.1f}/{:d}-{:d}.txt", deg, a_val, deg, equator_count))
# plt = plot_closed_curve(plt, a_list, b_list, equator_count, color)
# a_list, b_list = read_txt_last(format("./{:d}-data/{:.1f}/{:d}-{:d}.txt", deg, a_val, deg, equator_count))
# plt = plot_closed_curve(plt, a_list, b_list, equator_count, color)

# a_list, b_list = read_txt_first(format("./{:d}-data/{:.1f}/{:d}-{:d}.txt", deg, a_val, deg, equator_count))
# plt = plot_curve(plt, a_list, b_list, equator_count, color)
# a_list, b_list = read_txt_last(format("./{:d}-data/{:.1f}/{:d}-{:d}.txt", deg, a_val, deg, equator_count))
# plt = plot_curve(plt, a_list, b_list, equator_count, color)

# savefig(plt, format("./{:d}-image/small-{:.1f}-{:d}-{:d}.png", deg, a_val, deg, equator_count))

style_list = [
    (2, "#191970"),
    (3, "#000080"),
    (4, "#00008b"),
    (5, "#008b8b"),
    (6, "#2f4f4f")
]
last_num = 6
for (i, color) in style_list
    if i < last_num
        a_list, b_list = read_txt_first(format("./{:d}-data/{:.1f}/{:d}-{:d}.txt", deg, a_val, deg, i))
        plot_closed_curve(plt, a_list, b_list, i, color)
        a_list, b_list = read_txt_last(format("./{:d}-data/{:.1f}/{:d}-{:d}.txt", deg, a_val, deg, i))
        plot_closed_curve(plt, a_list, b_list, i, color)
    end
    if i == last_num
        a_list, b_list = read_txt_first(format("./{:d}-data/{:.1f}/{:d}-{:d}.txt", deg, a_val, deg, i))
        plot_curve(plt, a_list, b_list, i, color)
        a_list, b_list = read_txt_last(format("./{:d}-data/{:.1f}/{:d}-{:d}.txt", deg, a_val, deg, i))
        plot_curve(plt, a_list, b_list, i, color)
    end
end

savefig(plt, format("./{:d}-image/small-{:.1f}-{:d}-all.png", deg, a_val, deg))
