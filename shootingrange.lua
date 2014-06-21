require("util")

shootingrange = {}

function shootingrange:load()
	for _, v in ipairs({ "bg", "hand", "cat", "enemy0", "enemy1", "enemy2", "muschi_holding_02" }) do
		imgs[v] = love.graphics.newImage("assets/"..v..".png")
	end
	self.width = imgs["bg"]:getWidth()

	for _, v in ipairs({ "angry_cat" }) do
		sounds[v] = love.audio.newSource("assets/"..v..".mp3", "static")
	end

	self.pos = 0
	self.cats = {}
	self.enemies = {}
	self.handx = 511
	self.handy = 602
	self.t = 0
	self.catcooloff = 0
	self.enemycooloff = 0
	self.remaining = 120
end

function shootingrange:draw()
	love.graphics.draw(imgs["bg"], -self.pos, 0, 0, scale, scale)

	for _, enemy in ipairs(self.enemies) do
		love.graphics.draw(enemy.img, enemy.x-enemy.ox-self.pos, enemy.y-enemy.oy, 0, 1, 1)
	end

	local dx = imgs["cat"]:getWidth()/2
	local dy = imgs["cat"]:getHeight()/2

	for _, cat in ipairs(self.cats) do
		love.graphics.draw(imgs["cat"], cat.x-dx-self.pos, cat.y-dy, 0, 1, 1)
	end

	local w = imgs["muschi_holding_02"]:getWidth()
	local h = imgs["muschi_holding_02"]:getHeight()

	love.graphics.draw(imgs["muschi_holding_02"], (1024-w)/2+(self.width/2-self.pos)/10, 768-h, 0, 1, 1)

	love.graphics.setColor(0, 0, 0)
	love.graphics.printf(score, 10, 10, 1024, "left")
	love.graphics.printf(string.format("%d:%.2d", math.floor(self.remaining / 60), self.remaining % 60), 10, 10, 1014, "right")
	love.graphics.setColor(255, 255, 255)
end

function shootingrange:update(dt)
	self.t = self.t + dt
	self.remaining = self.remaining - dt
	if self.remaining < 0 then
		love.event.quit()
	end

	self.catcooloff = self.catcooloff - dt

	local x = love.mouse.getX()

	if x < 100 then
		self.pos = self.pos - dt*5*(100-x)
	elseif x > 924 then
		self.pos = self.pos + dt*5*(x-924)
	end

	if love.keyboard.isDown("left") then
		self.pos = self.pos + dt*200
	elseif love.keyboard.isDown("right") then
		self.pos = self.pos - dt*200
	end

	if self.pos < 0 then
		self.pos = 0
	elseif self.pos > self.width - 1024 then
		self.pos = self.width - 1024
	end

	local thresh = imgs["cat"]:getWidth()/ 2
	for i, cat in ipairs(self.cats) do
		cat.x, cat.y = cat.curve(self.t - cat.t0)

		if self.t - cat.t0 >= 1 then
			table.remove(self.cats, i)
		elseif self.t - cat.t0 >= 0.8 then
			for j, enemy in ipairs(self.enemies) do
				if dist(cat.x, cat.y, enemy.x, enemy.y) < thresh then
					table.remove(self.cats, i)
					table.remove(self.enemies, j)
					scratch:setImg(enemy.img)
					scratch:load()
					screen = scratch
					return
				end
			end
		end
	end

	self.enemycooloff = self.enemycooloff - dt
	if self.enemycooloff <= 0 then
		self.enemycooloff = math.random() * 3 / (1+T/90)
		if #self.enemies < 5 then
			local startx = math.random()*self.width
			local endx = startx
			while math.abs(endx - startx) < 200 do
				endx = math.random()*self.width
			end

			local n = math.random(3)-1
			local enemy = {}
			enemy.img = imgs[string.format("enemy%d", n)]
			local w, h = enemy.img:getWidth(), enemy.img:getHeight()
			enemy.ox = w/2
			enemy.oy = h/2
			local c1 = bezier(startx, 768+h/2, startx, 768-h/2, startx, 768-h/2, (startx+endx)/2, 768-h/2)
			local c2 = bezier((startx+endx)/2, 768-h/2, endx, 768-h/2, endx, 768-h/2, endx, 768+h/2)
			enemy.curve = concat(c1, c2)
			enemy.speed = math.abs(startx-endx)*(1+math.random()) * 0.01 / (1 + T/120)
			enemy.t0 = self.t
			table.insert(self.enemies, enemy)
		end
	end

	for i, enemy in ipairs(self.enemies) do
		if self.t-enemy.t0 < enemy.speed then
			enemy.x, enemy.y = enemy.curve((self.t-enemy.t0)/enemy.speed)
		else
			table.remove(self.enemies, i)
		end
	end
end

function shootingrange:mousepressed(x, y, button)
	if button ~= "l" then
		return
	end

	if self.catcooloff > 0 then
		return
	end
	self.catcooloff = 0.5

	local cat = {}
	cat.t0 = self.t

	local sx = self.pos + self.handx
	local sy = self.handy
	local ex = self.pos + x
	local ey = y
	local vx, vy = ex - sx, ey - 200 - sy

	cat.curve = bezier(sx, sy, sx + vx, sy + vy, ex, ey-150, ex, ey)

	table.insert(self.cats, cat)
	love.audio.play(sounds["angry_cat"])
end
