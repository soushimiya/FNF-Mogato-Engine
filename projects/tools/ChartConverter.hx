package;

import sys.FileSystem;
import haxe.Json;

using StringTools;

class ChartConverter
{
	public static function main():Void
	{
		var chartPath:String = "";

		trace("Enter Chart Path!");
		chartPath = Sys.stdin().readLine().trim();

		if (!FileSystem.exists(chartPath)){
			trace('No Chart Exist on ($chartPath) !!');
			return;
		}

		//Doing actual converting lol
		var chart:Dynamic = Json.parse(sys.io.File.getContent(chartPath)).song;

		var convertedChart:Dynamic = {};

		convertedChart.song = chart.song;
		convertedChart.bpm = chart.bpm;
		convertedChart.speed = chart.speed;

		convertedChart.boyfriend = {};
		convertedChart.boyfriend.character = chart.player1;
		convertedChart.dad = {};
		convertedChart.dad.character = chart.player2;
		//idk???
		convertedChart.gf = {};
		if (chart.gfVersion != null) convertedChart.gf.character = chart.gfVersion; else convertedChart.gf.character = "gf";

		var sections:Array<PsychSection> = chart.notes;
		//nah i gonna fw this
		convertedChart.boyfriend.notes = [];
		convertedChart.dad.notes = [];
		for (section in sections)
		{
			var notes:Array<Array<Float>> = section.sectionNotes;
			for(note in notes)
			{
				var newNote:Array<Float> = [];
				var noteId:Int = Std.int(note[0]);
				var mustHit:Bool = section.mustHitSection;
				if (noteId > 3){
					mustHit = !mustHit;
					noteId -= 4;
				}

				//No custom notes for now!
				newNote[0] = noteId;
				newNote[1] = note[1];
				newNote[2] = note[2];
				if (mustHit)
					convertedChart.boyfriend.notes.push(newNote);
				else
					convertedChart.dad.notes.push(newNote);
			}
		}
		trace(Json.stringify(convertedChart, "\t"));
	}
}

typedef PsychSection = {
	var lengthInSteps:Int;
	var mustHitSection:Bool;
	var sectionNotes:Array<Array<Float>>;
}