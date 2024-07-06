package states;

import flixel.addons.transition.FlxTransitionableState;

class TitleState extends MusicBeatState
{
	override public function create():Void
	{
		Paths.clearStoredMemory();
		FlxG.mouse.visible = false;

		super.create();

		if(FlxG.save.data.flashing == null && !FlashingState.leftState) 
		{
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		}
		else 
		{
			new FlxTimer().start(1, function(tmr:FlxTimer) {
				startIntro();
			});
		}
	}

	var oneboob:FlxSprite;
    var twoboob:FlxSprite;
    var titleText:FlxText;
    var enter:FlxText;
    var gradient:FlxSprite;

    var path:String = "menus/title/";

	function startIntro()
	{
		FlxG.sound.play(Paths.music('titleMenu'));

		persistentUpdate = true;

		oneboob = new FlxSprite().loadGraphic(Paths.image(path + FlxG.random.int(1, 21)));
        oneboob.antialiasing = true;
        oneboob.alpha = 0;
        add(oneboob);

        twoboob = new FlxSprite().loadGraphic(Paths.image(path + FlxG.random.int(1, 21)));
        twoboob.antialiasing = true;
        twoboob.alpha = 0;
        add(twoboob); 

        titleText = new FlxText(0, 50, 0, 'UNI MOD', 110);
        titleText.font = Paths.font('DoubleFeature20.ttf');
        titleText.color = 0xFFFF0000;
        titleText.antialiasing = true;
        titleText.screenCenter(X);
        titleText.alpha = 0;
        add(titleText);

        enter = new FlxText(0, 600, 0, 'Press ENTER to continue', 45);
        enter.font = Paths.font('DoubleFeature20.ttf');
        enter.color = 0xFFFF0000;
        enter.antialiasing = true;
        enter.screenCenter(X);
        enter.alpha = 0;
        add(enter);

        gradient = new FlxSprite().loadGraphic(Paths.image(path + 'scary'));
        gradient.antialiasing = true;
        add(gradient);

		// Tweens and timers

        new FlxTimer().start(1.38, function(tmr:FlxTimer){
            FlxTween.tween(oneboob, {alpha: 1}, 1.1);
        });

        new FlxTimer().start(4.21, function(tmr:FlxTimer){
            FlxTween.tween(oneboob, {alpha: 0}, 1.5);
        });

        new FlxTimer().start(9, function(tmr:FlxTimer){
            FlxTween.tween(twoboob, {alpha:1}, 1.1);
        });

        new FlxTimer().start(11.3, function(tmr:FlxTimer){
            FlxTween.tween(enter, {alpha:1}, 1.4);
            FlxTween.tween(titleText, {alpha:1}, 1.4);
        });

		Paths.clearUnusedMemory();
	}

	var transitioning:Bool = false;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

        if (controls.ACCEPT && !transitioning)
		{
            FlxG.sound.play(Paths.sound('confirmMenu'));
            FlxG.camera.flash(FlxColor.WHITE, 1);
			transitioning = true;

            new FlxTimer().start(2, function(tmr:FlxTimer){
                MusicBeatState.switchState(new MainMenuState());
                FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.8);
            });
        }
		super.update(elapsed);
	}
}
