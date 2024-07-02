package substates.gameover;

import backend.WeekData;

import objects.Character;
import flixel.FlxObject;
import flixel.FlxSubState;

import states.StoryMenuState;
import states.FreeplayState;

class BoyfriendGameOver extends MusicBeatSubstate
{
	public var boyfriend:Character;
	var retry:FlxSprite;
	var box:FlxSprite;
	var selector:FlxSprite;

	var path:String = "menus/game_over/boyfriend/";
	var curSelected:Int;

	var camFollow:FlxObject;
	var moveCamera:Bool = false;
	var playingDeathSound:Bool = false;

	var stagePostfix:String = "";

	public static var characterName:String = 'bf-dead';
	public static var deathSoundName:String = 'fnf_loss_sfx';
	public static var loopSoundName:String = 'gameOver';
	public static var endSoundName:String = 'gameOverEnd';

	public static var instance:BoyfriendGameOver;

	public static function resetVariables() {
		characterName = 'bf-dead';
		deathSoundName = 'fnf_loss_sfx';
		loopSoundName = 'gameOver';
		endSoundName = 'gameOverEnd';

		var _song = PlayState.SONG;
		if(_song != null)
		{
			if(_song.gameOverChar != null && _song.gameOverChar.trim().length > 0) characterName = _song.gameOverChar;
			if(_song.gameOverSound != null && _song.gameOverSound.trim().length > 0) deathSoundName = _song.gameOverSound;
			if(_song.gameOverLoop != null && _song.gameOverLoop.trim().length > 0) loopSoundName = _song.gameOverLoop;
			if(_song.gameOverEnd != null && _song.gameOverEnd.trim().length > 0) endSoundName = _song.gameOverEnd;
		}
	}

	var charX:Float = 0;
	var charY:Float = 0;
	override function create()
	{
		instance = this;

		Conductor.songPosition = 0;
		Conductor.bpm = 100;

		retry = new FlxSprite(98, 55);
		retry.frames = Paths.getSparrowAtlas(path + 'retry');
		retry.animation.addByPrefix('idle', 'retry bump', 24, true);
		retry.antialiasing = false;
		retry.scrollFactor.set();
		retry.alpha = 0;
		add(retry);

		box = new FlxSprite(144, 377).loadGraphic(Paths.image(path + 'box'));
		box.antialiasing = false;
		box.scrollFactor.set();
		box.alpha = 0;
		add(box);

		selector = new FlxSprite(180, 450).loadGraphic(Paths.image(path + 'arrow'));
		selector.antialiasing = false;
		selector.scrollFactor.set();
		selector.alpha = 0;
		add(selector);

		boyfriend = new Character(610, 30, characterName, true);
		boyfriend.scrollFactor.set();
		add(boyfriend);

		FlxG.sound.play(Paths.sound(deathSoundName));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		boyfriend.playAnim('firstDeath');
		
		PlayState.instance.setOnScripts('inGameOver', true);
		PlayState.instance.callOnScripts('onGameOverStart', []);

		FlxG.camera.zoom = 1.0;

		super.create();
	}

	override function beatHit()
	{
		if (startedDeath)
		{
			retry.animation.play('idle');
			boyfriend.playAnim('deathLoop');
		}
	}

	public var startedDeath:Bool = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		PlayState.instance.callOnScripts('onUpdate', [elapsed]);

		if (controls.UI_UP_P)
			changeSelection(-1);
		if (controls.UI_DOWN_P)
			changeSelection(1);

		if (controls.ACCEPT)
		{
			switch(curSelected)
			{
				case 0: // yes
					endBullshit();
				case 1: // no
					backToMenu();
			}
		}

		if (controls.BACK)
			backToMenu();
		
		if (boyfriend.animation.curAnim != null)
		{
			if (boyfriend.animation.curAnim.name == 'firstDeath' && boyfriend.animation.curAnim.finished && startedDeath)
				boyfriend.playAnim('deathLoop');

			if(boyfriend.animation.curAnim.name == 'firstDeath')
			{
				if(boyfriend.animation.curAnim.curFrame >= 30)
				{
					FlxTween.tween(retry, {alpha:1}, 0.5);
					FlxTween.tween(selector, {alpha:1}, 0.5);
					FlxTween.tween(box, {alpha:1}, 0.5);
				}

				if (boyfriend.animation.curAnim.finished && !playingDeathSound)
				{
					startedDeath = true;
					if (PlayState.SONG.stage == 'tank')
					{
						playingDeathSound = true;
						coolStartDeath(0.2);
						
						var exclude:Array<Int> = [];
						//if(!ClientPrefs.cursing) exclude = [1, 3, 8, 13, 17, 21];

						FlxG.sound.play(Paths.sound('jeffGameover/jeffGameover-' + FlxG.random.int(1, 25, exclude)), 1, false, null, true, function() {
							if(!isEnding)
							{
								FlxG.sound.music.fadeIn(0.2, 1, 4);
							}
						});
					}
					else coolStartDeath();
				}
			}
		}
		
		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
		PlayState.instance.callOnScripts('onUpdatePost', [elapsed]);
	}

	var isEnding:Bool = false;

	function coolStartDeath(?volume:Float = 1):Void
	{
		FlxG.sound.playMusic(Paths.music(loopSoundName), volume);
	}

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			boyfriend.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music(endSoundName));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					MusicBeatState.resetState();
				});
			});
			PlayState.instance.callOnScripts('onGameOverConfirm', [true]);
		}
	}

	function backToMenu():Void
	{
		#if DISCORD_ALLOWED DiscordClient.resetClientID(); #end
		FlxG.sound.music.stop();
		PlayState.deathCounter = 0;
		PlayState.seenCutscene = false;
		PlayState.chartingMode = false;

		Mods.loadTopMod();
		if (PlayState.isStoryMode)
			MusicBeatState.switchState(new StoryMenuState());
		else
			MusicBeatState.switchState(new FreeplayState());

		FlxG.sound.playMusic(Paths.music('freakyMenu'));
		PlayState.instance.callOnScripts('onGameOverConfirm', [false]);
	}

	function changeSelection(fuck:Int = 0)
	{
		curSelected += fuck;
		
		FlxG.sound.play(Paths.sound('scrollMenu'));

		if (curSelected > 1)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = 1;

		switch (curSelected)
		{
			case 0:
				selector.x = 180;
				selector.y = 450;
			case 1:
				selector.x = 210;
				selector.y = 555;
		}

	}

	override function destroy()
	{
		instance = null;
		super.destroy();
	}
}