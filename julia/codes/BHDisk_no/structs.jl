module Struct

struct DiskParticle
    r::Float64
    phi::Float64
end

struct ImageParticle
    b::Float64
    alpha::Float64
end

export DiskParticle, ImageParticle

end
