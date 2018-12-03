blood = class("blood")
bloodParticles = {}

local bloodImage = love.graphics.newImage("assets/gfx/sprites/blood.png")
local colors = {{1, 50/255, 10/255}, {1, 134/255, 35/255}}

function blood:initialize(x, y, color)
	self.x = x
	self.y = y 
	
	self.xvel = math.random(-50, 50)
	self.yvel = math.random(-20, -50)

	self.color = color

	self.active = true

	self.id = #bloodParticles + 1

	table.insert(bloodParticles, self)
end

function blood:update(dt)
	if self.active then 
		self.x = self.x + self.xvel * dt
		self.y = self.y + self.yvel * dt

		if self.xvel > 0 then 
			self.xvel = self.xvel - 40*dt
		else
			self.xvel = self.xvel + 40*dt
		end

		self.yvel = self.yvel + 60*dt

		if self.yvel >= 0 then 
			self.active = false
		end
	end
end

function blood:draw()
	love.graphics.setColor(colors[self.color])
	love.graphics.draw(bloodImage, self.x, self.y)
	love.graphics.setColor(1,1,1)
end

function updateBlood(dt)
	for i,v in pairs(bloodParticles) do
		v:update(dt)
	end
end

function drawBlood()
	for i,v in pairs(bloodParticles) do
		v:draw()
	end
end