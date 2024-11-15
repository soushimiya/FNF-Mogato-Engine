package;

import song.Conductor;
import song.formats.*;
import scripting.*;

import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxState;
import haxe.Json;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import openfl.net.FileReference;

class PlayState extends FlxState
{
	public static var songName:String = "bopeebo";
	public static var SONG:ChartFormat;
	
	public var inst:FlxSound;
	public var voices:FlxSound;

	var opponentStrums:Strumline;
	var playerStrums:Strumline;

	public var debugText:FlxText;
	
	override public function create()
	{
		super.create();
		Conductor.onStepHit.add(stepHit);
		Conductor.onBeatHit.add(beatHit);

		SONG = new MogatoChart(Json.parse(CoolUtil.getText(Paths.json("bopeebo/chart/hard", "songs"))));

		inst = new FlxSound();
		inst.loadEmbedded(Paths.audio("songs/bopeebo/audio/Inst"));
		FlxG.sound.list.add(inst);

		voices = new FlxSound();
		voices.loadEmbedded(Paths.audio("songs/bopeebo/audio/Voices"));
		FlxG.sound.list.add(voices);

		Conductor.mapBPMChanges(SONG);

		opponentStrums = new Strumline(42, 10, SONG.dadNotes, SONG.speed);
		add(opponentStrums);

		playerStrums = new Strumline((FlxG.width / 2) + 50, 10, SONG.bfNotes, SONG.speed);
		add(playerStrums);

		debugText = new FlxText(3, 3, 0, "", 20);
		debugText.alpha /= 3;
		add(debugText);

		Conductor.songPosition = 0;
		inst.play();
		voices.play();

		var _file = new FileReference();
		_file.save(Json.stringify(SONG, "\t"), "dadadada.json");
	}

	override public function update(elasped:Float){
		Conductor.songPosition = inst.time;
		Conductor.update();

		opponentStrums.update(elasped);
		playerStrums.update(elasped);

		debugText.text = "Position: " + Math.round(Conductor.songPosition) / 1000;
		debugText.text += "\nStep: " + Conductor.curStep;
		debugText.text += "\nBeat: " + Conductor.curBeat;
	}

	public function stepHit(step:Int)
	{
		//does nothin lol
	}

	public function beatHit(beat:Int)
	{
		if (beat % 4 == 0)
		{
			FlxG.camera.zoom = 1.05;
			FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.bpm / 60) * 0.8, {ease: FlxEase.circOut});
		}
	}
}
