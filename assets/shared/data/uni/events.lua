local path = 'backgrounds/room/events/'

function onCreatePost()

    makeLuaSprite('gradient', path..'gradient thing', 0, 0)
    setProperty('gradient.alpha', 0.5)
    scaleObject('gradient', 0.8, 0.8)
    addLuaSprite('gradient', true)
    setProperty('gradient.visible', false)

    makeLuaSprite('light', path..'light', 100, 0)
    setProperty('light.alpha', 0.6)
    scaleObject('light', 0.8, 0.8)
    setBlendMode('light', 'add')
    addLuaSprite('light', true)
    setProperty('light.visible', false)

    makeLuaSprite('black', '', 0, 0)
    makeGraphic('black', 1280, 720, '000000')
    setObjectCamera('black', 'camHUD')
    addLuaSprite('black')

end

function onBeatHit()
    if curBeat == 31 then
        camZoom(1.0, 0.5)
    elseif curBeat == 32 then
        camZoom(0.8, 0.7)
    elseif curBeat == 96 or curBeat == 112 then
        camZoom(0.9, 0.5)
    elseif curBeat == 104 or curBeat == 120 or curBeat == 224 then
        camZoom(1.0, 0.4)
    elseif curBeat == 128 then
        camZoom(1.2, 1)
        lights(true)
    elseif curBeat == 159 then
        triggerEvent('Camera Follow Pos', 780, 840)
        camZoom(1.3, 0.2)
    elseif curBeat == 160 then
        triggerEvent('Camera Follow Pos')
        camZoom(0.8, 0.7)
        lights(false)
    end

end

function onSongStart()
    doTweenAlpha('blacktween', 'black', 0, 8)
    setProperty('camGame.zoom', 1.2)
    camZoom(0.8, 8)
end


-- the dumb events --

function camZoom(value, time)
    doTweenZoom('breh', 'camGame', value, time, 'quadInOut')
end

function onTweenCompleted(n)
    if n == 'breh' then
        setProperty('defaultCamZoom',getProperty('camGame.zoom'))
    end
end

function lights(h)
    if flashingLights then
        cameraFlash('camGame', 'FFFFFF', 1)
        if h == true then
            setProperty('gradient.visible', true)
            setProperty('light.visible', true)
        else
            setProperty('gradient.visible', false)
            setProperty('light.visible', false)
        end
    end
end