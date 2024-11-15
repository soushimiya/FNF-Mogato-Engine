package;

import song.Conductor;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import song.formats.ChartFormat;
import flixel.util.FlxSort;
import flixel.FlxG;

using StringTools;

class Strumline extends FlxSpriteGroup
{
	var directions:Array<String> = ["LEFT", "DOWN", "UP", "RIGHT"];

	private var notes:FlxTypedSpriteGroup<Note>;

	var scroll:Int = -1; // 1 = downscroll

	var speed:Float = 1;
	
	public function new(x:Float, y:Float, dataNotes:Array<ChartNote>, ?scrollSpeed:Float = 1, ?cpu:Bool = false)
	{
		super(x, y);

		this.speed = scrollSpeed;

		for (i in 0...directions.length)
		{
			var strumNote:FlxSprite = new FlxSprite(0, 0);
			strumNote.frames = Paths.sparrow('NOTE_assets');

			strumNote.setGraphicSize(Std.int(strumNote.width * 0.7));
			strumNote.x += (160 * 0.7) * i;
			strumNote.antialiasing = true;
			//wtf funkincrew fucked up
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
			if (notes.length > 0) oldNote = notes.members[Std.int(notes.length - 1)];

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

	override public function update(elasped:Float){
		super.update(elasped);
		for (note in notes.members){
			note.y = 0.45 * (Conductor.songPosition - note.time) * speed * scroll;
		}
	}
}