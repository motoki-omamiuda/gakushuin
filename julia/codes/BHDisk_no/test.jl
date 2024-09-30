using Optim

f(x) = (
    if x == 0
        return -1
    else 3 * x
        return abs( 3 * x )
    end
)


res = optimize(f, -10, 10)
P = Optim.minimizer(res)

println(P)