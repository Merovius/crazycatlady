splash = {}

function splash:load()
end

function splash:draw()
	local w = imgs["splash"]:getWidth()
	local h = imgs["splash"]:getHeight()
	love.graphics.draw(imgs["splash"], 0, 0, 0, 1, 1)
end

function splash:keypressed(key)
	shootingrange:load()
	screen = shootingrange
end

function splash:update(dt)
end
