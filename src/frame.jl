######################################################################
# 2D frame
######################################################################
function build_2d_frame!(vis::Visualizer;
    name::Symbol=:contact,
    origin_color=RGBA(0.2, 0.2, 0.2, 0.8),
    normal_axis_color=RGBA(0, 1, 0, 0.8),
    tangent_axis_color=RGBA(1, 0, 0, 0.8),
    origin_radius=0.025,
    ) where T

    # axes
    build_segment!(vis[:contacts][name];
        color=tangent_axis_color,
        segment_radius=origin_radius/2,
        name=:tangent)

    build_segment!(vis[:contacts][name];
        color=normal_axis_color,
        segment_radius=origin_radius/2,
        name=:normal)

    # origin
    setobject!(vis[:contacts][name][:origin],
        HyperSphere(GeometryBasics.Point(0,0,0.), origin_radius),
        MeshPhongMaterial(color=origin_color));
    return nothing
end

function set_2d_frame!(vis::Visualizer, origin, normal, tangent; name::Symbol=:contact)
    settransform!(vis[:contacts][name][:origin],
        MeshCat.Translation(MeshCat.SVector{3}(0, origin...)))
    set_segment!(vis[:contacts][name], [0; origin], [0; origin+normal]; name=:normal)
    set_segment!(vis[:contacts][name], [0; origin], [0; origin+tangent]; name=:tangent)
    return nothing
end
