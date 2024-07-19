package substates.gameover;

import objects.Character;

class GameOverBF extends MusicBeatSubstate
{
    var path:String = 'menus/game_over/bf/';
    var curSelected:Int = 0;

    var character:Character;
    var box:FlxSprite;
    var selector:FlxSprite;
    var bump:FlxSprite;

    override function create() 
    {
        Conductor.songPosition = 0;
        Conductor.bpm = 100;
        FlxG.camera.zoom = 1;

        FlxG.sound.play(Paths.sound('bfdies'), ClientPrefs.data.soundVolume);

        character = new Character(640, 50, 'bf-dead', true);
        character.scrollFactor.set();
        add(character);
        character.playAnim('firstDeath');

        bump = new FlxSprite(0, 40);
        bump.frames = Paths.getSparrowAtlas(path+'retry');
        bump.animation.addByPrefix('idle', 'retry bump', 20, false);
        bump.scrollFactor.set();
        bump.alpha = 0;
        add(bump);

        box = new FlxSprite(100, 350).loadGraphic(Paths.image(path+'box'));
        box.scrollFactor.set();
        box.alpha = 0;
        add(box);

        selector = new FlxSprite(130, 435).loadGraphic(Paths.image(path+'arrow'));
        selector.scrollFactor.set();
        selector.alpha = 0;
        add(selector);

        new FlxTimer().start(2, function (tmr:FlxTimer)
        {
            FlxTween.tween(bump, {alpha:1}, 0.4, {ease:FlxEase.quadInOut});
            FlxTween.tween(box, {alpha:1}, 0.4, {ease:FlxEase.quadInOut});
            FlxTween.tween(selector, {alpha:1}, 0.4, {ease:FlxEase.quadInOut});
        });

        super.create();
    }

    public var startedDeath:Bool = false;
    override function update(elapsed:Float) 
    {
        if (FlxG.sound.music.playing)
			Conductor.songPosition = FlxG.sound.music.time;

        super.update(elapsed);

        if (startedDeath)
        {
            if (controls.UI_UP_P)
                changeItem(-1);
    
            if (controls.UI_DOWN_P)
                changeItem(1);
    
            if (controls.ACCEPT)
            {
                switch (curSelected)
                {
                    case 0: 
                        endBullshit();
                    case 1: 
                        #if DISCORD_ALLOWED DiscordClient.resetClientID(); #end
                    FlxG.sound.music.stop();
                    PlayState.deathCounter = 0;
                    PlayState.seenCutscene = false;
                    PlayState.chartingMode = false;
    
                    MusicBeatState.switchState(new states.MainMenuState());
    
                    FlxG.sound.playMusic(Paths.music('freakyMenu'), ClientPrefs.data.musicVolume);
                    
                }
            }
        }
            
        if (character.animation.curAnim != null)
		{
			if (character.animation.curAnim.name == 'firstDeath' && character.animation.curAnim.finished && startedDeath)
				character.playAnim('deathLoop');

			if(character.animation.curAnim.name == 'firstDeath')
			{
				if (character.animation.curAnim.finished && !playingDeathSound)
				{
					startedDeath = true;
					coolStartDeath();
				}
			}
		}
    }

    override function beatHit()
    {
        if (startedDeath)
        {
            if (character != null)
                character.playAnim('deathLoop');
    
            if (bump != null)
                bump.animation.play('idle');
        }
        super.beatHit();
    }

    function changeItem(gwa:Int = 0)
    {
        FlxG.sound.play(Paths.sound('scrollMenu'), ClientPrefs.data.soundVolume);

        curSelected += gwa;

        if (curSelected > 1)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = 1;

        if (curSelected == 0)
            selector.setPosition(130, 435);
        else if (curSelected == 1)
            selector.setPosition(160, 530);
    }

    var isEnding:Bool = false;
    var playingDeathSound:Bool = false;
	function coolStartDeath(?volume:Float = 1):Void
	{
		FlxG.sound.playMusic(Paths.music('toobadBF'), ClientPrefs.data.musicVolume, false);
        FlxG.sound.music.onComplete = endBullshit;
	}

    function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			character.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('retryBF'), ClientPrefs.data.soundVolume);
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					MusicBeatState.resetState();
				});
			});
		}
	}
}