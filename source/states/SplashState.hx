package states;

/* 
    Basically fake loading screen state
    You can skip it and disable it in the options menu
    I just wanted an excuse to make the loading screen art lmfao
*/
class SplashState extends MusicBeatState
{
    override function create() 
    {
        super.create();
        
        var loadingArt = new FlxSprite().loadGraphic(Paths.image('menus/splash'));
		loadingArt.antialiasing = ClientPrefs.data.antialiasing;
		add(loadingArt);

        new FlxTimer().start(3, function(tmr:FlxTimer){
            MusicBeatState.switchState(new TitleState());
        });
    }
}