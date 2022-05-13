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
