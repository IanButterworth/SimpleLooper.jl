module SimpleLooper

export @loop

"""
    @loop call
    @loop n call
    @loop bool_expr call

Repeat `call` indefinitely until interrupt or `n` times and discard the output.
If an expression is given as a first argument it must return a `Bool` and
repeats will occur until `false`.

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
```

"""
macro loop(exs...)
    if length(exs) == 1
        quote
            while true
                Core.donotdelete($(esc(first(exs))))
            end
        end
    elseif length(exs) == 2
        terms = first(exs)
        ex = last(exs)
        if terms isa Expr || terms isa Bool
            quote
                while $(esc(terms))
                    Core.donotdelete($(esc(ex)))
                end
            end
        elseif terms isa Integer
            quote
                for _ = 1:$(esc(terms))
                    Core.donotdelete($(esc(ex)))
                end
            end
        elseif terms isa AbstractFloat
            quote
                local t_end = time() + $terms
                while time() < t_end
                    Core.donotdelete($(esc(ex)))
                end
            end
        else
            throw(ArgumentError("@loop first argument must be an Integer (n loops), Float (seconds) or an expression that returns a boolean"))
        end
    else
        throw(ArgumentError("Too many arguments passed to @loop"))
    end
end

end
