require("util")

shootingrange = {}

function shootingrange:load()
	self.width = imgs["bg"]:getWidth()

	self.pos = 0
	self.cats = {}
	self.enemies = {}
	self.handx = -75
	self.handy = 400
	self.t = 0
	self.catcooloff = 0
	self.enemycooloff = 0
	self.remaining = 20
	self.landheight = 300
	self.wanderx = 600
	self.wandery = 100
	self.numenemies = 3
	self.nextsound = 5 + math.random()*5
	self.blinking = 0
	self.nexteye = 0
end

function shootingrange:draw()
	love.graphics.draw(imgs["bg"], -self.pos, 0, 0, scale, scale)

	for _, enemy in ipairs(self.enemies) do
		love.graphics.draw(enemy.img, enemy.x-enemy.ox-self.pos, enemy.y-enemy.oy, 0, 1, 1)
	end

	for _, cat in ipairs(self.cats) do
		local scale = 1/(1+self.t - cat.t0)

		love.graphics.draw(cat.img, cat.x-self.pos, cat.y, 0, scale, scale, -cat.ox, -cat.oy)
	end

	local w = self.hand:getWidth()
	local h = self.hand:getHeight()
	love.graphics.draw(self.hand, (1024-w)/2+(self.width/2-self.pos)/10, 768-h, 0, 1, 1)

	love.graphics.setColor(0, 0, 0)
	love.graphics.printf(score, 10, 10, 1024, "left")
	love.graphics.printf(string.format("%d:%.2d", math.floor(self.remaining / 60), self.remaining % 60), 10, 10, 1014, "right")
	love.graphics.setColor(255, 255, 255)
end

function shootingrange:update(dt)
	self.t = self.t + dt
	self.remaining = self.remaining - dt
	self.nextsound = self.nextsound - dt
	self.blinking = self.blinking - dt
	self.nexteye = self.nexteye - dt
	if self.remaining < 0 then
		screen = name
		return
	end

	if self.nexteye < 0 and self.catcooloff == 0 then
		self.nexteye = 1 + math.random()*2
		if math.random(1, 4) == 1 then
			self.blinking = 0.2
			self.hand = imgs["muschi_holding_blink"]
		else
			self.hand = imgs["muschi_holding_0"..math.random(1,2)]
		end
	elseif self.blinking < 0 then
		if self.hand == imgs["muschi_holding_blink"] then
			local n = math.random(1, 2)
			self.hand = imgs["muschi_holding_0"..n]
		end
	end

	if self.nextsound <= 0 then
		self.nextsound = 5 + math.random()*5
		local n = math.random(1, 6)
		love.audio.play(sounds["meow"..n])
	end

	if self.catcooloff > 0 then
		self.catcooloff = self.catcooloff - dt
	end
	if self.catcooloff < 0 then
		self.hand = imgs["muschi_holding_0"..math.random(1,2)]
		self.catcooloff = 0
	end

	local x = love.mouse.getX()

	if x < 100 then
		self.pos = self.pos - dt*5*(100-x)
	elseif x > 924 then
		self.pos = self.pos + dt*5*(x-924)
	end

	if love.keyboard.isDown("left") then
		self.pos = self.pos - dt*200
	elseif love.keyboard.isDown("right") then
		self.pos = self.pos + dt*200
	end

	if self.pos < 0 then
		self.pos = 0
	elseif self.pos > self.width - 1024 then
		self.pos = self.width - 1024
	end

	for i, cat in ipairs(self.cats) do
		local newx, newy = cat.curve(self.t - cat.t0)
		if not cat.turned and newy > cat.y then
			cat.turned = true
			if newx < cat.x then
				cat.img = imgs["catdown"]
			else
				cat.img = imgs["catdownr"]
			end
			cat.ox = cat.img:getWidth()/2
			cat.oy = cat.img:getHeight()/2
		end
		cat.x, cat.y = newx, newy

		if self.t - cat.t0 >= 1 then
			table.remove(self.cats, i)
		elseif self.t - cat.t0 >= 0.8 then
			for j, enemy in ipairs(self.enemies) do
				if dist(cat.x+cat.ox-self.pos, cat.y+cat.oy, enemy.x-self.pos, enemy.y-120) < 75 then
					table.remove(self.cats, i)
					table.remove(self.enemies, j)
					scratch.n = enemy.n
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
		if #self.enemies < self.numenemies then
			local enemy = {}
			enemy.n = math.random(2)-1

			local img = "enemy"..enemy.n.."1"

			local w, h = imgs["enemy00"]:getWidth(), imgs["enemy00"]:getHeight()
			enemy.ox = w/2
			enemy.oy = h/2

			local startx = math.random()*(self.width - 768 - w)
			if startx > self.pos - w/2 then
				startx = startx + 768 + w
			end
			local endx = startx + math.random()*self.wanderx - self.wanderx/2
			if endx > startx then
				enemy.right = true
				img = img .. "r"
			end
			enemy.img = imgs[img]

			local starty = 768-math.random()*self.landheight
			local endy = starty + math.random()*self.wandery - self.wandery/2
			if endy < 768 - self.landheight then
				endy = 768 - self.landheight
			end
			enemy.x = startx
			enemy.y = starty
			enemy.t0 = self.t

			enemy.curve = line(startx, starty, endx, endy)
			enemy.curvelen = len(startx, starty, endx, endy)
			enemy.wait = math.random()

			table.insert(self.enemies, enemy)
		end
	end

	for i, enemy in ipairs(self.enemies) do
		if enemy.wait > 0 then
			enemy.wait = enemy.wait - dt
			if enemy.wait <= 0 then
				enemy.t0 = self.t
			end
		elseif self.t-enemy.t0 < enemy.curvelen/400 then
			enemy.x, enemy.y = enemy.curve((self.t-enemy.t0) / (enemy.curvelen / 400))
			if enemy.x > self.width + enemy.ox or enemy.x < -enemy.ox or enemy.y > 768 + enemy.oy then
				table.remove(self.enemies, i)
			end
		else
			local startx, starty = enemy.x, enemy.y
			local endx = startx + (0.5+math.random())*self.wanderx - self.wanderx/2
			local endy = starty + (0.5+math.random())*self.wandery - self.wandery/2
			if endy < 768 - self.landheight then
				endy = 768 - self.landheight
			end
			enemy.t0 = self.t
			enemy.curvelen = len(startx, starty, endx, endy)
			enemy.wait = math.random()
			enemy.curve = line(startx, starty, endx, endy)
			enemy.right = (startx < endx)
		end

		local img = "enemy"
		img = img .. enemy.n
		local t = self.t - enemy.t0
		t = t - math.floor(t)
		if t > 0.5 then
			img = img .. "0"
		else
			img = img .. "1"
		end
		if enemy.right then
			img = img .. "r"
		end
		enemy.img = imgs[img]
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

	if x > 1024/2 then
		cat.img = imgs["catr"]
	else
		cat.img = imgs["cat"]
	end

	local w = cat.img:getWidth()
	local h = cat.img:getHeight()
	local sx = self.pos + (1024 - w) / 2 + (self.width/2-self.pos)/10 + self.handx
	local sy = self.handy

	local ex = self.pos + x - w/2
	local ey = y - h/2
	local vx, vy = ex - sx, ey - 200 - sy

	cat.curve = bezier(sx, sy, sx + vx, sy + vy, ex, ey-150, ex, ey)

	cat.x, cat.y = sx, sy
	cat.ox, cat.oy = w/2, cat.img:getHeight()/2

	table.insert(self.cats, cat)
	local n = math.random(1, 10)
	love.audio.play(sounds["thrown"..n])

	self.hand = imgs["hand"]
end
