######################################################################
# 2D frame
######################################################################
# function build_2d_frame!(vis::Visualizer;
#     name::Symbol=:contact,
#     origin_color=RGBA(0.2, 0.2, 0.2, 0.8),
#     normal_axis_color=RGBA(0, 1, 0, 0.8),
#     tangent_axis_color=RGBA(1, 0, 0, 0.8),
#     origin_radius=0.025,
#     ) where T
#
#     # axes
#     build_segment!(vis[:contacts][name];
#         color=tangent_axis_color,
#         segment_radius=origin_radius/2,
#         name=:tangent)
#
#     build_segment!(vis[:contacts][name];
#         color=normal_axis_color,
#         segment_radius=origin_radius/2,
#         name=:normal)
#
#     # origin
#     setobject!(vis[:contacts][name][:origin],
#         HyperSphere(GeometryBasics.Point(0,0,0.), origin_radius),
#         MeshPhongMaterial(color=origin_color));
#     return nothing
# end
#
# function set_2d_frame!(vis::Visualizer, origin, normal, tangent; name::Symbol=:contact)
#     settransform!(vis[:contacts][name][:origin],
#         MeshCat.Translation(MeshCat.SVector{3}(0, origin...)))
#     set_segment!(vis[:contacts][name], [0; origin], [0; origin+normal]; name=:normal)
#     set_segment!(vis[:contacts][name], [0; origin], [0; origin+tangent]; name=:tangent)
#     return nothing
# end


function build_frame!(vis::Visualizer;
    dimension::Int=3,
    name::Symbol=:contact,
    origin_color=RGBA(0.1, 0.1, 0.1, 0.8),
    tangent_x_axis_color=RGBA(1, 0, 0, 0.8),
    tangent_y_axis_color=RGBA(0, 1, 0, 0.8),
    normal_axis_color=RGBA(0, 0, 1, 0.8),
    origin_radius=0.025,
    ) where T

    # axes
    if dimension == 3
        build_segment!(vis[name];
            color=tangent_x_axis_color,
            segment_radius=origin_radius/2,
            name=:tangent_x)
    end
    build_segment!(vis[name];
        color=tangent_y_axis_color,
        segment_radius=origin_radius/2,
        name=:tangent_y)

    build_segment!(vis[name];
        color=normal_axis_color,
        segment_radius=origin_radius/2,
        name=:normal)

    # origin
    setobject!(vis[name][:origin],
        HyperSphere(GeometryBasics.Point(0,0,0.), origin_radius),
        MeshPhongMaterial(color=origin_color));
    return nothing
end

function set_frame!(vis::Visualizer, origin, normal, tangent_x, tangent_y;
        name::Symbol=:contact,
        normalize::Bool=true,
        axis_length=0.15)
    dimension = length(origin)
    if dimension == 2
        origin = [0; origin]
        tangent_x = [1; tangent_x]
        tangent_y = [0; tangent_y]
        normal = [0; normal]
    end
    if normalize
        tangent_x = axis_length .* tangent_x ./ (norm(tangent_x) + 1e-10)
        tangent_y = axis_length .* tangent_y ./ (norm(tangent_y) + 1e-10)
        normal = axis_length .* normal ./ (norm(normal) + 1e-10)
    end

    settransform!(vis[name][:origin],
        MeshCat.Translation(MeshCat.SVector{3}(origin...)))
    set_segment!(vis[name], origin, origin+tangent_x; name=:tangent_x)
    set_segment!(vis[name], origin, origin+tangent_y; name=:tangent_y)
    set_segment!(vis[name], origin, origin+normal; name=:normal)
    return nothing
end
