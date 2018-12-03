map = class("map")

function map:initialize(m)
	self.data = require("assets/maps/"..m)

	self.canvases = {}
	self.solids = {}

	self.tileset = tileset:new("assets/gfx/sheets/tileset.png")

	for i, v in pairs(self.data.layers) do
		if v.type == "tilelayer" then 
			self:createStaticCanvas(v)
		elseif v.type == "objectgroup" then 
			self:createSolids(v)
		end
	end
end

function map:draw()
	love.graphics.setColor(1,1,1)
	
	for i,v in pairs(self.canvases) do
		love.graphics.draw(v, 0, 0)
	end
end

function map:createStaticCanvas(layer)
	local canvas = love.graphics.newCanvas(layer.width*16, layer.height*16)

	love.graphics.setCanvas(canvas)
	love.graphics.setColor(1,1,1)

	for y = 0, layer.height do
		for x = 0, layer.width do
			local index = layer.data[y * layer.width + x + 1]

			if index ~= nil then 
				local quad = self.tileset.quads[index]

				love.graphics.draw(self.tileset.image, quad, x*16, y*16)
			end
		end
	end

	love.graphics.setCanvas()

	table.insert(self.canvases, canvas)
end

function map:createSolids(layer)
	for i,v in pairs(layer.objects) do
		local object = {x = v.x, y = v.y, width = v.width, height = v.height}
		collisionWorld:add(object, object.x, object.y, object.width, object.height)

		table.insert(self.solids, object)
	end
end