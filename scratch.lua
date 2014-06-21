scratch = {}

function scratch:load()
	self.t = 0
	self.mult = 0.5
	self.shake = const(0)
	self.m = 0
end

function scratch:draw()
	local img = imgs["scratch"..self.n..self.m]

	local h = img:getHeight()
	local scale = (768 / h) * 0.8
	local x = ((1024-img:getWidth()) / 2) / scale
	local y = (768-h*scale)

	love.graphics.setColor(231, 189, 213)
	love.graphics.rectangle("fill", 0, 0, 1024, 768)
	love.graphics.setColor(255, 255, 255)

	love.graphics.draw(img, x + self.shake(self.t), y, 0, scale, scale)

	love.graphics.setColor(255*(1-self.mult), 255*self.mult, 0)
	love.graphics.rectangle("fill", 100, 700, 824*self.mult, 20)
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("line", 100, 700, 824, 20)

	love.graphics.setColor(0, 0, 0)
	love.graphics.circle("fill", 100, 100, 52)
	love.graphics.setColor(self.t/5 * 255, (1-self.t/5)*255, 0)
	love.graphics.arc("fill", 100, 100, 50, 7*math.pi / 2, (3*math.pi / 2) + 2*math.pi*(self.t/5))
	love.graphics.setColor(255, 255, 255)
end

function scratch:update(dt)
	self.mult = self.mult - dt
	if self.mult < 0 then
		self.mult = 0
	end

	self.t = self.t + dt
	if self.t > 5 then
		score = math.floor(score + 100*self.mult)
		T = T + 20*self.mult
		screen = shootingrange
		return
	end
end

function scratch:keypressed(key)
	if key == " " then
		self.mult = self.mult + 0.2
		if self.mult > 1 then
			self.mult = 1
		end
		self.shake = dampening(50, 2, 5, self.t)
		self.m = (self.m + 1) % 2
		local n = math.random(1, 11)
		love.audio.play(sounds["scratching"..n])
	end
end
