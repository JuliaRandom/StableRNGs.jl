using StableRNGs, Test
using Random

include("streams.jl")

@testset "initialization" begin
    @test StableRNG === LehmerRNG
    @test_throws MethodError LehmerRNG()
    rng = LehmerRNG(0)
    @test_throws MethodError Random.seed!(rng)
    @test_throws ArgumentError LehmerRNG(rand(typemin(Int):-1))
    @test_throws ArgumentError Random.seed!(rng, rand(typemin(Int):-1))

    for seed in Int64[0, 1, 2, 3, 4, typemax(Int32),
                      Int64(2)^32, typemax(Int64)]
        for T = (Int32, Int64)
            seed > typemax(T) && continue
            seed = T(seed)
            rng = LehmerRNG(seed)
            @test rng isa LehmerRNG
            @test isodd(rng.state)
            state = rng.state
            rng2 = Random.seed!(rng, seed)
            @test rng2 === rng
            @test isodd(rng.state)
            if !isempty(seed)
                @test rng.state == state
            end
        end
    end
end

gettype(::Type{T}) where {T} = T
gettype(::Type{Normal{T}}) where {T} = T
gettype(::Type{Exponential{T}}) where {T} = T

@testset "$T streams" for T = [Bool, Base.BitInteger_types...,
                               Float64, Normal{Float64}, Exponential{Float64},
                               Float32, Normal{Float32}, Exponential{Float32},
                               Float16, Normal{Float16}, Exponential{Float16}]
    streams = T <: Integer ? STREAMS[UInt64] : STREAMS[T]
    _rand = T <: Normal ? randn : T <: Exponential ? randexp : rand
    _rand! = T <: Normal ? randn! : T <: Exponential ? randexp! : rand!
    TT = gettype(T)
    for (seed, stream) in streams
        if T <: Integer
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
        @test _rand!(rng, a) == stream
        Random.seed!(rng, seed)
        @test [_rand(rng, TT) for _=1:n] == stream
    end
end
