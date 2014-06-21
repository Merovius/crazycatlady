credits = {}
credits.state = 0
credits.T = 0

function credits:draw()
	love.graphics.setColor(249, 172, 216)
	love.graphics.rectangle("fill", 0, 0, 1024, 768)
	love.graphics.setColor(255, 255, 255)

	if self.state == 0 then
		love.graphics.printf("Credits:", 0, 100, 1024, "center")
		love.graphics.printf("Code: Merovius", 0, 300, 1024, "center")
		love.graphics.printf("Grafik: Lea", 0, 400, 1024, "center")
		love.graphics.printf("Executive producer: sECuRE", 0, 500, 1024, "center")
	else
		love.graphics.printf("Credits:", 0, 100, 1024, "center")
		love.graphics.printf("Musik: \"trace 5\" by fp", 0, 300, 1024, "center")
		love.graphics.printf("Voice acting: Random nerds (thanks!)", 0, 450, 1024, "center")
	end
end

function credits:update(dt)
	self.T = self.T + dt
	if self.T > 5 then
		self.T = self.T - 3
		self.state = (self.state + 1) % 2
	end
end

function credits:keypressed()
	shootingrange:load()
	screen = shootingrange
end
