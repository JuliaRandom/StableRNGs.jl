# StableRNGs

This package intends to provide a simple RNG with _stable_ streams, suitable
for tests in packages which need reproducible streams of random numbers
across Julia versions. Indeed, the RNGs provided by default are documented
to have non-stable streams (which for example enables some performance
improvements).

The `StableRNG` type provided by this package strives
for stability, but if bugs are found which require breaking this promise,
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
