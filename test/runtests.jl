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

    t = @elapsed @loop "1s" counter += 1
    @test t ≈ 1.0 atol=0.1
    @test_throws ArgumentError @loop "1" counter += 1
end
