# SimpleLooper.jl

[![Build Status](https://github.com/IanButterworth/SimpleLooper.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/IanButterworth/SimpleLooper.jl/actions/workflows/CI.yml?query=branch%3Amain)

A simple looper.

```julia
@loop call
@loop n call
@loop bool_expr call
@loop 1.0 call
```

Repeat `call` indefinitely until interrupt or `n` times and discard the output.
If an expression is given as a first argument it must return a `Bool` and
repeats will occur until `false`. If a float is given the loop will run for that
many seconds.

```julia-repl
julia> @loop println("Hello, World!")
Hello, World!
Hello, World!^C
ERROR: InterruptException:
...

julia> @loop 2 println("Hello, World!")
Hello, World!
Hello, World!

julia> @loop rand() > 0.5 println("Hello, World!")
Hello, World!

julia> @elapsed @loop 1.0 1 * 1
1.000003416
```

Useful in the repl for things like:

```julia-repl
julia> @time @loop 100000000 rand()
  0.095913 seconds

julia> @profile @loop 2.0 foo()

julia> @profile @loop 10000 foo()
```
