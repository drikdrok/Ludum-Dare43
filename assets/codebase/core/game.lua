game = class("game")

local gradient = love.graphics.newImage("assets/gfx/sprites/gradient.png")
local heartImage = love.graphics.newImage("assets/gfx/sprites/heart.png")

function game:initialize()

	self.width = love.graphics.getWidth()
	self.height = love.graphics.getHeight()

	self.fonts = {}
	self.font = love.graphics.newFont("assets/gfx/fonts/font.ttf", 13)

	self.waveCount = 100
	self.waveStart = 100
	self.waveTimer = 0.4

	self.fadeOutTimer = 0
	self.fadeOut = false

	self.state = "cutscene"

	self.level = 0

	blindShader = love.graphics.newShader[[
		vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
		  vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
		  number average = (pixel.r+pixel.b+pixel.g)/3.0;
		  pixel.r = average;
		  pixel.g = average;
		  pixel.b = average;
		  return pixel;
		}
	]]
end

function game:update(dt)
	if self.state == "playing" then 
		player:update(dt)
		updateBullets(dt)
		updateEnemies(dt)
		updateBlood(dt)
		spawnAmmo(dt)

		self.waveTimer = self.waveTimer - dt

		if self.waveTimer <= 0 and self.waveCount > 0 then
			self.waveTimer = 0.4 
			self.waveCount = self.waveCount - 1
			enemy:new()
		end

		if player.kills >= self.waveStart then 
			self.fadeOut = true
		end

		if self.fadeOut then 
			self.fadeOutTimer = self.fadeOutTimer + dt
			if self.fadeOutTimer > 1.3 then
				cutscene:start()
			end	
		end

	elseif self.state == "cutscene" then 
		cutscene:update(dt)
	end
end

function game:draw()
	if self.state == "playing" then -- Draw everything when playing
		if self.level >= 2 then 
			love.graphics.setShader(blindShader)
		end

		camera:attach()
			
			map:draw()

			drawBlood()

			drawAmmo()

			drawBullets()
		
			player:draw()

			drawEnemies()

		camera:detach()

		love.graphics.draw(heartImage, 1100, 5, 0, 2, 2)

		if self.level >= 2 then 
			love.graphics.setShader()
			love.graphics.setColor(1,1,1, 0.5)
			love.graphics.draw(gradient, 0, 0)
		end

		love.graphics.setColor(198/255, 19/255, 19/255)
		game:fontSize(50)
		love.graphics.print(self.waveStart - player.kills.." Souls Left", findMiddle(self.waveStart - player.kills.." Souls Left"), 40)

		game:fontSize(30)
		love.graphics.print(self.level.." Sacrifices Made")
		love.graphics.setColor(1,1,1)

		love.graphics.print(player.health.."/5", 1150, 0)
		love.graphics.print(player.ammo.."/256", 1150, 25)


		if self.fadeOut then 
			love.graphics.setColor(0,0,0,self.fadeOutTimer)
			love.graphics.rectangle("fill", 0, 0, self.width, self.height)
		end
	elseif self.state == "cutscene" then  -- Cutscenes
		cutscene:draw()

	end
end

function game:newLevel()
	self.state = "playing"
	self.waveCount = 100
	player.x = 1600
	player.y = 1600
	player.ammo = 256
	player.health = 5
	player.kills = 0

	collisionWorld:update(player, player.x, player.y)

	for i,v in pairs(enemies) do
		collisionWorld:remove(v)
		enemies[v.id] = nil
	end
	for i,v in pairs(bullets) do
		v:remove()
	end
	for i,v in pairs(ammos) do
		v:destroy()
	end

	self.fadeOut = false
	self.fadeOutTimer = 0

end



function game:fontSize(size)
	if self.fonts[size] == nil then 
		local font = love.graphics.newFont("assets/gfx/fonts/font.ttf", size)
		self.fonts[size] = font
	end	

	love.graphics.setFont(self.fonts[size])
	self.font = self.fonts[size]
end

function findMiddle(text) -- Returns x coordinate for text to be centered on screen
	return game.width/2 - game.font:getWidth(text) / 2
end