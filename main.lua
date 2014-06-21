require("name")
require("sick")
require("splash")
require("leaderboard")
require("scratch")
require("shootingrange")

imgs = {}
sounds = {}
score = 0
screen = splash
T = 0

function love.load()
	math.randomseed(os.time())

	highscore.set("score", 9, "Nobody", 0)

	font = love.graphics.newFont("assets/JandaFabulous.ttf", 50)
	love.graphics.setFont(font)

	for _, v in ipairs({ "bg", "splash", "leaderboard", "cat", "catr", "catdown", "catdownr", "hand", "muschi_holding_01", "muschi_holding_02", "muschi_holding_blink" }) do
		imgs[v] = love.graphics.newImage("assets/"..v..".png")
	end
	for i = 0, 1 do
		for j = 0, 1 do
			local v
			for _, d in ipairs{ "", "r" } do
				v = "enemy"..i..j..d
				imgs[v] = love.graphics.newImage("assets/"..v..".png")
			end
			v = "scratch"..i..j
			imgs[v] = love.graphics.newImage("assets/"..v..".png")
		end
	end

	for i = 1, 6 do
		local v = "meow"..i
		sounds[v] = love.audio.newSource("assets/"..v..".mp3", "static")
	end
	for i = 1, 11 do
		local v = "scratching"..i
		sounds[v] = love.audio.newSource("assets/"..v..".mp3", "static")
	end
	for i = 1, 10 do
		local v = "thrown"..i
		sounds[v] = love.audio.newSource("assets/"..v..".mp3", "static")
	end

	music = love.audio.newSource("assets/music.mp3", "stream")
	music:setLooping(true)
	love.audio.play(music)

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

function love.quit()
	highscore.save()
end
