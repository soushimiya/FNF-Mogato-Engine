package mogato.song.formats;

import mogato.song.formats.ChartFormat;

class MogatoChart extends ChartFormat
{
	override public function new(chart:Dynamic){
		song = chart.song;
		bpm = chart.bpm;
		speed = chart.speed;

		//events = chart.events;
		var ogBf:Array<Array<Float>> = chart.boyfriend.notes;
		var convBf:Array<ChartNote> = [];
		for (note in ogBf)
		{
			var convNote:ChartNote = {
				time: note[0],
				id: Std.int(note[1]),
				length: note[2],
				noteType: ""
			};
			convBf.push(convNote);
		}
		bfNotes = convBf;
		
		var ogDad:Array<Array<Float>> = chart.dad.notes;
		var convdad:Array<ChartNote> = [];
		for (note in ogDad)
		{
			var convNote:ChartNote = {
				time: note[0],
				id: Std.int(note[1]),
				length: note[2],
				noteType: ""
			};
			convdad.push(convNote);
		}
		dadNotes = convdad;
	
		player1 = chart.boyfriend.character;
		player2 = chart.dad.character;
		gf = chart.gf.character;

		stage = chart.stage;
	}
}