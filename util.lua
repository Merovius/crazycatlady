function bezier(x1, y1, x2, y2, x3, y3, x4, y4)
	return function(t)
		local x = (1-t)*(1-t)*(1-t)*x1 + 3*(1-t)*(1-t)*t*x2 + 3*(1-t)*t*t*x3 + t*t*t*x4
		local y = (1-t)*(1-t)*(1-t)*y1 + 3*(1-t)*(1-t)*t*y2 + 3*(1-t)*t*t*y3 + t*t*t*y4
		return x, y
	end
end

function concat(f1, f2)
	return function(t)
		if t < 0.5 then
			return f1(2*t)
		else
			return f2(2*t-1)
		end
	end
end

function dist(x1, y1, x2, y2)
	local dx = x1 - x2
	local dy = y1 - y2
	return math.sqrt(dx*dx + dy*dy)
end

function len(x, y)
	return math.sqrt(x*x + y*y)
end

function const(c)
	return function(t)
		return c
	end
end

function dampening(amp, damp, f, T0)
	if T0 == nil then
		T0 = 0
	end
	if f == nil then
		f = 1
	end
	if damp == nil then
		damp = 1
	end
	if amp == nil then
		amp = 1
	end
	return function(t)
		return amp*math.exp(-damp*(t-T0))*math.sin(2*math.pi*f*(t - T0))
	end
end
