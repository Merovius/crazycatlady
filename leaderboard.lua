leaderboard = {}

function leaderboard:load()
end

function leaderboard:draw()
	love.graphics.draw(imgs["leaderboard"], 0, 0, 0, 1, 1)

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

function leaderboard:keypressed(key)
	shootingrange:load()
	screen = shootingrange
end

function leaderboard:update(dt)
end
