using Plots
using Revise: includet
using Format

includet("./methods.jl")
includet("./constants.jl")
using .Methods: read_txt
using .Constants: A, DEGREE


function plot_closed_curve(plt, a_list, b_list, equator_count)
    x_list = []
    y_list = []
    for (b_val, a_val) in zip(b_list, a_list)
        if equator_count%2 == 0
            push!(x_list, - b_val * sin(a_val))
            push!(y_list, - b_val * cos(a_val))

            push!(x_list, b_val * sin(a_val))
            push!(y_list, - b_val * cos(a_val))
        else
            push!(x_list, - b_val * sin(a_val))
            push!(y_list, b_val * cos(a_val))

            push!(x_list, b_val * sin(a_val))
            push!(y_list, b_val * cos(a_val))
        end
    end
    scatter!(plt, x_list, y_list, color=:black, markersize=0.8)
    return plt
end

plt = plot(
    xlim=(-35, 35), ylim=(-35, 35),
    legend=false,  #grid=false, framestyle=:none,
    ratio=1, dpi=1600,
)

# equator_count = 0
# a_list, b_list = read_txt(format("./datas/{:.1f}-{:d}-{:d}.txt", A, DEGREE, equator_count))
# plt = plot_closed_curve(plt, a_list, b_list, equator_count)

equator_count = 1
a_list, b_list = read_txt(format("./datas/{:.1f}-{:d}-{:d}-00.txt", A, DEGREE, equator_count))
plt = plot_closed_curve(plt, a_list, b_list, equator_count)

a_list, b_list = read_txt(format("./datas/{:.1f}-{:d}-{:d}-01.txt", A, DEGREE, equator_count))
plt = plot_closed_curve(plt, a_list, b_list, equator_count)


savefig(plt, format("./images/{:.1f}-{:d}.png", A, DEGREE))