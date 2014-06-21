name = {}
name.player = ""

function name:draw()
	love.graphics.printf("Enter your name for the highscore", 10, 10, 1004, "center")
	love.graphics.printf(self.player, 10, 100, 1004, "center")
end

function name:keypressed(key)
	if key == "return" then
		highscore.add(self.player, score)
		screen = splash
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
