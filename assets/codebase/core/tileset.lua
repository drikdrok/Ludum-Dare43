tileset = class("tileset")

function tileset:initialize(image)
	self.image = love.graphics.newImage(image)
	self.quads = {}

	for y = 0, self.image:getHeight()/16 do
		for x = 0, self.image:getWidth()/16 do
			local quad = love.graphics.newQuad(x*16, y*16, 16, 16, self.image:getWidth(), self.image:getHeight())
			table.insert(self.quads, quad)
		end
	end
end