function module_dir()
    joinpath(@__DIR__, "..")
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

function skew(p)
    [
    	 0    -p[3]  p[2];
    	 p[3]  0    -p[1];
    	-p[2]  p[1]  0;
    ]
end
