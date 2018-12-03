player = class("player")

local playerFilter = function(item, other) 
	if other.type == "bullet" or other.type == "ammo" then 
		return "cross"
	else
		return "slide"
	end
end

local playerShootSound = love.audio.newSource("assets/sfx/sounds/playerShoot.wav", "static")
local ammoSound = love.audio.newSource("assets/sfx/sounds/ammo.wav", "static")

function player:initialize()
	self.x = 1600
	self.y = 1600

	self.width = 37
	self.height = 21

	self.rotation = 0

	self.speed = 300

	self.image = love.graphics.newImage("assets/gfx/sprites/player.png")

	self.bulletCooldown = 0
	self.hitCooldown = 0

	self.health = 5

	self.ammo = 256

	self.type = "player"

	self.kills = 0

	collisionWorld:add(self, self.x, self.y, self.width, self.height)
end

function player:update(dt)
	self:control(dt)

	local x, y = camera:mousePosition()
	self.rotation = math.atan2(y - self.y, x - self.x) + 30

	self.bulletCooldown = self.bulletCooldown - dt
	self.hitCooldown = self.hitCooldown - dt
end

function player:draw()
	love.graphics.draw(self.image, self.x + 18, self.y + 10, self.rotation, 1, 1, self.image:getWidth()/2, 10)
end



function player:control(dt)
	if game.level < 3 then 
		if love.keyboard.isDown("w") then 
			self.y = self.y - self.speed*dt
		end
		if love.keyboard.isDown("a") then 
			self.x = self.x - self.speed*dt
		end
		if love.keyboard.isDown("s") then 
			self.y = self.y + self.speed*dt
		end
		if love.keyboard.isDown("d") then 
			self.x = self.x + self.speed*dt
		end
	end

	local actualX, actualY, cols, len = collisionWorld:move(self, self.x, self.y, playerFilter)

	self.x = actualX
	self.y = actualY


	if #cols > 0 then --Handle collisions
		for i,v in pairs(cols) do
			if v.other.type == "ammo" then
				self.ammo = self.ammo + 64
				if self.ammo > 256 then 
					self.ammo = 256
				end
				v.other:destroy()

				if game.level == 0 then 
					ammoSound:play()
				end
			end
		end	
	end

	if love.mouse.isDown(1) then 
		self:fire()
	end
end	

function player:fire()
	if self.bulletCooldown <= 0 and self.ammo >= 1 then 
		bullet:new(self.x + 10*math.cos(self.rotation - 30), self.y + 10*math.sin(self.rotation-30), self.rotation - 30)
		self.bulletCooldown = 0.1
		self.ammo = self.ammo - 1

		if game.level == 0 then 
			playerShootSound:play()
		end
	end
end