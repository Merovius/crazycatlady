name = {}
name.player = ""

function name:draw()
	love.graphics.draw(imgs["leaderboard"], 0, 0, 0, 1, 1)

	love.graphics.setColor(0, 0, 0, 100)
	love.graphics.rectangle("fill", 90, 200, 844, 300)
	love.graphics.setColor(255, 255, 255)

	love.graphics.printf("Enter your name for the highscore", 100, 210, 824, "center")
	love.graphics.printf(self.player, 10, 400, 1004, "center")
end

function name:keypressed(key)
	if key == "return" then
		highscore.add(self.player, score)
		screen = leaderboard
		return
	end
	if key:match("^%w$") then
		self.player = self.player .. key
		return
	end
	if key == "backspace" then
		self.player = self.player:sub(1, #self.player-1)
	end
end

function name:update()
end
