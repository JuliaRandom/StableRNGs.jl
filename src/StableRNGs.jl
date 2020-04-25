module StableRNGs

export LehmerRNG, StableRNG

using Random: AbstractRNG, SamplerType

import Random: rand, seed!


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

function rand(rng::LehmerRNG, ::SamplerType{UInt64})
    rng.state *= 0x45a31efc5a35d971261fd0407a968add
    (rng.state >> 64) % UInt64
end

for T = [Bool, Base.BitInteger64_types...]
    T === UInt64 && continue
    @eval rand(rng::LehmerRNG, ::SamplerType{$T}) = rand(rng, UInt64) % $T
end

rand(rng::LehmerRNG, ::SamplerType{UInt128}) =
     rand(rng, UInt64) | ((rand(rng, UInt64) % UInt128) << 64)

rand(rng::LehmerRNG, ::SamplerType{Int128}) = rand(rng, UInt128) % Int128


end # module
