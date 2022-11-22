######################################################################
# polytope
######################################################################
function build_polytope!(vis::Visualizer, A::Matrix{T}, b::Vector{T};
        name::Symbol=:polytope,
        color=RGBA(0.8, 0.8, 0.8, 1.0)) where T

    h = Polyhedra.hrep(A, b)
    p = Polyhedra.polyhedron(h)
    m = Polyhedra.Mesh(p)
    try
        setobject!(vis[name], m, MeshPhongMaterial(color=color))
    catch e
    end
    return nothing
end

function build_2d_polytope!(vis::Visualizer, A::Matrix{T}, b::Vector{T};
        name::Symbol=:polytope,
        thickness=0.10,
        color=RGBA(0.8, 0.8, 0.8, 1.0)) where T

    n = size(A)[1]
    Ae = [zeros(n) A]
    Ae = [Ae;
         -1 0 0;
          1 0 0]
    be = [b; thickness/2; thickness/2]
    build_polytope!(vis, Ae, be, name=name, color=color)
    return nothing
end

function set_2d_polytope!(vis::Visualizer, p::Vector{T}, q::Vector{T};
        name::Symbol=:polytope) where T
    pe = [0; p]

    rotX = Quaternion(cos(q[1]/2), sin(q[1]/2), 0.0, 0.0)
    settransform!(vis[name], MeshCat.compose(
        MeshCat.Translation(MeshCat.SVector{3}(pe)),
        MeshCat.LinearMap(rotationmatrix(rotX)),
        )
    )
    return nothing
end
