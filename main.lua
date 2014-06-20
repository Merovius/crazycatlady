require("scratch")
require("shootingrange")

imgs = {}
sounds = {}
score = 0
screen = shootingrange
remaining = 120
T = 0

function love.load()
	math.randomseed(os.time())

	font = love.graphics.newFont("assets/comic.ttf", 100)
	love.graphics.setFont(font)

	love.mouse.setGrabbed(true)

	shootingrange:load()
end

function love.draw()
	screen:draw()

	love.graphics.printf(score, 10, 10, 1014, "left")
	love.graphics.printf(string.format("%d:%.2d", math.floor(remaining / 60), remaining % 60), 10, 10, 1014, "right")
end

function love.update(dt)
	T = T + dt
	remaining = remaining - dt

	screen:update(dt)
	if remaining <= 0 then
		love.event.quit()
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
	if screen.keypressed ~= nil then
		screen:keypressed(key)
	end
end

function love.mousepressed(x, y, button)
	if screen.mousepressed ~= nil then
		screen:mousepressed(x, y, button)
	end
end


