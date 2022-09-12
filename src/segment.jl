function link_transform(start, goal)
    # transforms a vertical line of length 1 into a line between start and goal
    v1 = [0.0, 0.0, 1.0]
    v2 = goal[1:3] - start[1:3]
    normalize!(v2)
    ax = cross(v1, v2)
    ang = acos(v1' * v2)
    q = axis_angle_to_quaternion(ang * normalize!(ax))

    rope_length = norm(goal - start)
    scaling = MeshCat.LinearMap(I * Diagonal([1.0, 1.0, rope_length]))
    transform = MeshCat.compose(MeshCat.Translation(start), MeshCat.LinearMap(rotationmatrix(q)))
    return transform, scaling
end

function axes_pair_to_quaternion(n1, n2)
	if norm(n1 + n2, Inf) < 1e-5
		n2 = n2 + 1e-5ones(3)
	end

	reg(x) = 1e-20 * (x == 0) + x
	# provides the quaternion that rotates n1 into n2, assuming n1 and n2 are normalized
	n1 ./= reg(norm(n1))
	n2 ./= reg(norm(n2))
	n3 = skew(n1)*n2
	cθ = n1' * n2 # cosine
	sθ = norm(n3) # sine
	axis = n3 ./ reg(sθ)
	tanθhalf = sθ / reg(1 + cθ)
	q = [1; tanθhalf * axis]
	q /= norm(q)
	return Quaternion(q...)
end

function axis_angle_to_quaternion(x)
	@assert length(x) == 3
	θ = norm(x)
	if θ > 0.0
		r = x ./ θ
		q = Quaternion(cos(0.5 * θ), sin(0.5 * θ) * r)
	else
		q = Quaternion(1.0, 0.0, 0.0, 0.0)
	end
	return q
end

######################################################################
# segment
######################################################################
function build_segment!(vis::Visualizer; color=Colors.RGBA(0,0,0,1),
        segment_radius=0.02, name=:segment)

    segment = MeshCat.Cylinder(MeshCat.Point(0,0,0.0), MeshCat.Point(0,0,1.0), segment_radius)
    material = MeshPhongMaterial(color=color)
    setobject!(vis[name][:scaled], segment, material)
    return vis
end

function set_segment!(vis::Visualizer, x_start, x_goal; name::Symbol=:segment)
    transform, scaling = link_transform(x_start, x_goal)
    settransform!(vis[name][:scaled], scaling)
    settransform!(vis[name], transform)
    return nothing
end

################################################################################
# arrow
################################################################################
"""
    set_arrow!(vis, origin, direction; color, shaft_radius, max_head_radius, scaling, name)

    adds an arrow object to scene

    vis: Visualizer
    origin: point defining arrow base
    direction: vector defining arrow
    color: RGBA
    shaft_radius: dimension of arrow shaft
    max_head_radius: dimension of arrow head base
    scaling: parameter that scales the entire arrow
    name: Symbol
"""
function set_arrow!(vis, origin, direction;
    color=Colors.RGBA(1.0, 0.0, 0.0, 1.0),
    shaft_radius=0.0125,
    max_head_radius=0.025,
    scaling=0.2,
    name=:name)

    # create arrow
    arrow_vis = ArrowVisualizer(vis[name])
    setobject!(arrow_vis, MeshPhongMaterial(color=color))

    # direction
    scaled_direction = scaling * direction

    # set
    settransform!(arrow_vis,
        Point(origin...),
        Vec(scaled_direction...),
        shaft_radius=shaft_radius,
        max_head_radius=max_head_radius)
end
