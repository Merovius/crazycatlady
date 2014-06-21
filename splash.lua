splash = {}

function splash:load()
end

function splash:draw()
	local w = imgs["splash"]:getWidth()
	local h = imgs["splash"]:getHeight()
	love.graphics.draw(imgs["splash"], 0, 0, 0, 1, 1)

	love.graphics.setColor(0, 0, 0, 100)
	love.graphics.rectangle("fill", 90, 100, 844, 470)

	love.graphics.setColor(255, 255, 255)
	for i, score, name in highscore() do
		if score == 0 then
			break
		end
		love.graphics.printf(string.format("%d. %s", i, name), 100, 50 + 50*i, 924, "left")
		love.graphics.printf(string.format("%d", score), 100, 50 + 50*i, 824, "right")
	end
	love.graphics.setColor(255, 255, 255)
end

function splash:keypressed(key)
	shootingrange:load()
	screen = shootingrange
end

function splash:update(dt)
end
