cutscene = class("cutscene")

local soundtrack = love.audio.newSource("assets/sfx/soundtrack.wav", "static")
soundtrack:setLooping(true)

function cutscene:initialize()
	self.timer = 0 
	self.stage = 1

	self.timerDir = 1

	self.text = {

	{"So the deal is done...", 3}, 
	{"Finish the job and you shall have salvation in time...", 4},
	
	{"You have done well...", 3},
	{"For the deal to go through, I will need your hearing...", 4.5},

	{"Good...", 3},
	{"For the deal to go through, I will need your sight...", 4.5},

	{"You are close now...", 3},
	{"But for the deal to go through, I will need your legs...", 4.5},
	
	{"You fool...", 3},
	{"You sacrificed everything for me...", 4.5},
	{"But at what cost...", 5},

	{"Thanks for playing!", 4.5},
	{"Made by Christian Schwenger for Ludum Dare 43", 8},
	{"Goodbye!", 8},


	{"You failed to live up to the deal...", 3.2},
	{"Don't fail again...", 3}
	}
end

function cutscene:update(dt)
	self.timer = self.timer * self.timerDir + dt
	if self.timer >= self.text[self.stage][2] then 
		self.timerDir = -1
	end

	if self.timer < 0 then 
		self.timer = 0 
		self.stage = self.stage + 1
		self.timerDir = 1

		if self.stage == 3 then 
			game.state = "playing"
		elseif self.stage == 5 then 
			game.level = 1
			game:newLevel()
		elseif self.stage == 7 then 
			game.level = 2
			game:newLevel()
		elseif self.stage == 9 then 
			game.level = 3
			game:newLevel()
		elseif self.stage == 14 then 
			love.event.quit()
		elseif self.stage == 17 then 
			game:newLevel()
		end
	end

end

function cutscene:draw()
	love.graphics.setColor(1,1,1, self.timer)
	game:fontSize(30)
	
	if self.text[self.stage] == nil then 	
		error("self.text[self.stage] = nil. Stage = "..self.stage)
	else
		love.graphics.print(self.text[self.stage][1], findMiddle(self.text[self.stage][1]), 200)
	end
end

function cutscene:start(stage)
	if stage == "dead" then 
		self.stage = 15
	elseif game.level == 0 then 
		self.stage = 3
	elseif game.level == 1 then
		self.stage = 5
	elseif game.level == 2 then 
		self.stage = 7
	elseif game.level == 3 then 
		self.stage = 9
	elseif game.level == 4 then 
		self.stage = 10 
	end

	game.state = "cutscene"
end

function cutscene:music(bool)
	if bool then 
		soundtrack:play()
	else
		soundtrack:stop()
	end
end