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
    scaleObject('healthBar', 0.75, 3.5)
    setProperty('healthBar.x', 115)
end