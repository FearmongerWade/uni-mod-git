package options;

import options.Option;

class AudioSettings extends BaseOptionsMenu
{
    public function new()
    {
        title = 'audio';
        rpcTitle = 'Audio Settings Menu';

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
}