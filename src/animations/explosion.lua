local sqrt = math.sqrt
local WHITE = Color(255,255,255):rgba()
local Point = game.objects.Vector2d

local ExplosionAnimation = game.animation_engine.Animation:extend()
game.animations.ExplosionAnimation = ExplosionAnimation

local LIFE = 2
local function last(list)
    return list[#list]
end

local function hasLOS(map, from, to)
    local points = game.util.traceLine(from.x, from.y, to.x, to.y)
    for i,p in ipairs(points) do
        if map:getUpper(p[1], p[2]).is_solid then
            return false 
        end
    end
    return true
end

function ExplosionAnimation:new(x, y, radius)
    ExplosionAnimation.super.new(self, 'ExplosionAnimation_' .. string.random(10))
    self.x = x
    self.y = y
    self.radius = math.ceil(radius)
    self.life = LIFE
    self.frames_per_life = 6
    self.frame_count = 0
    self.explosion_sprite = game.sprites.get('crash/tg_fx/tg_fx_fireimpact_1')
    self.light = (Color.fromStr('yellow') * 0.8):rgba()
end

local floor = math.floor
function ExplosionAnimation:drawParticle(canvas, x, y)
    canvas:putWithColor(floor(self.x + x), floor(self.y + y), self.sprite, self.color)
end
   
function ExplosionAnimation:draw(canvas)

    local v = {
        sprite=self.explosion_sprite + (LIFE - self.life),
        color=WHITE,
        light=self.light
    }

    local R = self.radius

    for i = -R, R do
        for j = -R, R do
            if sqrt(i * i + j * j) <= R then
                if hasLOS(game.world.map(), Point(self.x, self.y), Point(self.x+i, self.y+j)) then
                    canvas:putVisual(self.x + i, self.y + j, v)
                end
            end
        end
    end

    self.frame_count = self.frame_count+1
    if self.frame_count % self.frames_per_life == 0 then
        self.life = self.life - 1
    end
    self.radius = math.max(2, self.radius - 1)
end

function ExplosionAnimation:done()
    return self.life < 0
end

return ExplosionAnimation