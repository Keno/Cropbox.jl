using Cropbox
using Unitful
using Test

@testset "cropbox" begin
    include("macro.jl")
    include("state.jl")
    include("system.jl")
    include("unit.jl")
    include("lotka_volterra.jl")
    include("root_structure.jl")
    include("photosynthesis.jl")
end
