module StableRNGs

export LehmerRNG, StableRNG

using Random: Random, AbstractRNG, Sampler, SamplerType

import Random: rand, seed!


# implementation of LehmerRNG based on the constants found at the
# MIT licensed code by Melissa E. O'Neill at
# https://gist.github.com/imneme/aeae7628565f15fb3fef54be8533e39c

mutable struct LehmerRNG <: AbstractRNG
    state::UInt128

    LehmerRNG(seed::Integer) = seed!(new(), seed)

    function LehmerRNG(; state::UInt128)
        isodd(state) || throw(ArgumentError("state must be odd"))
        new(state)
    end
end

const StableRNG = LehmerRNG

function seed!(rng::LehmerRNG, seed::Integer)
    seed >= 0 || throw(ArgumentError("seed must be non-negative"))
    seed <= typemax(Int64) ||
        # this constraint could be loosened a bit if requested
        throw(ArgumentError("seed must be <= $(typemax(Int64))"))

    seed = ((seed % UInt128) << 1) | one(UInt128) # must be odd
    rng.state = seed
    rng
end

Base.show(io::IO, rng::LehmerRNG) =
    print(io, "LehmerRNG(state=0x$(string(rng.state, base=16, pad=32)))")


## Sampling

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

Random.rng_native_52(::LehmerRNG) = UInt64


## within a range

# adapted verion of Random.SamplerRangeFast for native 64 bits generation
# we don't use "near division-less algorithm", as it doesn't work for Int128,
# and we want to maintain as little code as possible here

using Base: BitUnsigned, BitInteger
using Random: LessThan, Masked, uniform

struct SamplerRangeFast{U<:BitUnsigned,T<:BitInteger} <: Sampler{T}
    a::T      # first element of the range
    bw::UInt  # bit width
    m::U      # range length - 1
    mask::U   # mask generated values before threshold rejection
end

SamplerRangeFast(r::AbstractUnitRange{T}) where T<:BitInteger =
    SamplerRangeFast(r, T <: Base.BitInteger64 ? UInt64 : UInt128)

function SamplerRangeFast(r::AbstractUnitRange{T}, ::Type{U}) where {T,U}
    isempty(r) && throw(ArgumentError("range must be non-empty"))
    m = (last(r) - first(r)) % unsigned(T) % U
    #                        ^--- % unsigned(T) to not propagate sign bit
    bw = (sizeof(U) << 3 - leading_zeros(m)) % UInt # bit-width
    mask = ((1 % U) << bw) - (1 % U)
    SamplerRangeFast{U,T}(first(r), bw, m, mask)
end

function rand(rng::LehmerRNG, sp::SamplerRangeFast{UInt64,T}) where T
    a, bw, m, mask = sp.a, sp.bw, sp.m, sp.mask
    x = rand(rng, LessThan(m, Masked(mask, uniform(UInt64))))
    (x + a % UInt64) % T
end

function rand(rng::LehmerRNG, sp::SamplerRangeFast{UInt128,T}) where T
    a, bw, m, mask = sp.a, sp.bw, sp.m, sp.mask
    x = bw <= 64  ?
        rand(rng,
             LessThan(m % UInt64,
                      Masked(mask % UInt64, uniform(UInt64)))) % UInt128 :
        rand(rng, LessThan(m, Masked(mask, uniform(UInt128))))
    x % T + a
end

for T in Base.BitInteger_types
    # eval because of ambiguities with `where T <: BitInteger`
    @eval Sampler(::Type{LehmerRNG}, r::AbstractUnitRange{$T}, ::Random.Repetition) =
        SamplerRangeFast(r)
end


end # module
