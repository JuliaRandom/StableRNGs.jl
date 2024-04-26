# StableRNGs

[![CI](https://github.com/JuliaRandom/StableRNGs.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/JuliaRandom/StableRNGs.jl/actions/workflows/CI.yml)
[![PkgEval](https://juliaci.github.io/NanosoldierReports/pkgeval_badges/S/StableRNGs.svg)](https://juliaci.github.io/NanosoldierReports/pkgeval_badges/report.html)

This package intends to provide a simple RNG with _stable_ streams, suitable
for tests in packages which need reproducible streams of random numbers
across Julia versions. Indeed, the Julia RNGs provided by default are
[documented](https://docs.julialang.org/en/v1.4/stdlib/Random/#Reproducibility-1)
to have non-stable streams (which for example enables some performance
improvements).

The `StableRNG` type provided by this package strives
for stability, but if bugs which require breaking this promise are found,
a new major version will be released with the fix.

`StableRNG` is currently an alias for `LehmerRNG`, and implements a well understood
linear congruential generator (LCG); an LCG is not state of the art,
but is fast and is believed to have reasonably good statistical properties [1],
suitable at least for tests of a wide range of packages.
The choice of this particular RNG is based on its simplicity, which limits
the chances for bugs.
Note that only `StableRNG` is exported from the package, and should be the only
type used in client code; `LehmerRNG` might be renamed, or might be made a distinct
type from `StableRNG` in any upcoming _minor_ (i.e. non-breaking) release.

Currently, this RNG requires explicit seeding (in the constructor
or via `Random.seed!`), i.e. no random seed will be chosen for the user
as is the case in e.g. `MersenneTwister()`.

The stable (guaranteed) API is
* construction: `rng = StableRNG(seed::Integer)` (in particular the alias
  `LehmerRNG` is currently _not_ part of the API)
* seeding: `Random.seed!(rng::StableRNG, seed::Integer)`
  (with `0 <= seed <= typemax(UInt64)`)
* `rand(rng, X)` where `X` is any of the standard bit `Integer` types
  (`Bool`, `Int8`, `Int16`, `Int32`, `Int64`, `Int128`,
  `UInt8`, `UInt16`, `UInt32`, `UInt64`, `UInt128`)
* `rand(rng, X)`, `randn(rng, X)`, `randexp(rng, X)` where `X` is a standard
  bit `AbstractFloat` types (`Float16`, `Float32`, `Float64`)
* array versions for these types, including
  the mutating methods `rand!`, `randn!` and `randexp!`
* `rand(rng, ::AbstractArray)` (e.g. `rand(rng, 1:9)`); the streams are the same
  on 32-bits and 64-bits architectures
* `shuffle(rng, ::AbstractArray)` and `shuffle!(rng, ::AbstractArray)`

Note that the generated streams of numbers for scalars and arrays are the same,
i.e. `rand(rng, X, n)` is equal to `[rand(rng, X) for _=1:n]` for a given `rng`
state.

Please open an issue for missing needed APIs.

[1] `LehmerRNG` is implemented after the specific constants published by
Melissa E. O'Neill in this
[C++ implementation](https://gist.github.com/imneme/aeae7628565f15fb3fef54be8533e39c),
and passes the Big Crush test (thanks to Kristoffer Carlsson for running it).
See also for example this
[blog post](https://lemire.me/blog/2019/03/19/the-fastest-conventional-random-number-generator-that-can-pass-big-crush/).

## Usage

In your tests, simply initialize an RNG with a given seed, and use
it instead of the default provided one, e.g.

```julia
rng = StableRNG(123)
A = randn(rng, 10, 10) # instead of randn(10, 10)
@test inv(inv(A)) ≈ A
```
