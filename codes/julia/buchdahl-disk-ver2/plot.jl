using Plots
using Revise: includet
using Format

includet("./methods.jl")
includet("./constants.jl")
using .Methods: read_txt
using .Constants: A, DEGREE


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

plt = plot(
    xlim=(-25, 25), ylim=(-25, 25),
    legend=false,  #grid=false, framestyle=:none,
    ratio=1, dpi=1600,
)

equator_count = 0
a_list, b_list = read_txt(format("./data/{:.1f}/{:d}-{:d}.txt", A, DEGREE, equator_count))
plt = plot_closed_curve(plt, a_list, b_list, equator_count, "red")

equator_count = 1
a_list, b_list = read_txt(format("./data/{:.1f}/{:d}-{:d}-00.txt", A, DEGREE, equator_count))
plt = plot_closed_curve(plt, a_list, b_list, equator_count, "blue")
a_list, b_list = read_txt(format("./data/{:.1f}/{:d}-{:d}-01.txt", A, DEGREE, equator_count))
plt = plot_closed_curve(plt, a_list, b_list, equator_count, "blue")

# equator_count = 2
# a_list, b_list = read_txt(format("./data/{:.1f}/{:d}-{:d}-00.txt", A, DEGREE, equator_count))
# plt = plot_closed_curve(plt, a_list, b_list, equator_count, "green")
# a_list, b_list = read_txt(format("./data/{:.1f}/{:d}-{:d}-01.txt", A, DEGREE, equator_count))
# plt = plot_closed_curve(plt, a_list, b_list, equator_count, "green")

savefig(plt, format("./images/{:.1f}-{:d}.png", A, DEGREE))