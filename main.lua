function love.load()
    Game = {}
    Game.state = 1

    Target = {}
    Target.x = 300
    Target.y = 300

    Target.radius = 50

    Score = 0
    Timer = 0

    Sprites = {}
    Sprites.sky = love.graphics.newImage('sprites/sky.png')
    Sprites.target = love.graphics.newImage('sprites/target.png')
    Sprites.crosshairs = love.graphics.newImage('sprites/crosshairs.png')

    love.mouse.setVisible(false)
end

-- dt stands for delta time
function love.update(dt)
    if Game.state == 2 then
        if Timer > 0 then
            Timer = Timer - dt
        end

        if Timer < 0 then
            Timer = 0
            Game.state = 1
        end
    end
end

-- draw and update run on every frame
function love.draw()
    love.graphics.draw(Sprites.sky, 0, 0)

    SetFontSize(40)
    SetColor(255, 255, 255)
    -- love.graphics.print(Score, 15, 0)
    love.graphics.print("Score: " .. Score, 0, 0)
    love.graphics.print("Remaining: " .. math.ceil(Timer), love.graphics.getWidth() / 1.6, 0)

    if Game.state == 1 then
        love.graphics.printf("Click anywhere to begin!", 0, 250, love.graphics.getWidth(), 'center')
    end

    if Game.state == 2 then
        love.graphics.draw(Sprites.crosshairs, love.mouse.getX() - 20, love.mouse.getY() - 20)
        love.graphics.draw(Sprites.target, Target.x - Target.radius, Target.y - Target.radius)
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    local mouseToTarget = CalcMouseDistance(x, Target.x, y, Target.y)
    if Game.state == 2 and mouseToTarget < Target.radius then
        if button == 1 then
            Score = Score + 1
            Target.x = math.random(Target.radius, love.graphics.getWidth() - Target.radius)
            Target.y = math.random(Target.radius, love.graphics.getHeight() - Target.radius)
        elseif button == 2 then
            if mouseToTarget < Target.radius then
                Score = Score + 2
                Timer = Timer - 1
                Target.x = math.random(Target.radius, love.graphics.getWidth() - Target.radius)
                Target.y = math.random(Target.radius, love.graphics.getHeight() - Target.radius)
            end
        end
    elseif Score > 0 then
        Score = Score - 1
    end

    if Game.state == 1 then
        Timer = 30
        Score = 0
        Game.state = 2
    end
end

function CalcMouseDistance(x1, x2, y1, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function SetColor(r, g, b)
    love.graphics.setColor(r / 255, g / 255, b / 255)
end

function SetFontSize(size)
    love.graphics.setFont(love.graphics.newFont(size))
end
