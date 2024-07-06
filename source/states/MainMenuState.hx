package states;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;

import backend.Difficulty;
import backend.Highscore;
import backend.Song;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.7.3'; // This is also used for Discord RPC
	public static var curSelected:Int = 0;
	var curDifficulty:Int = 2;

	var optionShit:Array<String> = ['uni', 'nightmare', 'paws', 'options', 'credits'];
	var path:String = "menus/main_menu/";

	var menuItem:FlxSprite;
    var itemTween:FlxTween;
    var itemAlphaTween:FlxTween;

	override function create()
	{
		// -- Setup -- //

		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		// -- Assets -- //

		var bg = new FlxSprite().loadGraphic(Paths.image(path+'background'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

		menuItem = new FlxSprite(130, 154).loadGraphic(Paths.image(path + 'albums/' + optionShit[curSelected]));
		menuItem.alpha = 0.7;
		menuItem.antialiasing = ClientPrefs.data.antialiasing;
		add(menuItem);

		var vinyl = new FlxSprite(622, 423);
		vinyl.frames = Paths.getSparrowAtlas(path + 'vinyl');
		vinyl.animation.addByPrefix('yeah', 'vinyl play', 18, true);
		vinyl.animation.play('yeah');
		vinyl.antialiasing = ClientPrefs.data.antialiasing;
		add(vinyl);

		var uni = new FlxSprite(750, 225);
		uni.frames = Paths.getSparrowAtlas(path + 'the strongest');
		uni.animation.addByPrefix('guh', 'spin', 18, true);
		uni.animation.play('guh');
		uni.antialiasing = ClientPrefs.data.antialiasing;
		add(uni);

		var upArrow = new FlxSprite(270, 50).loadGraphic(Paths.image(path + 'arrow'));
		upArrow.antialiasing = ClientPrefs.data.antialiasing;
		add(upArrow);

		var downArrow = new FlxSprite(270, 580).loadGraphic(Paths.image(path + 'arrow'));
		downArrow.antialiasing = ClientPrefs.data.antialiasing;
		downArrow.flipY = true;
		add(downArrow);

		var bars = new FlxSprite().loadGraphic(Paths.image(path + 'bars'));
		add(bars);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			if (FreeplayState.vocals != null)
				FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
				changeItem(-1);

			if (controls.UI_DOWN_P)
				changeItem(1);
			if (controls.ACCEPT)
				selectItem();
			#if desktop
			if (controls.justPressed('debug_1'))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));

		curSelected += huh;

        if (curSelected >= optionShit.length)
			curSelected = 0;
 		if (curSelected < 0)
			curSelected = optionShit.length - 1;
		
		menuItem.loadGraphic(Paths.image(path + 'albums/' + optionShit[curSelected]));
		menuItem.updateHitbox();
		menuItem.alpha = 0.7;
		menuItem.y = 154;

		if (itemTween != null)
            itemTween.cancel();
        if (itemAlphaTween != null)
            itemAlphaTween.cancel();

        itemTween = FlxTween.tween(menuItem, {y: 144}, 0.25, {ease: FlxEase.quadInOut});
        itemAlphaTween = FlxTween.tween(menuItem, {alpha: 1}, 0.25, {ease: FlxEase.quadInOut});
	}

	function selectItem()
	{
		selectedSomethin = true;
		FlxG.sound.play(Paths.sound('confirmMenu'));
		FlxG.camera.flash(FlxColor.WHITE, 1);

		new FlxTimer().start(1.5, function(tmr) {
			switch(optionShit[curSelected])
			{
				case 'options':
					MusicBeatState.switchState(new OptionsState());
					OptionsState.onPlayState = false;
					if (PlayState.SONG != null)
					{
						PlayState.SONG.arrowSkin = null;
						PlayState.SONG.splashSkin = null;
						PlayState.stageUI = 'normal';
					}
				case 'credits':
					MusicBeatState.switchState(new CreditsState());
				default: 
					loadSong(optionShit[curSelected]);
			}
		});
	}

	function loadSong(songName:String) 
	{
		persistentUpdate = false;
		Difficulty.resetList();

		var poop:String = Highscore.formatSong(songName.toLowerCase(), curDifficulty);
		PlayState.SONG = Song.loadFromJson(poop, songName.toLowerCase());
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = curDifficulty;

		LoadingState.loadAndSwitchState(new PlayState());
		FlxG.sound.music.volume = 0;
	}
}
