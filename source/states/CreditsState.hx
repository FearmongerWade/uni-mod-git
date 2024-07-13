package states;

import flixel.addons.text.FlxTypeText;
import substates.SpecialThanksSubState;

class CreditsState extends MusicBeatState
{
    var curSelected:Int = 0;
    var path:String = "menus/credits/";

    private var grpOptions:FlxTypedGroup<FlxSprite>;
    var creditsNames:Array<String> = [
        'Ghost Bunny',
        'Cryfur',
        'Maiandraw',
        'Eights',
        'Steve'
    ];
    var side:FlxSprite;
    var selector:FlxSprite;

    var creditPortrait:FlxSprite;
    var textbox:FlxSprite;
    var descText:FlxTypeText;
    var descriptions:Array<String> = [
        "- Ghost Bunny -\n\nArtist | Coder | Composer\n\"friday night boobin\"",
        "- Cryfur -\n\nCharter | GF VA\n\"Domain Expansion: Infinite Charting Editor\"",
        "- Maia -\n\nComposer\n\"quote goes here\"",
        "- Mr.Eights -\n\nComposer\n\"hi\"",
        "- MCSteve - \n\nComposer\n\"quote goes here\""
    ];

    override function create() 
    {
        #if DISCORD_ALLOWED
		DiscordClient.changePresence("Credits Menu", null);
		#end
        
        persistentUpdate = true;

        var bg = new FlxSprite().loadGraphic(Paths.image('menuBGMagenta'));
        bg.antialiasing = ClientPrefs.data.antialiasing;
        bg.screenCenter();
		add(bg);

        // -- Text related items -- //

        side = new FlxSprite().loadGraphic(Paths.image(path+'side'));
        side.antialiasing = ClientPrefs.data.antialiasing;
        add(side);

        grpOptions = new FlxTypedGroup<FlxSprite>();
		add(grpOptions);

        for (i in 0...creditsNames.length)
        {
            var spr = new FlxSprite(80, 150+(i*100));
            spr.loadGraphic(Paths.image(path+'names/'+creditsNames[i]));
            spr.antialiasing = ClientPrefs.data.antialiasing;
            spr.ID = i;
            grpOptions.add(spr);
        }

        selector = new FlxSprite(55, 130);
        selector.frames = Paths.getSparrowAtlas(path+'gwa');
        selector.animation.addByPrefix('loop', 'selector', 12, true);
        selector.animation.play('loop');
        add(selector);

        // -- Portrait related items -- //

        creditPortrait = new FlxSprite(600, 0);
        creditPortrait.loadGraphic(Paths.image(path+'art/'+creditsNames[curSelected]));
        creditPortrait.antialiasing = ClientPrefs.data.antialiasing;
        add(creditPortrait);

        textbox = new FlxSprite(600, 450).loadGraphic(Paths.image(path+'textbox'));
        textbox.antialiasing = ClientPrefs.data.antialiasing;
        add(textbox);

        descText = new FlxTypeText(textbox.x+20, textbox.y+15, 500, descriptions[curSelected], 32);
        descText.setFormat(Paths.font('phantommuff.ttf'), 32, FlxColor.WHITE, CENTER);
        add(descText);

        var ctrlText = new FlxText(0, FlxG.height-35, 0, "Press CTRL for the special thanks", 30);
        ctrlText.font = Paths.font('vcr.ttf');
        add(ctrlText);
        ctrlText.x = FlxG.width - ctrlText.width -5;

        changeItem();
        super.create();
    }

    override function update(elapsed:Float) 
    {
        if (controls.UI_UP_P)
            changeItem(-1);
        if (controls.UI_DOWN_P)
            changeItem(1);
        if (controls.BACK)
            MusicBeatState.switchState(new MainMenuState());
        if (FlxG.keys.justPressed.CONTROL)
        {
            persistentUpdate = false;
            openSubState(new SpecialThanksSubState());
            FlxG.sound.play(Paths.sound('scrollMenu'));
        }

        super.update(elapsed);    
    }

    function changeItem(bwa:Int = 0) 
    {
        FlxG.sound.play(Paths.sound('scrollMenu'));

        curSelected += bwa;

        if (curSelected >= creditsNames.length)
			curSelected = 0;
 		if (curSelected < 0)
			curSelected = creditsNames.length - 1;

        creditPortrait.loadGraphic(Paths.image(path+'art/'+creditsNames[curSelected]));
        creditPortrait.updateHitbox();

        descText.resetText(descriptions[curSelected]);
        descText.start(0.035);

        grpOptions.forEach(function(spr:FlxSprite)
        {
            if (spr.ID == curSelected)
                FlxTween.tween(selector, {y: spr.y - 15}, 0.1, {ease:FlxEase.expoInOut});
        });
    }
}