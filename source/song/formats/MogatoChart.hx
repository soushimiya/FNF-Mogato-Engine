package song.formats;


class MogatoChart extends ChartFormat
{
	override public function new(chart:Dynamic){
		bpm = 100;

		notes = chart.notes;
		events = chart.events;
	
		player1= chart.player1;
		player2 = chart.player2;
		gf = chart.gf;

	}
}