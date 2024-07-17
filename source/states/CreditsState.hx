package states;

import flixel.addons.text.FlxTypeText;
import substates.SpecialThanksSubState;

class CreditsState extends MusicBeatState
{
    var curSelected:Int = 0;
    var path:String = "menus/credits/";
    public static var firstStart:Bool = true;
    var trans:Bool = false;

    private var grpOptions:FlxTypedGroup<FlxSprite>;
    var creditsNames:Array<String> = [
        'Ghost Bunny',
        'Cryfur',
        'Maiandraw',
        'Eights',
        'Misu'
    ];
    var side:FlxSprite;
    var selector:FlxSprite;

    var creditPortrait:FlxSprite;
    var textbox:FlxSprite;
    var descText:FlxTypeText;
    var descriptions:Array<String> = [
        "- Ghost Bunny -\n\nArtist | Coder | Composer\n\"friday night boobin\"",
        "- Cryfur -\n\nCharter | GF VA\n\"Domain Expansion: Infinite Charting Editor\"",
        "- Maia -\n\nComposer\n\"dodo\"",
        "- Mr.Eights -\n\nComposer\n\"hi\"",
        "- Misu - \n\nComposer\n\"hi\""
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

            if (firstStart)
            {
                spr.x -= 600;
                FlxTween.tween(spr, {x:80}, 0.8 + (i*0.25), {
                    ease:FlxEase.expoInOut,
                    onComplete: function(brah:FlxTween)
                    {
                        firstStart = false;
                    }
                });
            }
            else 
                spr.x = 80;
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

        // -- Tweens and shit -- //

        if (firstStart)
        {
            side.x -= 600;
            selector.x -= 600;
            creditPortrait.y += 800;
            textbox.y += 500;
            descText.y += 500;
            ctrlText.alpha = 0;

            FlxTween.tween(side, {x:0}, 0.5, {ease:FlxEase.quadInOut});
            FlxTween.tween(selector, {x:55}, 0.5, {ease:FlxEase.quadInOut});
            FlxTween.tween(creditPortrait, {y:0}, 0.6, {ease:FlxEase.expoInOut});
            FlxTween.tween(textbox, {y:450}, 0.4, {ease:FlxEase.expoInOut});
            FlxTween.tween(descText, {y:450+15}, 0.42, {ease:FlxEase.expoInOut, onComplete: function(twn:FlxTween){
                FlxTween.tween(ctrlText, {alpha:1}, 0.4);
                changeItem();
                trans = true;
            }});
        }
        else 
        {
            changeItem();
            trans = true;
        }

        super.create();
    }

    override function update(elapsed:Float) 
    {
        if (trans)
        {
            if (controls.UI_UP_P)
                changeItem(-1);
            if (controls.UI_DOWN_P)
                changeItem(1);
            if (controls.BACK)
                MusicBeatState.switchState(new MainMenuState());
            if (controls.ACCEPT)
                openLink();
            if (FlxG.keys.justPressed.CONTROL)
            {
                persistentUpdate = false;
                openSubState(new SpecialThanksSubState());
                FlxG.sound.play(Paths.sound('scrollMenu'));
            }
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

    function openLink()
    {
        switch(curSelected)
        {
            case 0: // Bunny
                CoolUtil.browserLoad('https://x.com/GhostBnuuy');
            case 1: // Cryfur
                CoolUtil.browserLoad('https://x.com/CryfurV');
            case 2: // Maia
                CoolUtil.browserLoad('https://x.com/Maiandraw');
            case 3: // Eights
                CoolUtil.browserLoad('https://x.com/Mr3ights');
            case 4: // Steve
                CoolUtil.browserLoad('https://x.com/TiramisuuuCakey');
        }
    }
}