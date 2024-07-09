package substates;

import backend.WeekData;
import backend.Highscore;
import backend.Song;

import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;

import flixel.util.FlxStringUtil;

import states.StoryMenuState;
import states.FreeplayState;
import options.OptionsState;

class PauseSubState extends MusicBeatSubstate
{
	public static var songName:String = null;
	var grpMenuShit:FlxTypedGroup<FlxText>;
	var menuItems:Array<String> = ['Resume', 'Restart', 'Options', 'Exit'];
	var curSelected:Int = 0;
	var pauseMusic:FlxSound;

	var bg:FlxSprite;
	var backdrop:FlxBackdrop;
	var selector:FlxText;
	var info:FlxText;

	override function create()
	{
		/*
			Original pause menu code and design by Rudyrue
			I adjusted some of it :P
		*/

		pauseMusic = new FlxSound();
		try
		{
			var pauseSong:String = getPauseSong();
			if(pauseSong != null) pauseMusic.loadEmbedded(Paths.music(pauseSong), true, true);
		}
		catch(e:Dynamic) {}
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		bg = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		bg.scale.set(FlxG.width, FlxG.height);
		bg.updateHitbox();
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		backdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x11FFFFFF, 0x0));
		backdrop.alpha = 0;
		backdrop.velocity.set(30, 30);
		backdrop.scrollFactor.set();
		add(backdrop);

		info = new FlxText(20, 15, 0, PlayState.SONG.song, 32);
		info.scrollFactor.set();
		info.setFormat(Paths.font("phantommuff.ttf"), 32);
		info.updateHitbox();
		add(info);
		info.x = FlxG.width - (info.width + 20);

		grpMenuShit = new FlxTypedGroup<FlxText>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var item = new FlxText(0, ((i + 1) * 80) + 135, 0, menuItems[i], 40);
			item.font = Paths.font('PhantomMuff.ttf');
			item.borderStyle = OUTLINE;
			item.borderSize = 3;
			//item.alpha = 0;
			item.scrollFactor.set();
			item.antialiasing = true;
			item.ID = i;
			grpMenuShit.add(item);
		}

		selector = new FlxText(0, 0, 0, '<', 40);
		selector.font = Paths.font('PhantomMuff.ttf');
		selector.borderStyle = OUTLINE;
		selector.borderSize = 3;
		//selector.alpha = 0;
		selector.antialiasing = true;
		add(selector);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(backdrop, {alpha: 1.0}, 0.4, {ease: FlxEase.quartInOut});
		//FlxTween.tween(info, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		//FlxTween.tween(selector, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		super.create();
	}
	
	function getPauseSong()
	{
		var formattedSongName:String = (songName != null ? Paths.formatToSongPath(songName) : '');
		var formattedPauseMusic:String = Paths.formatToSongPath(ClientPrefs.data.pauseMusic);
		if(formattedSongName == 'none' || (formattedSongName != 'none' && formattedPauseMusic == 'none')) return null;

		return (formattedSongName != '') ? formattedSongName : formattedPauseMusic;
	}

	var holdTime:Float = 0;
	var cantUnpause:Float = 0.1;
	override function update(elapsed:Float)
	{
		cantUnpause -= elapsed;
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		if(controls.BACK)
		{
			close();
			return;
		}

		if (controls.UI_UP_P)
			changeSelection(-1);
		if (controls.UI_DOWN_P)
			changeSelection(1);

		if (controls.ACCEPT && (cantUnpause <= 0 || !controls.controllerMode))
		{
			switch (menuItems[curSelected])
			{
				case "Resume":
					close();
				case "Restart":
					restartSong();
				case 'Options':
					PlayState.instance.paused = true; // For lua
					PlayState.instance.vocals.volume = 0;
					MusicBeatState.switchState(new OptionsState());
					if(ClientPrefs.data.pauseMusic != 'None')
					{
						FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)), pauseMusic.volume);
						FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.8);
						FlxG.sound.music.time = pauseMusic.time;
					}
					OptionsState.onPlayState = true;
				case "Exit":
					#if DISCORD_ALLOWED DiscordClient.resetClientID(); #end
					PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;

					Mods.loadTopMod();
					if(PlayState.isStoryMode)
						MusicBeatState.switchState(new StoryMenuState());
					else 
						MusicBeatState.switchState(new FreeplayState());

					FlxG.sound.playMusic(Paths.music('freakyMenu'));
					PlayState.changedDifficulty = false;
					PlayState.chartingMode = false;
					FlxG.camera.followLerp = 0;
			}
		}
	}

	public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if(noTrans)
		{
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
		}
		MusicBeatState.resetState();
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		//FlxTween.tween(selector, {x: (menuItems[curSelected].x + menuItems[curSelected].width) + 10}, 0.1, {ease: FlxEase.quadOut});

		for (item in grpMenuShit.members)
		{
			item.y = bullShit - curSelected;
			bullShit++;
		}
	}
}
