module RobotVisualizer

using Colors
using GeometryBasics
using FiniteDiff
using LinearAlgebra
using MeshCat
using Quaternions
using Rotations
using FFMPEG


include("rope/catenary.jl")
include("rope/optim.jl")
include("rope/rope.jl")


include("frame.jl")
include("segment.jl")
include("polytope.jl")
include("output.jl")
include("scene.jl")
include("utils.jl")


export
    set_floor!,
    set_surface!,
    set_light!,
    set_background!,
    set_camera!,
    build_2d_polytope,
    build_polytope,
    set_2d_polytope,
    build_2d_frame,
    set_2d_frame!,
    build_segment,
    set_segment!

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
