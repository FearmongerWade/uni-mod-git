package options;

import options.Option;

class AudioSettings extends BaseOptionsMenu
{
    public function new()
    {
        title = 'audio';
        rpcTitle = 'Audio Settings Menu';

        var option:Option = new Option('Music Volume',
			'Volume for music NOT related to the playable songs.',
			'musicVolume',
			'percent');
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = onChangeMusicVolume;

        var option:Option = new Option('Sound Volume',
			'Volume for sound effects.',
			'soundVolume',
			'percent');
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
        option.onChange = onChangeSFXVolume;

        var option:Option = new Option('Inst Volume',
			'Volume for instrumentals inside of the songs.',
			'instVolume',
			'percent');
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;

        var option:Option = new Option('Voices Volume',
			'Volume for the vocals inside of the songs.',
			'voicesVolume',
			'percent');
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;

        var option:Option = new Option('Hitsound Volume',
			'Funny notes does \"Tick!\" when you hit them.',
			'hitsoundVolume',
			'percent');
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = onChangeHitsoundVolume;

        var option = new Option('Miss Sounds', 
            'If checked, you can hear the miss sounds when you... well... miss.', 
            'missSounds', 
            'bool');
        addOption(option);

        super();
    }

    function onChangeHitsoundVolume()
		FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.data.hitsoundVolume);

    function onChangeSFXVolume()
		FlxG.sound.play(Paths.sound('scrollMenu'), ClientPrefs.data.soundVolume);

	function onChangeMusicVolume()
		FlxG.sound.music.volume = ClientPrefs.data.musicVolume;

}