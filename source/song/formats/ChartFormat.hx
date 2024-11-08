package song.formats;


class ChartFormat
{
	public var bpm:Float = 100;

	public var notes:Array<Note> = [];
	public var events:Array<Event> = [];

	public var player1:String = "bf";
	public var player2:String = "dad";
	public var gf:String = "gf";
}

typedef Event = {
	var name:String;
	var param:Array<Dynamic>;
	var time:Float;
}

typedef Note = {
	var noteName:String;
	var id:Int;
	var strumId:Int;
	var time:Float;
}