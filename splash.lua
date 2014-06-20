splash = {}

function splash:load()
end

function splash:draw()
	love.graphics.setColor(0, 255, 0)
	love.graphics.rectangle("fill", 0, 0, 1024, 768)
	love.graphics.setColor(255, 255, 255)

	love.graphics.printf("Crazy cat lady", 10, 300, 1014, "center")
	love.graphics.printf("Press any key", 10, 400, 1014, "center")
end

function splash:keypressed(key)
	shootingrange:load()
	screen = shootingrange
end

function splash:update(dt)
end
