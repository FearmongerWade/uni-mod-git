local path = 'backgrounds/fnaf4/'
danced = false

function onCreatePost()

    -- ASSETS --

    makeLuaSprite('bg', path..'freddyfivebear', 0, 0)
    addLuaSprite('bg')

    makeLuaSprite('clickable', '', 670, 310)
    makeGraphic('clickable', 34, 16, 'FFFFFF')
    --setProperty('clickable.alpha', 0.0001)
    addLuaSprite('clickable')

    makeAnimatedLuaSprite('girlfr', path..'littlegf', 860, 340)
    addAnimationByIndices('girlfr', 'left', 'gf dance', '0,1,2,3,4,5,6,7,8,9', 16, true)
    addAnimationByIndices('girlfr', 'right', 'gf dance', '10,11,12,13,14,15,16,17,18,19', 16, true)
    setProperty('girlfr.antialiasing', false)
    addLuaSprite('girlfr', true)

    -- Yeah --

    triggerEvent('Camera Follow Pos', 670, 350)
end

function onBeatHit()
    animToPlay = 'right'

    if danced then
        animToPlay = 'left'
    end

    playAnim('girlfr', animToPlay, true)
    danced = not danced

end
