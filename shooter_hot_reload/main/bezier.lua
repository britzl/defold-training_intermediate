local M = {}
--
-- Cubic bezier curve
-- M(t) = (1-t)³A + 3t(1-t)²B + 3t²(1-t)C + t³D
--
M.point = function(t, A, B, C, D)
	local u = 1 - t
  	local tt = t*t
  	local uu = u*u
  	local uuu = uu * u
  	local ttt = tt * t
	
	local p = uuu * A 			-- first term
	p = p + 3 * t * uu * B  	-- second term
	p = p + 3 * tt * u * C		-- third term
	p = p + ttt * D				-- fourth term
	return p
end

-- Precompute the three vector terms of the derivative
-- dM/dt = t²(-3A + 9B - 9C + 3D) + t(6A - 12B + 6C) + (-3A + 3B)

-- v1 = -3A + 9B - 9C + 3D
-- 
M.v1 = function(A, B, C, D)
	return -3*A + 9*B - 9*C + 3*D
end

-- v2 = 6A - 12B + 6C
M.v2 = function(A, B, C)
	return 6*A - 12*B + 6*C
end

-- v3 = -3A + 3B
M.v3 = function(A, B)
	return -3*A + 3*B
end

--
-- Tangent vector
--
-- dM/dt = t²(-3A + 9B - 9C + 3D) + t(6A - 12B + 6C) + (-3A + 3B)
--       = t²v1 + tv2 + v3                 							precomputed derivative terms
--
M.tangent = function(t, v1, v2, v3)
	return t * t * v1 + t * v2 + v3
end

--
-- Advance a (small) step along curve
-- t = t + L / length(t * t * v1 + t * v2 + v3);
--
M.step = function(t, l, v1, v2, v3)
	return t + l / vmath.length(M.tangent(t, v1, v2, v3))
end

--
-- Advance a large step along curve iteratively
--
M.long_step = function(t, l, v1, v2, v3)
	for i = 0,200 do
	    t = t + (l / 200) / vmath.length(M.tangent(t, v1, v2, v3))
	end
	return t
end

return M
