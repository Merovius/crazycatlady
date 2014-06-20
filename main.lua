require("splash")
require("scratch")
require("shootingrange")

imgs = {}
sounds = {}
score = 0
screen = splash
T = 0

function love.load()
	math.randomseed(os.time())

	font = love.graphics.newFont("assets/comic.ttf", 100)
	love.graphics.setFont(font)

	love.mouse.setGrabbed(true)

	splash:load()
end

function love.draw()
	screen:draw()
end

function love.update(dt)
	T = T + dt

	screen:update(dt)
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


