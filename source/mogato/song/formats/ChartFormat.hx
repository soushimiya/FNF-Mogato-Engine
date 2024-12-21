package mogato.song.formats;

import openfl.Assets;

/**
	This is the base class for all chart formats.
	also auto-detect the type and return the required format.           
	@author Sulkiez
**/

class ChartFormat
{
	public var bpm:Float = 100;
	public var speed:Float = 1;

	public var bfNotes:Array<ChartNote> = [];
	public var dadNotes:Array<ChartNote> = [];

	public var events:Array<ChartEvent> = [];

	public var player1:String = "bf";
	public var player2:String = "dad";
	public var gf:String = "gf";

	public var stage:String = "stage";

	public var audioFolder:String = "audio/";

	public static function get(song:String, diff:String):ChartFormat
	{
		var path:String = Paths.json(song + "/chart/" + diff, "songs");
		if (!Assets.exists(path))
		{
			trace("No chart found on " + path + "! searching for old folder structure(data/"+ song + ")...");
			if (diff.toLowerCase() == "normal")
				path = Paths.json(song + "/" + song, "data");
			else
				path = Paths.json(song + "/" + song + "-" + diff, "data");

			if (!Assets.exists(path))
			{
				trace("Still chart not found! returning null!");
				return null;
			}
		}

		final chart = haxe.Json.parse(Assets.getText(path));
		//Detecting type shit!!!....but idk how i can detect psych chart hehe
		if (chart.gf != null)
			return new MogatoChart(chart);
		
		trace(new PsychChart(chart));
		return new PsychChart(chart);

	}
}

typedef ChartEvent = {
	var time:Float;
	var name:String;
	var params:Array<Dynamic>;
}

typedef ChartNote = {
	var time:Float;
	var id:Int;
	var length:Null<Float>;
	var noteType:Null<String>;
}