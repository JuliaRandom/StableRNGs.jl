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

@testset "$T streams" for T = [Bool, Base.BitInteger_types...,
                               Float64]
    streams = T <: Integer ? STREAMS[UInt64] : STREAMS[T]
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
        a = rand(rng, T, n)
        @test a == stream
        Random.seed!(rng, seed)
        @test rand(rng, T, n) == stream
        Random.seed!(rng, seed)
        @test rand!(rng, a) == stream
        Random.seed!(rng, seed)
        @test [rand(rng, T) for _=1:n] == stream
    end
end
