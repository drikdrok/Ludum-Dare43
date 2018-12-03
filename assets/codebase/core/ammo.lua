ammo = class("ammo")

ammos = {}

local ammoImage = love.graphics.newImage("assets/gfx/sprites/ammo.png")

local ammoSpawnTimer = 0

function ammo:initialize()
	self.x = math.random(765, 2330)
	self.y = math.random(830, 2030)

	self.width = 20
	self.height = 28

	self.type = "ammo"

	self.id = #ammos + 1


	collisionWorld:add(self, self.x, self.y, self.width, self.height)

	local actualX, actualY, cols, len = collisionWorld:move(self, self.x, self.y) --Moves the ammo if it spawns inside another solid (a wall)
	self.x = actualX
	self.y = actualY

	table.insert(ammos, self)
end

function ammo:draw()
	love.graphics.setColor(1,1,1)
	love.graphics.draw(ammoImage, self.x, self.y, 0, 2, 2)
end

function ammo:destroy()
	collisionWorld:remove(self)
	ammos[self.id] = nil
end

function drawAmmo()
	for i,v in pairs(ammos) do
		v:draw()
	end 
end	

function spawnAmmo(dt)
	if #ammos <= 3 then 
		ammoSpawnTimer = ammoSpawnTimer + dt
		if ammoSpawnTimer >= 6.5 then 
			ammo:new()
			ammoSpawnTimer = 0
		end
	end
end