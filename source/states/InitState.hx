package states;

import backend.WeekData;
import backend.Highscore;

import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

/**
    Handles initialization of variables when first opening the game.
**/

class InitState extends flixel.FlxState
{
    public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

    public static var initialized:Bool = false;

    override function create():Void {
        super.create();

        // -- FLIXEL STUFF -- //

        FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

		FlxG.sound.muteKeys = InitState.muteKeys;
		FlxG.sound.volumeDownKeys = InitState.volumeDownKeys;
		FlxG.sound.volumeUpKeys = InitState.volumeUpKeys;

        FlxTransitionableState.skipNextTransIn = true;

        // -- SETTINGS -- //

		FlxG.save.bind('funkin', CoolUtil.getSavePath());

        Controls.instance = new Controls();

        ClientPrefs.loadDefaultKeys();
		ClientPrefs.loadPrefs();

        Highscore.load();

        if (FlxG.save.data.weekCompleted != null)
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;

        if(!initialized)
		{
			if(FlxG.save.data != null && FlxG.save.data.fullscreen)
				FlxG.fullscreen = FlxG.save.data.fullscreen;
			persistentUpdate = true;
			persistentDraw = true;
		}

        // -- MODS -- //

		#if LUA_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

        // -- -- -- //

        Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
        FlxG.mouse.visible = false;

		MusicBeatState.switchState(new TitleState());
    }
}