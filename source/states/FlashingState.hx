package states;

import flixel.FlxSubState;

import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	var enter:FlxSprite;
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"Warning\nThis mod contains some flashing lights\nAlso adjust your volume so your ears don't explode",
			20);
		warnText.setFormat(Paths.font('akira.otf'), 30, FlxColor.WHITE, CENTER);
		warnText.antialiasing = true;
		warnText.screenCenter();
		add(warnText);

		enter = new FlxSprite(1070, 500).loadGraphic(Paths.image('menus/enter'));
		enter.antialiasing = true;
		enter.scale.set(0.4, 0.4);
		add(enter);
	}
	override function update(elapsed:Float)
	{
		if(!leftState) {
			if (controls.ACCEPT) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;

				FlxG.camera.flash(0x85FFFFFF, 0.5);
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
				enter.scale.set(0.5, 0.5);
				FlxTween.tween(enter.scale, {x:0.4, y:0.4}, 0.3, {ease:FlxEase.quadInOut,
				onComplete: function (twn:FlxTween)
				{
					FlxTween.tween(enter, {y:700}, 0.7);
				}});
				FlxTween.tween(warnText, {y: 800}, 1.1, {
					ease:FlxEase.quadInOut,
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new TitleState());
					},
					startDelay: 0.2
				});
			}
		}
		super.update(elapsed);
	}
}
