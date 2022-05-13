function build_rope(vis::Visualizer; N::Int=10, color=Colors.RGBA(0,0,0,1),
        rope_type::Symbol=:cylinder, rope_radius=0.02, name=:rope)

    if rope_type == :line
        line = MeshCat.Line([xa, xb])
        material = LineBasicMaterial(color=color, wireframeLinewidth=10, linewidth=10)
    elseif rope_type == :cylinder
        line = MeshCat.Cylinder(Point(0,0,0.0), Point(0,0,1.0), rope_radius)
        material = MeshPhongMaterial(color=color)
    end

    for i = 1:N
        setobject!(vis[name][Symbol(i)][:scaled], line, material)
    end

    return vis
end

function set_straight_rope(vis::Visualizer, x_start, x_goal; N::Int=10, name::Symbol=:rope)
    Λ = range(0,1,length=N+1)
    x = [(1-λ)*x_start + λ * x_goal for λ in Λ]
    for i = 1:N
        transform, scaling = link_transform(x[i], x[i+1])
        settransform!(vis[name][Symbol(i)][:scaled], scaling)
        settransform!(vis[name][Symbol(i)], transform)
    end
    return nothing
end

function set_loose_rope(vis::Visualizer, x_start, x_goal; N::Int=10,
        rope_length=2norm(x_goal - x_start), min_altitude=-Inf, a_guess=1.0, dx_guess=0.0, name::Symbol=:rope)
    v = x_goal - x_start
    shadow_rope_length = norm(v[1:2])
    θ = atan(v[2], v[1])
    R = rotationmatrix(RotZ(-θ))
    v̄ = R * v # rotated into the xz plane

    a, dx, dy = catenary_parameters(zeros(2), v̄[[1,3]], rope_length, a_guess=a_guess, dx_guess=dx_guess)
    Λ = shadow_rope_length * range(0,1,length=N+1)
    x = []
    for i = 1:N+1
        xi = x_start + R' * [Λ[i], 0, catenary(Λ[i], a=a, dx=dx, dy=dy)]
        xi[3] = max(xi[3], min_altitude)
        push!(x, xi)
    end
    for i = 1:N
        transform, scaling = link_transform(x[i], x[i+1])
        settransform!(vis[name][Symbol(i)][:scaled], scaling)
        settransform!(vis[name][Symbol(i)], transform)
    end
    return a, dx
end

function animate_straight_rope(vis::Visualizer, start_traj::Vector, goal_traj::Vector;
        anim::Animation=MeshCat.Animation(100), N::Int=50, name=:rope)
    M = length(start_traj)

    for i = 1:M
        atframe(anim, i) do
            xa = start_traj[i]
            xb = goal_traj[i]
            set_straight_rope(vis, xa, xb, N=N, name=name)
        end
    end
    setanimation!(vis, anim)
    return vis, anim
end

function animate_loose_rope(vis::Visualizer, start_traj::Vector, goal_traj::Vector;
        anim::Animation=MeshCat.Animation(100), rope_length=30.0, N::Int=50, min_altitude=-Inf, name=:rope)
    M = length(start_traj)

    a_guess = 1.0
    dx_guess = 0.0

    for i = 1:M
        atframe(anim, i) do
            xa = start_traj[i]
            xb = goal_traj[i]
            a_guess, dx_guess = set_loose_rope(vis, xa, xb, rope_length=rope_length,
                N=N, min_altitude=min_altitude, a_guess=a_guess, dx_guess=dx_guess, name=name)
        end
    end
    setanimation!(vis, anim)
    return vis, anim
end
