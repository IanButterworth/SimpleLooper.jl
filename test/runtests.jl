using Test
using SimpleLooper

@testset "SimpleLooper.jl" begin
    counter = 0
    @loop 3 counter += 1
    @test counter == 3

    counter = 0
    @loop counter < 5 counter += 1
    @test counter == 5

    # cannot test because we cannot interrupt the infinite loop
    # @loop counter += 1

    foo() = @loop "1s" counter += 1
    for _ in 1:2
        t = @elapsed foo()
        @test t ≈ 1.0 atol=0.1
    end
    foo() = @loop "0.5s" counter += 1
    for _ in 1:2
        t = @elapsed foo()
        @test t ≈ 0.5 atol=0.1
    end
end
