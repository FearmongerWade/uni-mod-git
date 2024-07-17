function onCreatePost()
    for i = 0,3 do
        setPropertyFromGroup('strumLineNotes', i, 'x', -500)
    end

    setPropertyFromGroup('strumLineNotes', 4, 'x', 412)
    setPropertyFromGroup('strumLineNotes', 5, 'x', 524)
    setPropertyFromGroup('strumLineNotes', 6, 'x', 636)
    setPropertyFromGroup('strumLineNotes', 7, 'x', 748)

    setProperty('iconP1.alpha', 0.000001)
    setProperty('iconP2.alpha', 0.000001)

    setProperty('healthBar.bg.visible', false)
    scaleObject('healthBar', 0.75, 3.5, true)
    setProperty('healthBar.x', 115)

    setProperty('scoreTxt.alpha', 0.00001)

    makeLuaSprite('hpBar', 'backgrounds/rooftop/hpBar', 0, 20)
    setObjectCamera('hpBar', 'camHUD')
    screenCenter('hpBar', 'x')
    addLuaSprite('hpBar', true)

    makeLuaText('score', 'Score: '..songScore, 0, 0)
    setObjectCamera('score', 'camHUD')
    screenCenter('score', 'x')
    addLuaText('score')

    if downscroll then
        setProperty('hpBar.y', 20)
        setProperty('healthBar.y', 8)
        setProperty('score.y', getProperty('hpBar.y')+40)
    else 
        setProperty('hpBar.y', 590)
        setProperty('healthBar.y', 608)
    end
end