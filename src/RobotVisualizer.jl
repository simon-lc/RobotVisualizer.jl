module RobotVisualizer

using Colors
using GeometryBasics
using FiniteDiff
using LinearAlgebra
using MeshCat
using Quaternions
using FFMPEG


include("rope/catenary.jl")
include("rope/optim.jl")
include("rope/rope.jl")

include("gif.jl")
include("set.jl")
include("transform.jl")
include("utils.jl")


export
    set_light!,
    set_floor!,
    set_background!,
    set_surface!

export
    build_rope,
    set_straight_rope,
    set_loose_rope,
    animate_straight_rope,
    animate_loose_rope

export
    convert_video_to_gif,
    convert_frames_to_video_and_gif

end # module
