package substates;

class SpecialThanksSubState extends MusicBeatSubstate
{
    var spr:FlxSprite;
    var txt:FlxText;

    override function create() 
    {
        spr = new FlxSprite().loadGraphic(Paths.image('menus/credits/special thanks'));
        spr.antialiasing = ClientPrefs.data.antialiasing;
        spr.alpha = 0.000001;
        add(spr);

        txt = new FlxText(0, FlxG.height-35, 0, "Press ESC to go back", 30);
        txt.font = Paths.font('vcr.ttf');
        add(txt);
        txt.x = FlxG.width - txt.width -5;
        txt.alpha = 0.00001;

        FlxTween.tween(spr, {alpha: 1}, 0.8, {ease: FlxEase.expoInOut});
        FlxTween.tween(txt, {alpha: 1}, 0.8, {ease: FlxEase.expoInOut});

        super.create();
    }

    override function update(elapsed:Float) 
    {
        if (FlxG.keys.justPressed.ESCAPE) {
            FlxTween.tween(spr, {alpha: 0}, 0.8, {ease: FlxEase.expoInOut});
            FlxTween.tween(txt, {alpha: 0}, 0.8, {ease: FlxEase.expoInOut, 
                onComplete: function(twn:FlxTween) {
                    close();
                }});
        }
        super.update(elapsed);
    }
}