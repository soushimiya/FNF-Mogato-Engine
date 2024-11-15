package mogato.song.formats;

class ChartFormat
{
	public var song:String = "";
	public var bpm:Float = 100;
	public var speed:Float = 1;

	public var bfNotes:Array<ChartNote> = [];
	public var dadNotes:Array<ChartNote> = [];

	public var events:Array<ChartEvent> = [];

	public var player1:String = "bf";
	public var player2:String = "dad";
	public var gf:String = "gf";

	public var stage:String = "stage";
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