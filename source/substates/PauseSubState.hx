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

	var uni:FlxSprite;
	var danced:Bool = false;

	override function create()
	{
		/*
			Original pause menu code and design by Rudyrue
			I adjusted some of it :P
		*/

		pauseMusic = new FlxSound();
		try
		{
			var pauseSong:String = Paths.formatToSongPath('pause');
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

		var songinfo = new FlxText(20, 15, 0, "Song: "+PlayState.SONG.song, 32);
		songinfo.scrollFactor.set();
		songinfo.setFormat(Paths.font("phantommuff.ttf"), 32);
		songinfo.alignment = RIGHT;
		add(songinfo);
		songinfo.x = FlxG.width - (songinfo.width + 20);

		var composerName = new FlxText(20, 15+34, 0, "Composer: "+PlayState.SONG.composer, 32);
		composerName.scrollFactor.set();
		composerName.setFormat(Paths.font("phantommuff.ttf"), 32);
		composerName.alignment = RIGHT;
		add(composerName);
		composerName.x = FlxG.width - (composerName.width + 20);

		var deaths = new FlxText(20, 15+68, 0, "Deaths: "+PlayState.deathCounter, 32);
		deaths.scrollFactor.set();
		deaths.setFormat(Paths.font("phantommuff.ttf"), 32);
		deaths.alignment = RIGHT;
		add(deaths);
		deaths.x = FlxG.width - (deaths.width + 20);

		grpMenuShit = new FlxTypedGroup<FlxText>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var item = new FlxText(60, ((i + 1) * 80) + 135, 0, menuItems[i], 40);
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

		selector = new FlxText(25, 0, 0, '>', 40);
		selector.font = Paths.font('PhantomMuff.ttf');
		selector.alpha = 0;
		selector.antialiasing = true;
		selector.scrollFactor.set();
		add(selector);

		uni = new FlxSprite(700);
		uni.frames = Paths.getSparrowAtlas('menus/pause/yeah');
		uni.animation.addByPrefix('dance', 'uniDance', 19, true);
		uni.animation.play('dance');
		uni.antialiasing = ClientPrefs.data.antialiasing;
		uni.alpha = 0;
		uni.screenCenter(Y);
		add(uni);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(backdrop, {alpha: 1.0}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(songinfo, {alpha: 1.0}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(composerName, {alpha: 1.0}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(deaths, {alpha: 1.0}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});
		FlxTween.tween(selector, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(uni, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		super.create();

		changeSelection();
	}

	var holdTime:Float = 0;
	var cantUnpause:Float = 0.1;
	override function update(elapsed:Float)
	{
		cantUnpause -= elapsed;
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.05 * elapsed;

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

		grpMenuShit.forEach(function(spr:FlxSprite)
		{
			if (spr.ID == curSelected)
				FlxTween.tween(selector, {y: spr.y}, 0.1, {ease: FlxEase.quadInOut});
				//selector.y = spr.y;
		});
	}
}
