function catenary_parameters(x_start, x_goal, rope_length; iterations=500, tolerance=1e-6,
        a_guess=0.0, dx_guess=0.0)

    rope_length =  max(rope_length, (1+1e-5)*norm(x_goal - x_start))
    h = x_goal[1] - x_start[1]
    v = x_goal[2] - x_start[2]

    # find a i.e. the shape of the catenary
    res(b) = 1/sqrt(sqrt(rope_length^2 - v^2)/h - 1) - 1/sqrt(2b * sinh(1/(2b)) - 1)
    b = newton_solver(res, a_guess/h, iterations=iterations, tolerance=tolerance)
    a = b * h

    # find x offset
    function caten(x; a=a)
        return a * cosh(x/a)
    end
    res = dx -> caten(x_goal[1] + dx) - caten(x_start[1] + dx) - (x_goal[2] - x_start[2])
    dx = newton_solver(res, dx_guess, iterations=iterations, tolerance=tolerance)

    # find y offset
    dy = x_goal[2] - caten(x_goal[1] + dx)

    # final function
    return a, dx, dy
end

function catenary(x; a=0.0, dx=0.0, dy=0.0)
    return a * cosh((x+dx)/a) + dy
end
