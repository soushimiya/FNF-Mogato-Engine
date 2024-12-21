package mogato.song;

import flixel.FlxSprite;
import mogato.states.PlayState;

using StringTools;

class Note extends FlxSprite
{
	public var time:Float = 0;

	public var parentStrum:Strumline;
	public var id:Int = 0;
	public var prevNote:Note;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var score:Float = 1;

	public var hittable:Bool = false;
	public var hit:Bool = false;
	public var late:Bool = false;

	public static final arrowArray:Array<String> = ["purple", "blue", "green", "red"];

	public function new(time:Float, id:Int, ?prevNote:Note, ?sustainNote:Bool = false)
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		this.time = time;

		this.id = id;

		frames = Paths.sparrow('NOTE_assets');

		animation.addByPrefix('scroll', arrowArray[id] + ' instance');

		animation.addByPrefix('hold', arrowArray[id] + ' hold piece');
		animation.addByPrefix('holdEnd', arrowArray[id] + ' hold end');

		animation.play('scroll');

		setGraphicSize(Std.int(width * 0.7));
		updateHitbox();

		x += 112 * id;

		antialiasing = true;

		if (isSustainNote && prevNote != null)
		{
			score * 0.2;
			alpha = 0.6;

			x += width / 2;

			animation.play('holdEnd');
			updateHitbox();

			x -= width / 2;

			if (prevNote.isSustainNote)
			{
				prevNote.animation.play('hold');
				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
			}
		}
	}

	override public function update(elasped:Float)
	{
		hittable = (time > Conductor.songPosition - 1 && time < Conductor.songPosition + 1);

		if (time < Conductor.songPosition)
			late = true;
	}
}
