package objects;

class AttachedFlxText extends FlxText
{
	public var offsetX:Float = 0;
	public var offsetY:Float = 0;
	public var sprTracker:FlxSprite;
	public var copyVisible:Bool = true;
	public var copyAlpha:Bool = false;
	public function new(text:String = "", ?offsetX:Float = 0, ?offsetY:Float = 0, ?bold = false, ?scale:Int = 32) {
		super(0, 0, text, bold);

		this.size = scale;
		this.font = Paths.font('phantommuff.ttf');
		this.offsetX = offsetX;
		this.offsetY = offsetY;
	}

	override function update(elapsed:Float) {
		if (sprTracker != null) {
			setPosition(sprTracker.x + offsetX, sprTracker.y + offsetY);
			if(copyVisible)
				visible = sprTracker.visible;

			if(copyAlpha)
				alpha = sprTracker.alpha;
		}

		super.update(elapsed);
	}
}