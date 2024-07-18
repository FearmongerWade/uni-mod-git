function onCreatePost()
    setProperty('camGame.alpha', 0.00001)
end

function onBeatHit()
    if curBeat == 8 then
        setProperty('camGame.alpha', 1)
    elseif curBeat == 152 then
        camZoom(1.07)
    elseif curBeat == 156 then
        camZoom(1.12)
    elseif curBeat == 160 then
        camZoom(1.17)
    elseif curBeat == 164 then
        camZoom(1.22)
    elseif curBeat == 168 then
        camZoom(1.02);
    end
end

function camZoom(value)
    doTweenZoom('breh', 'camGame', value, 0.5, 'easeInOut')
end

function onTweenCompleted(n)
    if n == 'breh' then
        setProperty('defaultCamZoom',getProperty('camGame.zoom'))
    end
end