package;

import flixel.FlxSprite;
import song.Conductor;

using StringTools;

class Note extends FlxSprite
{
	public var time:Float = 0;

	public var parentStrum:Strumline;
	public var noteData:Int = 0;
	public var prevNote:Note;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var score:Float = 1;

	public static var arrowArray:Array<String> = ["purple", "blue", "green", "red"];

	public function new(time:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false)
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		this.time = time;

		this.noteData = noteData;

		frames = Paths.sparrow('NOTE_assets');

		animation.addByPrefix('scroll', arrowArray[noteData] + ' instance');

		animation.addByPrefix('hold', arrowArray[noteData] + ' hold piece');
		animation.addByPrefix('holdEnd', arrowArray[noteData] + ' hold end');

		animation.play('scroll');

		setGraphicSize(Std.int(width * 0.7));
		updateHitbox();

		x += 112 * noteData;

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
}