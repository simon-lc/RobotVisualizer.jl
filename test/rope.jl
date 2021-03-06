@testset "Rope" begin
    # ## visualizer
    vis = RobotVisualizer.MeshCat.Visualizer()

    RobotVisualizer.set_light!(vis)
    RobotVisualizer.set_floor!(vis)
    RobotVisualizer.set_background!(vis)
    RobotVisualizer.set_camera!(vis)

    RobotVisualizer.build_rope(vis, N=50, name=:rope1)
    RobotVisualizer.build_rope(vis, N=50, name=:rope2)
    RobotVisualizer.set_straight_rope(vis, [0,0,0.0], [1,1,1.0], N=50, name=:rope1)
    RobotVisualizer.set_loose_rope(vis, [0,0,1.0], [3,3,3.0], rope_length=10, N=50, min_altitude=-0.0, name=:rope2)

    start_traj = [[-1-sin(2π*i/100), +1+0.00i,  2-0.0i] for i = 1:100]
    goal_traj =  [[+1+sin(2π*i/100), -1-0.00i,  1.8+0.2sin(2π*i/100)] for i = 1:100]

    anim = RobotVisualizer.MeshCat.Animation(30)
    vis, anim = RobotVisualizer.animate_straight_rope(vis, start_traj, goal_traj, name=:rope1)
    vis, anim = RobotVisualizer.animate_loose_rope(vis, start_traj, goal_traj, rope_length=4.5,
        anim=anim, name=:rope2, min_altitude=0.02)
    @test true
end
