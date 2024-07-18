package states;

class ChartTroll extends MusicBeatState
{
    override function create() 
    {
        FlxG.camera.zoom = 1;
        FlxG.sound.playMusic(Paths.music('you shouldnt of done that'));

        var img = new FlxSprite().loadGraphic(Paths.image('consequences'));
        img.scrollFactor.set();
        img.alpha = 0.0001;
        add(img);
        FlxTween.tween(img, {alpha:1}, 3);

        new FlxTimer().start(FlxG.random.int(8, 16), function(tmr:FlxTimer) {
            Sys.exit(1);
        });
    }
}