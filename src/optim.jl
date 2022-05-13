function newton_solver(res, x0; iterations=500, tolerance=1e-6)
    x = x0
    for i = 1:iterations
        r = res(x)
        (norm(r, Inf) < tolerance) && break
        ∇r = FiniteDiff.finite_difference_derivative(x -> res(x), x)
        Δx = - r / ∇r
        α = 1.0
        r_cand = Inf
        while norm(r_cand, Inf) >= norm(r, Inf)
            r_cand = res(x + α * Δx)
            α /= 2
        end
        x += α * Δx
        (i == iterations) && (@show "solver failure")
    end
    return x
end
