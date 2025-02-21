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
    xlim=(-35, 35), ylim=(-35, 35),
    legend=false,  grid=false, framestyle=:none,
    ratio=1,
    dpi=400,
)

# initialize
deg = 80
a_val = 1.5
r_list = [30, 20, 10, 6]
# r_list = [30, 20]

for r_val in r_list
    equator_count = 0
    a_list, b_list = read_txt_last(format("./{:d}-data/{:.1f}/{:d}-{:d}-{:d}.txt", deg, a_val, deg, equator_count, r_val))
    plot_closed_curve(plt, a_list, b_list, equator_count, "#FF0000")

    equator_count = 1
    a_list, b_list = read_txt_first(format("./{:d}-data/{:.1f}/{:d}-{:d}-{:d}.txt", deg, a_val, deg, equator_count, r_val))
    plot_closed_curve(plt, a_list, b_list, equator_count, "blue")
    a_list, b_list = read_txt_last(format("./{:d}-data/{:.1f}/{:d}-{:d}-{:d}.txt", deg, a_val, deg, equator_count, r_val))
    plot_closed_curve(plt, a_list, b_list, equator_count, "blue")
end

savefig(plt, format("./{:d}-image/{:.1f}-{:d}-disk.png", deg, a_val, deg))
