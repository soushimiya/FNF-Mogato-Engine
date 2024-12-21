package mogato.song;

import flixel.util.FlxSignal.FlxTypedSignal;
import mogato.song.formats.ChartFormat;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.util.FlxSort;
import flixel.FlxG;

using StringTools;

class Strumline extends FlxSpriteGroup
{
	var directions:Array<String> = ["LEFT", "DOWN", "UP", "RIGHT"];

	public var notes:FlxTypedSpriteGroup<Note>;
	public var onNoteHit:FlxTypedSignal<Note->Void> = new FlxTypedSignal();

	var downscroll:Bool = false;

	var cpu:Bool = false;

	var speed:Float = 1;

	static final INITIAL_OFFSET = -0.275 * 104;

	public function new(x:Float, y:Float, dataNotes:Array<ChartNote>, ?scrollSpeed:Float = 1, ?isCpu:Bool = false)
	{
		super(x, y);

		this.speed = scrollSpeed;
		this.cpu = isCpu;

		for (i in 0...directions.length)
		{
			var strumNote:FlxSprite = new FlxSprite(0, 0);
			strumNote.frames = Paths.sparrow('NOTE_assets');

			strumNote.setGraphicSize(Std.int(strumNote.width * 0.7));
			strumNote.x += (160 * 0.7) * i;
			strumNote.antialiasing = true;
			// wtf funkincrew fucked up
			if (i == 2)
				strumNote.animation.addByPrefix('default', 'arrow static instance 4');
			else if (i == 3)
				strumNote.animation.addByPrefix('default', 'arrow static instance 3');
			else
				strumNote.animation.addByPrefix('default', 'arrow static instance ' + (i + 1));

			strumNote.animation.addByPrefix('pressed', directions[i].toLowerCase() + ' press', 24, false);
			strumNote.animation.addByPrefix('confirm', directions[i].toLowerCase() + ' confirm', 24, false);

			strumNote.animation.play('default');

			this.add(strumNote);
		}

		notes = new FlxTypedSpriteGroup<Note>(25, 0);

		for (note in dataNotes)
		{
			var oldNote:Note = null;
			if (notes.length > 0)
				oldNote = notes.members[Std.int(notes.length - 1)];

			var swagNote:Note = new Note(note.time, note.id, oldNote);
			swagNote.sustainLength = note.length;

			var susLength:Float = swagNote.sustainLength;
			susLength = susLength / Conductor.stepCrochet;

			notes.add(swagNote);

			for (susNote in 0...Math.floor(susLength))
			{
				oldNote = notes.members[Std.int(notes.length - 1)];

				var sustainNote:Note = new Note(note.time + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, note.id, oldNote, true);
				notes.add(sustainNote);
			}
		}
		add(notes);
		notes.sort(sortNotes);
	}

	private static function sortNotes(order:Int = FlxSort.ASCENDING, Obj1:Note, Obj2:Note)
	{
		return FlxSort.byValues(order, Obj1.time, Obj2.time);
	}

	override public function update(elasped:Float)
	{
		super.update(elasped);
		for (note in notes.members)
		{
			note.y = this.y - INITIAL_OFFSET + calculateNoteYPos(note.time, true);
		}

		// Oh my god this sucks bro
		if (FlxG.keys.justPressed.LEFT && !cpu)
		{
			input(0);
		}
		else if (FlxG.keys.justPressed.DOWN && !cpu)
		{
			input(1);
		}
		if (FlxG.keys.justPressed.UP && !cpu)
		{
			input(2);
		}
		if (FlxG.keys.justPressed.RIGHT && !cpu)
		{
			input(3);
		}

		if (cpu)
		{
			for (note in notes.members)
				if (Conductor.songPosition >= note.time)
					noteHit(note);
		}
	}

	public function input(strum:Float)
	{
		// Based on Wizard Mania Input lol

		// possible press notes
		var possibleNotes = notes.members.filter((note) -> {
			return note != null 											// remove null notes
				&& note.id == strum 									// check only cur strum
				&& Math.abs(Conductor.songPosition - note.time) < (500 / speed); 	// only in hitzone
		});

		if (possibleNotes.length > 0) { // hit note
			possibleNotes.sort((a, b) -> Std.int(a.time - b.time));

			var toClear = possibleNotes.filter((note) -> {
				return Math.abs(possibleNotes[0].time - note.time) < 5;
			});

			for (note in toClear) {
				noteHit(note);
			}
		}
	}

	public function noteHit(note:Note)
	{
		note.visible = false;
		onNoteHit.dispatch(note);
	}

	// Stole from Funkin' hehe
	public function calculateNoteYPos(strumTime:Float, vwoosh:Bool = true):Float
	{
		// Make the note move faster visually as it moves offscreen.
		// var vwoosh:Float = (strumTime < Conductor.songPosition) && vwoosh ? 2.0 : 1.0;
		// ^^^ commented this out... do NOT make it move faster as it moves offscreen!
		var vwoosh:Float = 1.0;

		return 0.45 * (Conductor.songPosition - strumTime) * speed * vwoosh * (downscroll ? 1 : -1);
	}
}
