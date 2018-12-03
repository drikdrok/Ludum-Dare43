bullet = class("bullet")
bullets = {}

bulletImage = love.graphics.newImage("assets/gfx/sprites/bullet.png")

local bulletFilter = function(item, other) 
	if other.type == "player" or other.type == "ammo" then 
		return "cross"
	else
		return "slide"
	end
end

function bullet:initialize(x, y, angle)
	self.x = x
	self.y = y

	self.width = 4
	self.height = 2

	self.speed = 500

	self.angle = angle

	self.dx = self.speed * math.cos(self.angle)
	self.dy = self.speed * math.sin(self.angle)

	self.age = 0

	self.id = #bullets + 1

	self.type = "bullet"

	collisionWorld:add(self, self.x, self.y, self.width, self.height)
	table.insert(bullets, self)
end

function bullet:update(dt)
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt

	self.age = self.age + dt
	
	local actualX, actualY, cols, len  = collisionWorld:move(self, self.x, self.y, bulletFilter)

	if #cols > 0 then 
		for i,v in pairs(cols) do
			if v.other.type ~= "player" and v.other.type ~= "ammo" then  
				if v.other.type == "enemy" then 
					v.other:hit()
				end	
				self:remove()
			end
		end	
	end	
end

function bullet:draw()
	love.graphics.draw(bulletImage, self.x, self.y, self.angle)
end

function bullet:remove()
	if collisionWorld:hasItem(self) then 
		collisionWorld:remove(self)
	end
	bullets[self.id] = nil
end

function updateBullets(dt)
	for i,v in pairs(bullets) do
		if v.age >= 5 then 
			v:remove()
		else
			v:update(dt)
		end
	end
end

function drawBullets()
	for i,v in pairs(bullets) do
		v:draw()
	end
end

