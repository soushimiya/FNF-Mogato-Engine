package mogato.song.formats;

import mogato.song.formats.ChartFormat.ChartNote;

// Some people hate it, some people love it, the world's most famous FNF engine format.
class PsychChart extends ChartFormat
{
	public function new(chart:Dynamic)
	{
		bpm = chart.song.bpm;
		speed = chart.song.speed;

		player1 = chart.song.player1;
		player2 = chart.song.player2;
		// idk???
		if (chart.song.gfVersion != null)
			gf = chart.song.gfVersion;
		else
			gf = "gf";

		final sections:Array<PsychSection> = chart.song.notes;
		// nah i gonna fw this
		for (section in sections)
		{
			var notes:Array<Array<Float>> = section.sectionNotes;
			for (note in notes)
			{
				var noteId:Int = Std.int(note[1]);
				var mustHit:Bool = section.mustHitSection;
				if (noteId > 3)
				{
					mustHit = !mustHit;
					noteId = noteId % 4;
				}

				// No custom notes for now!
				var newNote:ChartNote = {
					time: note[0],
					id: noteId,
					length: note[2],
					noteType: ""
				};

				if (mustHit)
					bfNotes.push(newNote);
				else
					dadNotes.push(newNote);
			}
		}

		audioFolder = "";
	}
}

typedef PsychSection =
{
	var lengthInSteps:Int;
	var mustHitSection:Bool;
	var sectionNotes:Array<Array<Float>>;
}
