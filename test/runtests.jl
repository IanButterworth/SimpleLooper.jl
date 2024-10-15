using Test
using SimpleLooper

@testset "SimpleLooper.jl" begin
    counter = 0
    @loop 3 counter += 1
    @test counter == 3

    counter = 0
    @loop counter < 5 counter += 1
    @test counter == 5

    # loops return nothing
    @test (@loop 1 1) === nothing

    # loops don't introduce new scope
    @test (@loop 3 x = 1) == 1
    @test @isdefined x

    # cannot test because we cannot interrupt the infinite loop
    # @loop counter += 1

    foo1() = @loop 1.0 counter += 1
    for _ in 1:2
        t = @elapsed foo1()
        @test t ≈ 1.0 atol=0.1
    end
    foo2() = @loop 0.5 counter += 1
    for _ in 1:2
        t = @elapsed foo2()
        @test t ≈ 0.5 atol=0.1
    end
end
