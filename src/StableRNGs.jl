module StableRNGs

export StableRNG

import Random: Random, AbstractRNG, Sampler, SamplerType,
               rand, seed!

# Compat
if VERSION < v"1.2.0-"
    using Base: has_offset_axes
    require_one_based_indexing(A...) = !has_offset_axes(A...) || throw(ArgumentError("offset arrays are not supported but got an array with index other than 1"))
else
    using Base: require_one_based_indexing
end

# implementation of LehmerRNG based on the constants found at the
# MIT licensed code by Melissa E. O'Neill at
# https://gist.github.com/imneme/aeae7628565f15fb3fef54be8533e39c

"""
    LehmerRNG
    StableRNG

Simple RNG with stable streams, usually suitable for testing.
Use only the alias `StableRNG`, as the name `LehmerRNG` is not
part of the API.

Construction: `StableRNG(seed::Integer)`.

Seeding: `Random.seed!(rng::StableRNG, seed::Integer)`.
"""
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
    seed <= typemax(UInt64) ||
        # this constraint could be loosened a bit if requested
        throw(ArgumentError("seed must be <= $(typemax(UInt64))"))

    seed = ((seed % UInt128) << 1) | one(UInt128) # must be odd
    rng.state = seed
    rng
end

Base.show(io::IO, rng::LehmerRNG) =
    print(io, LehmerRNG, "(state=0x", string(rng.state, base=16, pad=32), ")")

function Base.copy!(dst::LehmerRNG, src::LehmerRNG)
    dst.state = src.state
    dst
end

Base.copy(src::LehmerRNG) = LehmerRNG(state=src.state)

Base.:(==)(x::LehmerRNG, y::LehmerRNG) = x.state == y.state

Base.hash(rng::LehmerRNG, h::UInt) = hash(rng.state, 0x93f376feff2bc48e % UInt ⊻ h)


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

# https://github.com/JuliaRandom/StableRNGs.jl/issues/10
Random.shuffle(r::StableRNG, a::AbstractArray) = Random.shuffle!(r, Base.copymutable(a))
# Fix method ambiguity issue: https://github.com/JuliaRandom/StableRNGs.jl/issues/23
Random.shuffle!(r::StableRNG, a::AbstractArray) = _shuffle!(r, a)
Random.shuffle!(r::StableRNG, a::AbstractArray{Bool}) = _shuffle!(r, a)
function _shuffle!(r::StableRNG, a::AbstractArray)
    require_one_based_indexing(a)
    n = length(a)
    n <= 1 && return a # nextpow below won't work with n == 0
    @assert n <= Int64(2)^52
    mask = nextpow(2, n) - 1
    for i = n:-1:2
        (mask >> 1) == i && (mask >>= 1)
        j = 1 + rand(r, ltm52(i, mask))
        a[i], a[j] = a[j], a[i]
    end
    return a
end

# copied from Random, from which this was deleted in https://github.com/JuliaLang/julia/pull/50509
"Return a sampler generating a random `Int` (masked with `mask`) in ``[0, n)``, when `n <= 2^52`."
ltm52(n::Int, mask::Int=nextpow(2, n)-1) = LessThan(n-1, Masked(mask, Random.UInt52Raw(Int)))


# https://github.com/JuliaRandom/StableRNGs.jl/issues/20
@noinline function Random.randn_unlikely(rng::StableRNG, idx, rabs, x)
    @inbounds if idx == 0
        while true
            xx = -Random.ziggurat_nor_inv_r*log(rand(rng))
            yy = -log(rand(rng))
            yy+yy > xx*xx &&
                return (rabs >> 8) % Bool ? -Random.ziggurat_nor_r-xx : Random.ziggurat_nor_r+xx
        end
    elseif (Random.fi[idx] - Random.fi[idx+1])*rand(rng) + Random.fi[idx+1] < exp(-0.5*x*x)
        return x # return from the triangular area
    else
        return randn(rng)
    end
end
@noinline function Random.randexp_unlikely(rng::StableRNG, idx, x)
    @inbounds if idx == 0
        return Random.ziggurat_exp_r - log(rand(rng))
    elseif (Random.fe[idx] - Random.fe[idx+1])*rand(rng) + Random.fe[idx+1] < exp(-x)
        return x # return from the triangular area
    else
        return Random.randexp(rng)
    end
end

end # module
