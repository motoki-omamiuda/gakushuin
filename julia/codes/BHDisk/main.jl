include("./structs.jl")
include("./functions.jl")
include("./constants.jl")

# module
import Main.Struct
import Main.Function
import Main.Constant

# library
import Elliptic
import Elliptic.Jacobi

using Roots
using Printf
using Plots

# initialize
SITA = Constant.SITE
MASS = Constant.MASS

function caluculate_disk_image(disk_partial)
    """
    光を発する降着円盤における微小粒子が写真板に写す像の位置を計算する
    """
    # P の計算
    tmp_gamma = Function.gamma(disk_partial.phi)
    @printf("Gamma:\t%.3f\n", tmp_gamma)

    f(P) = (
        (Function.Q(P) - P + 6 * MASS) / (4 * MASS * P) * Elliptic.Jacobi.sn(
            tmp_gamma * sqrt(Function.Q(P) / P) / 2 + Elliptic.F(Function.zeta(P), Function.k(P) ^ 2), Function.k(P) ^ 2
        ) ^ 2
        - (Function.Q(P) - P + 2 * MASS) / (4 * MASS * P)
        - 1 / disk.r
    )

    # P = find_zero(f, (2.0, 10.0))
    P = find_zero(f, (-100000, 100000))
    @printf("P:\t%.3f\n", P)
    return Struct.ImageParticle(Function.b(P), Function.alpha(disk_partial.phi))
end

polar_b = []
polar_alpha = []

for phi in 0:0.01:2*pi
    local disk_partial = Struct.DiskParticle(5 * MASS, phi)
    local image_partial = caluculate_disk_image(disk_partial)

    push!(polar_b, image_partial.b)
    push!(polar_alpha, image_partial.alpha)
    @printf("b:\t%.3f \talpha:\t%.3f\n", image_partial.b, image_partial.alpha)
    # println(image_partial.b, " ", image_partial.alpha)
end

x = [ b * cos(alpha)  for (b, alpha) in (polar_b, polar_alpha) ]
y = [ b * sin(alpha)  for (b, alpha) in (polar_b, polar_alpha) ]
plot(x, y)