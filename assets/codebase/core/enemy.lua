enemy = class("enemy")
enemies = {}

local enemyImage = love.graphics.newImage("assets/gfx/sheets/enemy.png")
local enemyQuads = {
		love.graphics.newQuad(0, 0, 15, 28, enemyImage:getWidth(), enemyImage:getHeight()),
		love.graphics.newQuad(15, 0, 15, 28, enemyImage:getWidth(), enemyImage:getHeight()),
		love.graphics.newQuad(30, 0, 15, 28, enemyImage:getWidth(), enemyImage:getHeight()),
		love.graphics.newQuad(45, 0, 15, 28, enemyImage:getWidth(), enemyImage:getHeight()),
}


local enemyDieSound = love.audio.newSource("assets/sfx/sounds/enemyDie.wav", "static")
local playerHitSound = love.audio.newSource("assets/sfx/sounds/playerHit.wav", "static")

local enemyFilter = function(item, other) 
	if other.type == "ammo" then 
		return "cross"
	else
		return "slide"
	end
end

function enemy:initialize(x, y)
	--Decide spawn area
	local spawnsX = {math.random(770, 950), math.random(2270, 2330)}
	local spawnsY = {math.random(845, 960), math.random(1920, 2025)}

	self.x = x or spawnsX[math.random(1,2)]
	self.y = y or spawnsY[math.random(1,2)]

	self.width = 25
	self.height = 30

	self.kind = 1 

	self.speed = math.random(35, 60)
	self.health = 2

	self.direction = 1

	self.currentQuad = enemyQuads[1]

	local n = math.random(1, 6)

	if n == 3 then 
		self.kind = 2
		self.speed = 75
		self.health = 3
		self.currentQuad = enemyQuads[2]
	end



	self.type = "enemy"
	self.id = #enemies + 1

	collisionWorld:add(self, self.x, self.y, self.width, self.height)

	table.insert(enemies, self)
end

function enemy:update(dt)

	if self.y < player.y then 
		self.y = self.y + self.speed*dt
	end
	if self.y > player.y then 
		self.y = self.y - self.speed*dt
	end
	if self.x < player.x then 
		self.x = self.x + self.speed*dt
		self.direction = 2
	end
	if self.x > player.x then 
		self.x = self.x - self.speed*dt
		self.direction = 1
	end

	local actualX, actualY, cols, len = collisionWorld:move(self, self.x, self.y, enemyFilter)

	self.x = actualX
	self.y = actualY

	if #cols > 0 then 
		for i,v in pairs(cols) do
			if v.other.type == "player" then 
				if player.hitCooldown <= 0 then 
					player.health = player.health - 1
					player.hitCooldown = 0.8

					if player.health <= 0 then 
						if game.level <= 2 then 
							cutscene:start("dead")
						else
							cutscene:start()
						end
					end 

					if game.level == 0 then 
						playerHitSound:play()
					end
				end
			end
		end
	end

	if self.kind == 1 then 
		self.currentQuad = enemyQuads[self.direction]
	else
		self.currentQuad = enemyQuads[self.kind + self.direction]
	end
end

function enemy:draw()
	love.graphics.draw(enemyImage, self.currentQuad, self.x - 5, self.y - 11, 0, 2, 2)
end

function enemy:hit()
	self.health = self.health - 1

	if self.health < 0 then 
		self:die()
	end
end

function enemy:die()
	for i=0, 9 do
		blood:new(self.x, self.y, self.kind)
	end
	collisionWorld:remove(self)
	enemies[self.id] = nil

	player.kills = player.kills + 1

	if game.level == 0 then 
		enemyDieSound:play()
	end

end




function updateEnemies(dt)
	for i,v in pairs(enemies) do
		v:update(dt)
	end
end

function drawEnemies()
	for i,v in pairs(enemies) do
		v:draw()
	end
end