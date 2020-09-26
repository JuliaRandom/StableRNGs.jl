using StableRNGs
using StableRNGs: LehmerRNG
using Test
using Random

include("streams.jl")

@testset "initialization" begin
    @test StableRNG === LehmerRNG
    @test_throws UndefKeywordError LehmerRNG()
    rng = LehmerRNG(0)
    @test_throws MethodError Random.seed!(rng)
    @test_throws ArgumentError LehmerRNG(rand(typemin(Int):-1))
    @test_throws ArgumentError Random.seed!(rng, rand(typemin(Int):-1))
    @test_throws ArgumentError Random.seed!(rng, big(typemax(UInt64))+1)

    for seed in UInt64[0, 1, 2, 3, 4, typemax(Int32),
                      Int64(2)^32, typemax(Int64), typemax(UInt64)]
        for T = (Int8, UInt8, Int32, Int64, UInt, Int128, BigInt)
            Base.hastypemax(T) && seed > typemax(T) && continue
            seed = T(seed)
            rng = LehmerRNG(seed)
            @test rng isa LehmerRNG
            @test isodd(rng.state)
            state = rng.state
            rng2 = Random.seed!(rng, seed)
            @test rng2 === rng
            @test isodd(rng.state)
            @test rng.state == state
        end
    end

    # state
    rng = LehmerRNG(0)
    @test rng.state == 1
    @test string(rng) == "LehmerRNG(state=0x00000000000000000000000000000001)"
    @test LehmerRNG(state=0x00000000000000000000000000000001).state == 1
    # @test LehmerRNG(state=0x00000000000000000000000000000001) == rng
    @test_throws ArgumentError LehmerRNG(state=2*UInt128(rand(1:9999)))

    # copy / == / hash
    seed = rand(UInt)
    Random.seed!(rng, seed)
    c = copy(rng)
    @test c.state == rng.state
    @test c !== rng
    @test c == rng
    @test hash(c) == hash(rng)
    @test hash(c, UInt(123)) == hash(rng, UInt(123))
    rand(rng)
    @test c != rng
    @test hash(c) != hash(rng) # should almost always be true
    c = copy(rng)
    @test c.state == rng.state
    @test c !== rng
    @test c == rng
end

getsampler(::Type{T}) where {T} = T
getsampler(::Type{Normal{T}}) where {T} = T
getsampler(::Type{Exponential{T}}) where {T} = T
getsampler(x::UnitRange) = x

@testset "$T streams" for T =
    [Bool, Base.BitInteger_types...,
     [map(t, 1:123) for t in Base.BitInteger_types]...,
     1:Int128(2)^100, 1:UInt128(2)^100, false:true,
     Float64, Normal{Float64}, Exponential{Float64},
     Float32, Normal{Float32}, Exponential{Float32},
     Float16, Normal{Float16}, Exponential{Float16}]

    streams = T isa DataType && T <: Integer ? STREAMS[UInt64] :
        T isa UnitRange ? STREAMS[last(T)] : STREAMS[T]

    _rand, _rand! =
        if T isa DataType && T <: Normal
            randn, randn!
        elseif T isa DataType && T <: Exponential
            randexp, randexp!
        else
           rand, rand!
        end
    TT = getsampler(T)

    for (seed, stream) in streams
        if T isa DataType && T <: Integer
            if sizeof(T) == 16
                stream = reinterpret(T, stream)
            else
                stream = stream .% T
            end
        end
        rng = StableRNG(seed)
        n = length(stream)
        a = _rand(rng, TT, n)
        @test a == stream
        Random.seed!(rng, seed)
        @test _rand(rng, TT, n) == stream
        Random.seed!(rng, seed)
        if TT isa DataType
            @test _rand!(rng, a) == stream
        else
            @test _rand!(rng, a, TT) == stream
        end
        Random.seed!(rng, seed)
        @test [_rand(rng, TT) for _=1:n] == stream
    end
end

@testset "rand in range" begin
    rng = LehmerRNG(0)
    @test_throws ArgumentError rand(rng, 1:0)
    for T in Base.BitInteger_types
        sp = Random.Sampler(LehmerRNG, T(1):T(1))
        @test sp isa StableRNGs.SamplerRangeFast
    end
    for n in Int128[rand(1:128, 100); rand(1:Int64(2)^32, 100); Int64(2)^32;
                    rand(1:typemax(Int64), 100); rand(1:Int128(2)^64, 100);
                    Int128(2)^64; rand(1:typemax(Int128), 100)]
        for T in Base.BitInteger_types
            n < typemax(T) || continue
            n = T(n)
            @test all(∈(1:n), rand(rng, T(1):n, 100))
            if n >= 4
                @test all(∈(4:n), rand(rng, T(4):n, 100))
            end
            if T <: Signed
                @test all(∈(-100:n), rand(rng, T(-100):n, 100))
            end
        end
    end
end
