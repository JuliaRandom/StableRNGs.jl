module StableRNGs

export LehmerRNG, StableRNG

using Random: AbstractRNG

import Random: seed!


# implementation of LehmerRNG based on the constants found at the
# MIT licensed code by Melissa E. O'Neill at
# https://gist.github.com/imneme/aeae7628565f15fb3fef54be8533e39c

mutable struct LehmerRNG <: AbstractRNG
    state::UInt128

    LehmerRNG(seed) = seed!(new(), seed)
end

const StableRNG = LehmerRNG

function seed!(rng::LehmerRNG, seed::Union{Int64,Int32})
    seed < 0 && throw(ArgumentError("seed must be non-negative"))
    seed = ((seed % UInt128) << 1) | one(UInt128) # must be odd
    rng.state = seed
    rng
end


end # module
