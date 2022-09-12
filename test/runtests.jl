using Test

using LinearAlgebra
using Random

using RobotVisualizer

@testset "Rope"             verbose=true begin include("rope.jl") end
@testset "build and set"    verbose=true begin include("build_and_set.jl") end
