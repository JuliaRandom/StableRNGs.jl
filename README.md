# StableRNGs

[![Build Status](https://travis-ci.org/rfourquet/StableRNGs.jl.svg?branch=master)](https://travis-ci.org/rfourquet/StableRNGs.jl)

This package intends to provide a simple RNG with _stable_ streams, suitable
for tests in packages which need reproducible streams of random numbers
across Julia versions. Indeed, the RNGs provided by default are documented
to have non-stable streams (which for example enables some performance
improvements).

The `StableRNG` type provided by this package strives
for stability, but if bugs which require breaking this promise are found,
a new major version will be released with the fix.

`StableRNG` is an alias for `LehmerRNG`, and implements a well understood
linear congruential generator (LCG); an LCG is not state of the art,
but is fast and is believed to have reasonably good statistical properties,
suitable at least for tests of a wide range of packages.
The choice of this particular RNG is based on its simplicity, which limits
the chances for bugs.

Currently, this RNG requires explicit seeding (in the constructor
or via `Random.seed!`), i.e. no random seed will be chosen for the user
as is the case in e.g. `MersenneTwister()`.

The currently stable (guaranteed) API is
* `rand(rng, X)` where `X` is any of the standard bit `Integer` types
  (`Bool`, `Int8`, `Int16`, `Int32`, `Int64`, `Int128`,
  `UInt8`, `UInt16`, `UInt32`, `UInt64`, `UInt128`)
  or a `UnitRange` of these types
* `rand(rng, X)`, `randn(rng, X)`, `randexp(rng, X)` where `X` is a standard
  bit `AbstractFloat` types (`Float16`, `Float32`, `Float64`)

Please open an issue for missing needed APIs.

Also, as this package is currently not tested on 32-bits architectures,
no stability is guaranteed on them.

## Usage

In your tests, simply initialize an RNG with a given seed, and use
it instead of the default provided one, e.g.

```julia
rng = StableRNG(123)
A = randn(rng, 10, 10) # instead of randn(10, 10)
@test inv(inv(A)) ≈ A
```
