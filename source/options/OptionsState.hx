package options;

import states.MainMenuState;
import backend.StageData;

class OptionsState extends MusicBeatState
{
	var options:Array<String> = ['video', 'input', 'gameplay', 'audio', 'offset'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	var path:String = "menus/options/";

	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
	public static var onPlayState:Bool = false;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'input':
				openSubState(new options.ControlsSubState());
			case 'video':
				openSubState(new options.GraphicsSettingsSubState());
			/*case 'Visuals and UI':
				openSubState(new options.VisualsUISubState());*/
			case 'gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'offset':
				MusicBeatState.switchState(new options.NoteOffsetState());
		}
	}

	var funnySprite:FlxSprite;
	var selector:FlxSprite;
	var bottomText:FlxText;

	override function create() {
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Options Menu", null);
		#end

		FlxG.sound.playMusic(Paths.music('options'));

		var bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.color = 0xFFea71fd;
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		var optionsSprite = new FlxSprite(0, 40).loadGraphic(Paths.image(path+'titles/options'));
        optionsSprite.antialiasing = ClientPrefs.data.antialiasing;
        optionsSprite.screenCenter(X);
        add(optionsSprite);

		funnySprite = new FlxSprite(600, 280);
        funnySprite.frames = Paths.getSparrowAtlas(path+'sprites');

        funnySprite.animation.addByPrefix('video', 'video', 24);
        funnySprite.animation.addByPrefix('audio', 'audio', 24);
        funnySprite.animation.addByPrefix('input', 'input', 24);
        funnySprite.animation.addByPrefix('gameplay', 'gameplay', 24);
        funnySprite.animation.addByPrefix('offset', 'loading', 24);

        funnySprite.antialiasing = true;
        add(funnySprite);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(100, 290+(i*75), options[i], true);
			grpOptions.add(optionText);
		}

		selector = new FlxSprite(45).loadGraphic(Paths.image(path+'selector'));
		selector.antialiasing = ClientPrefs.data.antialiasing;
		add(selector);

		var black = new FlxSprite(0, FlxG.height - 40).makeGraphic(1280, 40, FlxColor.BLACK);
        black.alpha = 0.25;
        add(black);

		bottomText = new FlxText(10, FlxG.height - 32, 0, "", 24);
        bottomText.font = Paths.font('vcr.ttf');
        bottomText.antialiasing = true;
        add(bottomText);

		changeSelection();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Options Menu", null);
		#end
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			if(onPlayState)
			{
				StageData.loadDirectory(PlayState.SONG);
				LoadingState.loadAndSwitchState(new PlayState());
				FlxG.sound.music.volume = 0;
			}
			else 
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.8);
				MusicBeatState.switchState(new MainMenuState());
			}
		}
		else if (controls.ACCEPT) openSelectedSubstate(options[curSelected]);
	}
	
	function changeSelection(change:Int = 0) 
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));

		curSelected += change;

		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		funnySprite.animation.play(options[curSelected]);

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.5;
			if (item.targetY == 0) {
				item.alpha = 1;
				selector.y = item.y;
			}
		}

		switch (options[curSelected])
        {
            case "video":
                bottomText.text = 'Adjust your video and graphic settings.';
            case "input":
                bottomText.text = 'Adjust your game keybindings.';
            case "gameplay":
                bottomText.text = 'Adjust gameplay settings (Downscroll, Ghost Tapping, etc.)';
            case "audio":
                bottomText.text = 'Adjust your volume settings.';
            case "offset":
                bottomText.text = 'Adjust your offset settings.';
        }
		
	}

	override function destroy()
	{
		ClientPrefs.loadPrefs();
		super.destroy();
	}
}