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
            @label start_1
            Core.donotdelete($(esc(first(exs))))
            @goto start_1
            nothing
        end
    elseif length(exs) == 2
        terms = first(exs)
        ex = last(exs)
        if terms isa Expr || terms isa Bool
            quote
                @label start_2
                Core.donotdelete($(esc(ex)))
                $(esc(terms)) && @goto start_2
                nothing
            end
        elseif terms isa Integer
            quote
                local i = 0
                @label start_3
                Core.donotdelete($(esc(ex)))
                i += 1
                i < $(esc(terms)) && @goto start_3
                nothing
            end
        elseif terms isa AbstractFloat
            quote
                local t_end = time() + $terms
                @label start_4
                    Core.donotdelete($(esc(ex)))
                time() < t_end && @goto start_4
                nothing
            end
        else
            throw(ArgumentError("@loop first argument must be an Integer (n loops), Float (seconds) or an expression that returns a boolean"))
        end
    else
        throw(ArgumentError("Too many arguments passed to @loop"))
    end
end

end
