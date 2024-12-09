using Plots
using Revise: includet
using Format

includet("./methods.jl")
includet("./constants.jl")
using .Methods: read_txt
using .Constants: A, DEGREE

plt = plot(
    xlim=(-35, 35), ylim=(-35, 35),
    legend=false,  #grid=false, framestyle=:none,
    ratio=1, dpi=1600,
)

b_list, a_list = read_txt(format("./datas/{:.1f}-{:d}.txt", A, DEGREE))

x_list = []
y_list = []
for (b_val, a_val) in zip(b_list, a_list)
    push!(x_list, - b_val * sin(a_val))
    push!(y_list, - b_val * cos(a_val))

    push!(x_list, b_val * sin(a_val))
    push!(y_list, - b_val * cos(a_val))
end
scatter!(plt, x_list, y_list, color=:black)

savefig(plt, format("./images/{:.1f}-{:d}.png", A, DEGREE))