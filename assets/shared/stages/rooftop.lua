local path = 'backgrounds/rooftop/'

function onCreatePost()

    -- ASSETS --

    makeLuaSprite('bg1', path..'sky', 0,200)
    setScrollFactor('bg1', 0.7, 1.0)
    addLuaSprite('bg1', false)

    makeLuaSprite('bg2', path..'bg', 0,200)
    addLuaSprite('bg2', false)

    makeAnimatedLuaSprite('bf pico', path..'silly', 380,250)
    addAnimationByPrefix('bf pico', 'idle', 'bfpico', 24, false)
    addLuaSprite('bf pico', false)

    makeLuaSprite('bars', path..'bars', 0,0)
    setObjectCamera('bars', 'camHUD')
    addLuaSprite('bars')

end

function onBeatHit()
    if curBeat % 2 == 0 then
        playAnim('bf pico', 'idle')
    end
end