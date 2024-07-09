package substates;

import backend.WeekData;
import backend.Highscore;
import backend.Song;

import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;

import flixel.util.FlxStringUtil;

import states.MainMenuState;
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

	var uni:FlxSprite;
	var danced:Bool = false;

	override function create()
	{
		/*
			Original pause menu code and design by Rudyrue
			I adjusted some of it :P
		*/

		FlxG.sound.playMusic(Paths.music('pause'), 0);

		Conductor.bpm = 82;
		FlxG.sound.music.fadeIn(10, 0, 0.7);

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

		info = new FlxText(890, 15, 0, "", 32);
		info.scrollFactor.set();
		info.setFormat(Paths.font("phantommuff.ttf"), 32);
		info.alignment = RIGHT;
		add(info);
		info.text = "Song: "+PlayState.SONG.song+"\nComposer: "+PlayState.SONG.composer+"\nDeaths: "+PlayState.deathCounter;

		grpMenuShit = new FlxTypedGroup<FlxText>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var item = new FlxText(40, ((i + 1) * 80) + 135, 0, menuItems[i], 40);
			item.font = Paths.font('PhantomMuff.ttf');
			item.alpha = 0;
			item.scrollFactor.set();
			item.antialiasing = true;
			item.ID = i;
			grpMenuShit.add(item);

			FlxTween.tween(item, {alpha:1}, 0.3 + (i*0.25), {
				ease: FlxEase.expoInOut
			});
		}

		selector = new FlxText(10, 0, 0, '>', 40);
		selector.font = Paths.font('PhantomMuff.ttf');
		selector.alpha = 0;
		selector.antialiasing = true;
		selector.scrollFactor.set();
		add(selector);

		uni = new FlxSprite(700);
		uni.frames = Paths.getSparrowAtlas('menus/pause/yeah');
		uni.animation.addByIndices('danceLeft', 'uniDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		uni.animation.addByIndices('danceRight', 'uniDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		uni.antialiasing = ClientPrefs.data.antialiasing;
		uni.alpha = 0;
		uni.screenCenter(Y);
		add(uni);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(backdrop, {alpha: 1.0}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(info, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(selector, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(uni, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		super.create();

		changeSelection();
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
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

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
					OptionsState.onPlayState = true;
				case "Exit":
					#if DISCORD_ALLOWED DiscordClient.resetClientID(); #end
					PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;
					MusicBeatState.switchState(new MainMenuState());

					FlxG.sound.playMusic(Paths.music('freakyMenu'));
					PlayState.changedDifficulty = false;
					PlayState.chartingMode = false;
					FlxG.camera.followLerp = 0;
			}
		}
	}

	override function beatHit() 
	{
		super.beatHit();

		if(uni != null) 
		{
			danced = !danced;
			if (danced)
				uni.animation.play('danceRight');
			else
				uni.animation.play('danceLeft');
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
		FlxG.sound.music.stop();
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

		grpMenuShit.forEach(function(spr:FlxSprite)
		{
			if (spr.ID == curSelected)
				selector.y = spr.y;
		});
	}
}
