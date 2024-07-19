package substates.gameover;

class Jumpscare extends MusicBeatSubstate
{
    var path:String = 'backgrounds/fnaf4/death/';
    var dead:Bool = false;
    var shaketween:FlxTween;

    override function create() 
    {
        Conductor.songPosition = 0;
        FlxG.camera.zoom = 1;
        FlxG.mouse.visible = false;

        var bgDark = new FlxSprite().loadGraphic(Paths.image(path+'roomDark'));
        bgDark.scrollFactor.set();
        bgDark.alpha = 0.00001;
        add(bgDark);

        var bgLit = new FlxSprite().loadGraphic(Paths.image(path+'roomLit'));
        bgLit.scrollFactor.set();
        bgLit.alpha = 0.00001;
        add(bgLit);

        var scary = new FlxSprite(570, 205).loadGraphic(Paths.image(path+'scary guy'));
        scary.scrollFactor.set();
        scary.alpha = 0.00001;
        add(scary);
        shaketween = FlxTween.shake(scary, 0.01, 2, {type:LOOPING});

        var jumpscare = new FlxSprite(160, 20);
        jumpscare.frames = Paths.getSparrowAtlas(path+'jumpscare');
        add(jumpscare);
        jumpscare.scale.set(1.2, 1.2);
        jumpscare.scrollFactor.set();
        jumpscare.alpha = 0.00001;
        jumpscare.animation.addByPrefix('die', 'jumpscareanim', 24, false);

        var actualDeath = new FlxSprite(50, -30).loadGraphic(Paths.image(path+'ow'));
        actualDeath.alpha = 0.00001;
        actualDeath.scrollFactor.set();
        actualDeath.antialiasing = true;
        actualDeath.screenCenter();
        add(actualDeath);

        // this is where the magic begins

        new FlxTimer().start(2, function(tmr:FlxTimer)
        {
            FlxG.sound.play(Paths.sound('nightmareDeath'));
            bgDark.alpha = 1;

            new FlxTimer().start(3.48, function (tmr:FlxTimer) {
                bgLit.alpha = 1;
            });

            new FlxTimer().start(6.48, function (tmr:FlxTimer) {
                bgLit.alpha = 0.000001;
            });

            new FlxTimer().start(9.48, function (tmr:FlxTimer) {
                bgLit.alpha = 1;
                scary.alpha = 1;
            });

            new FlxTimer().start(11.7, function (tmr:FlxTimer) {
                FlxTween.tween(scary, {x: -500}, 0.2, {ease: FlxEase.elasticInOut});
            });

            new FlxTimer().start(13.01, function (tmr:FlxTimer) {
                bgLit.alpha = 0.00011;
            });

            new FlxTimer().start(16.01, function (tmr:FlxTimer) {
                bgLit.alpha = 1;
            });

            new FlxTimer().start(16.42, function (tmr:FlxTimer) {
                jumpscare.alpha = 1;
                jumpscare.animation.play('die');
            });
            
            new FlxTimer().start(18.42, function (tmr:FlxTimer) {
                jumpscare.alpha = 0.00001;
                actualDeath.alpha = 1;
                FlxG.camera.flash(FlxColor.WHITE, 2.5);
                dead = true;
            });
        });

        super.create();
    }
    
    var isEnding:Bool = false;
    override function update(elapsed:Float) 
    {
        super.update(elapsed);

        if (dead)
        {
            if (controls.ACCEPT)
            {
                if (!isEnding)
                {
                    isEnding = true;
                    shaketween.cancel();
                    FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				    {
				    	MusicBeatState.resetState();
				    });
                }
            }

            if (controls.BACK)
            {
                #if DISCORD_ALLOWED DiscordClient.resetClientID(); #end
                PlayState.deathCounter = 0;
                PlayState.seenCutscene = false;
                PlayState.chartingMode = false;
                shaketween.cancel();

                MusicBeatState.switchState(new states.MainMenuState());

                FlxG.sound.playMusic(Paths.music('freakyMenu'), ClientPrefs.data.musicVolume);
            }
        }    
    }
}