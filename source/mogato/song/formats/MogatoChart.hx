package mogato.song.formats;

import mogato.song.formats.ChartFormat;

// The main format is simply adapted from the chart data.
class MogatoChart extends ChartFormat
{
	override public function new(chart:Dynamic){
		bpm = chart.bpm;
		speed = chart.speed;

		//events = chart.events;
		bfNotes = chart.boyfriend.notes;
		dadNotes = chart.dad.notes;
	
		player1 = chart.boyfriend.character;
		player2 = chart.dad.character;
		gf = chart.gf.character;

		stage = chart.stage;
	}
}