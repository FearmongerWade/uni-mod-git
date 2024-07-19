package states.stages;

class Fnaf extends BaseStage
{
    var clickable:FlxSprite;
    var path:String = 'backgrounds/fnaf4/';

    override function create()
    {
        FlxG.mouse.visible = true;

        var bg = new FlxSprite().loadGraphic(Paths.image(path+'freddyfivebear'));
        bg.antialiasing = true;
        add(bg);

        clickable = new FlxSprite(670, 310).makeGraphic(35, 20, FlxColor.WHITE);
        clickable.alpha = 0.00001;
        add(clickable);
    }

    override function update(elapsed:Float) 
    {
        if (FlxG.mouse.overlaps(clickable) && FlxG.mouse.justPressed)
            FlxG.sound.play(Paths.sound('boop'), ClientPrefs.data.soundVolume);
    }
}