using RobotVisualizer
using MeshCat


# ## visualizer
vis = MeshCat.Visualizer()
open(vis)

set_light!(vis)
set_floor!(vis)
set_background!(vis)

build_rope(vis, N=50, name=:rope1)
build_rope(vis, N=50, name=:rope2)
set_straight_rope(vis, [0,0,0.0], [1,1,1.0], N=50, name=:rope1)
set_loose_rope(vis, [0,0,1.0], [3,3,3.0], rope_length=10, N=50, min_altitude=-0.0, name=:rope2)

start_traj = [[-1-sin(2π*i/100), +1+0.00i,  2-0.0i] for i = 1:100]
goal_traj =  [[+1+sin(2π*i/100), -1-0.00i,  1.8+0.2sin(2π*i/100)] for i = 1:100]

anim = Animation(30)
vis, anim = animate_straight_rope(vis, start_traj, goal_traj, name=:rope1)
vis, anim = animate_loose_rope(vis, start_traj, goal_traj, rope_length=4.5,
    anim=anim, name=:rope2, min_altitude=0.02)

convert_frames_to_video_and_gif("rope_loop")
