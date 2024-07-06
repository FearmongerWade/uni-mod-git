local path = 'backgrounds/room/'

function onCreatePost()

    -- ASSETS --

    makeLuaSprite('bg', path..'bg', 0, 20)
    scaleObject('bg', 0.8, 0.8)
    addLuaSprite('bg')

    makeAnimatedLuaSprite('tvSprites', path..'tv_sprites', 830, 285)
    addAnimationByPrefix('tvSprites', 'tv1', '1', 24)
    addAnimationByPrefix('tvSprites', 'tv2', '2', 24)
    addAnimationByPrefix('tvSprites', 'tv3', '3', 24)
    addAnimationByPrefix('tvSprites', 'tv4', '4', 24)
    addAnimationByPrefix('tvSprites', 'tv5', '5', 24)
    scaleObject('tvSprites', 0.76, 0.76)
    addLuaSprite('tvSprites')

    makeLuaSprite('tv', path..'tv', 800, 255)
    scaleObject('tv', 0.75, 0.75)
    addLuaSprite('tv')

    -- CATS --

    makeAnimatedLuaSprite('aoba', path..'aoba', 350, 640)
    addAnimationByPrefix('aoba', 'bump', 'aoba', 18)
    scaleObject('aoba', 0.8, 0.8)
    addLuaSprite('aoba')

    makeAnimatedLuaSprite('sora', path..'sora', 1260, 910)
    addAnimationByPrefix('sora', 'bump', 'sora', 18)
    scaleObject('sora', 0.8, 0.8)
    addLuaSprite('sora')

    makeAnimatedLuaSprite('yoru', path..'yoru', 1750, 1010)
    addAnimationByPrefix('yoru', 'bump', 'yoru', 18)
    scaleObject('yoru', 0.8, 0.8)
    addLuaSprite('yoru')

end

function onBeatHit()
    
    if curBeat % 4 == 0 then
        playAnim('tvSprites', 'tv'..getRandomInt(1, 5))
    end

    if curBeat % 2 == 0 then
        playAnim('aoba', 'bump')
        playAnim('sora', 'bump')
        playAnim('yoru', 'bump')
    end

end