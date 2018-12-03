love.graphics.setDefaultFilter("nearest", "nearest")
math.randomseed(os.time())

require("assets/codebase/core/require")

debug = false

function love.load()
	collisionWorld = bump.newWorld()
	
	game = game:new()
	player = player:new()
	map = map:new("map")
	cutscene = cutscene:new()
	cutscene:music(true)

	camera = Camera(0, 0)
	camera:zoom(1.2)
	camera.smoother = camera.smooth.damped(6)

end

function love.update(dt)
	game:update(dt)

	camera:lockX(player.x)
	camera:lockY(player.y)
end

function love.draw()
	game:draw()

	if debug then 
		love.graphics.print(love.timer.getFPS())

		local items, len = collisionWorld:getItems()

		for i, v in pairs(items) do
			camera:attach()
				love.graphics.rectangle("line", v.x, v.y, v.width, v.height)
			camera:detach()
		end	
	end
end

function love.keypressed(key)
	if key == "escape" then 
		love.event.quit()
	elseif key == "f1" then 
	---	debug = not debug
	end
end