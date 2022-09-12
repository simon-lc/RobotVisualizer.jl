@testset "Build and Set" begin
    # ## visualizer
    vis = RobotVisualizer.MeshCat.Visualizer()

    RobotVisualizer.set_light!(vis)
    RobotVisualizer.set_floor!(vis)
    RobotVisualizer.set_background!(vis)
    RobotVisualizer.set_camera!(vis)

    # frame
    RobotVisualizer.build_2d_frame!(vis, name=:contact)
    origin = [1, 2, 3.0]
    normal = [1, 0, 0.0]
    tangent = [0, 1, 0.0]
    RobotVisualizer.set_2d_frame!(vis, origin, normal, tangent; name=:contact)

    # polytope
    A = [
    	+1.0 +0.0;
    	+0.0 +1.0;
    	-1.0 +0.0;
    	+0.0 -1.0;
    	]
    b = 0.5*[
    	+1,
    	+1,
    	+1,
    	+1,
    	]
    p = [1, 2.0]
    q = [2.0]
    RobotVisualizer.build_2d_polytope!(vis, A, b; name=:polytope)
    RobotVisualizer.set_2d_polytope!(vis, p, q; name=:polytope)

    # segment
    x_goal = [2, 3, 1.0]
    x_start = [1, 2, 3.0]
    RobotVisualizer.build_segment!(vis; name=:segment)
    RobotVisualizer.set_segment!(vis, x_start, x_goal; name=:segment)

    # surface
    RobotVisualizer.set_surface!(vis, x -> x[3];
        xlims=[-4.0, 4.0],
        ylims=[-4.0, 4.0],
        zlims=[-4.0, 4.0],
    	name=:surface,
        n=20)
    @test true
end
