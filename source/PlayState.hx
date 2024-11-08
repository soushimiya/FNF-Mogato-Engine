package;

import song.Conductor;
import song.formats.*;

import flixel.FlxState;
import haxe.Json;
import flixel.sound.FlxSound;

class PlayState extends FlxState
{
	public var inst:FlxSound;
	public var voices:FlxSound;
	
	override public function create()
	{
		super.create();

		inst = new FlxSound();
		inst.loadEmbedded(Paths.audio("songs/bopeebo/Inst"));

		voices = new FlxSound();
		voices.loadEmbedded(Paths.audio("songs/bopeebo/Voices"));

		Conductor.onStepHit.add(stepHit);
		Conductor.onBeatHit.add(beatHit);

		var SONG:ChartFormat = new MogatoChart(Json.parse(CoolUtil.getText(Paths.json("bopeebo"))));

		Conductor.mapBPMChanges(SONG);

		inst.play();
		voices.play();
		Conductor.songPosition = 0;
	}

	override public function update(elasped:Float){
		Conductor.songPosition += elasped * 1000;
		Conductor.update();
	}

	public function stepHit(step:Int)
	{
		//does nothin lol
	}

	public function beatHit(beat:Int)
	{
		trace(beat);
	}
}
