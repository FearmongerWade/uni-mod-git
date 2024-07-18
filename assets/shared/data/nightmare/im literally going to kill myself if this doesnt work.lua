local path = 'backgrounds/fnaf4/'
danced = false

function onCreatePost()
    makeAnimatedLuaSprite('grill', path..'littlegf', 860, 340)
    addAnimationByIndices('grill', 'left', 'gf dance', '0,1,2,3,4,5,6,7,8,9', 16, true)
    addAnimationByIndices('grill', 'right', 'gf dance', '10,11,12,13,14,15,16,17,18,19', 16, true)
    setProperty('grill.antialiasing', false)
    addLuaSprite('grill', true)

    triggerEvent('Camera Follow Pos', 670, 350)
end

function onBeatHit()
    animToPlay = 'right'

    if danced then
        animToPlay = 'left'
    end

    playAnim('grill', animToPlay, true)
    danced = not danced

    if curBeat == 224 then
        doTweenZoom('b', 'camGame', 1.6, 0.3, 'quadInOut')
    end
end

function onTweenCompleted(n)
    if n == 'b' then
        setProperty('defaultCamZoom',getProperty('camGame.zoom'))
    end
end