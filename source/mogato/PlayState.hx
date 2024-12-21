package mogato;

import mogato.song.*;
import mogato.song.formats.*;
import mogato.scripting.*;
import mogato.util.*;

import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxState;
import haxe.Json;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.ui.FlxBar;
import flixel.FlxCamera;

class PlayState extends FlxState
{
	public static var songName:String = "bopeebo";
	public static var SONG:ChartFormat;

	public static var health:Float = 1;
	
	public var inst:FlxSound;
	public var voices:FlxSound;

	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	var opponentStrums:Strumline;
	var playerStrums:Strumline;

	public var debugText:FlxText;
	
	override public function create()
	{
		super.create();
		Conductor.onStepHit.add(stepHit);
		Conductor.onBeatHit.add(beatHit);

		SONG = ChartFormat.get("diamond", "hard");

		inst = new FlxSound();
		inst.loadEmbedded(Paths.audio("songs/diamond/" + SONG.audioFolder + "Inst"));
		FlxG.sound.list.add(inst);

		voices = new FlxSound();
		voices.loadEmbedded(Paths.audio("songs/diamond/" + SONG.audioFolder + "Voices"));
		FlxG.sound.list.add(voices);

		Conductor.mapBPMChanges(SONG);

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.cameras = [camHUD];
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this, 'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		healthBar.cameras = [camHUD];
		add(healthBar);

		opponentStrums = new Strumline(42, 10, SONG.dadNotes, SONG.speed, true);
		opponentStrums.cameras = [camHUD];
		add(opponentStrums);

		playerStrums = new Strumline((FlxG.width / 2) + 50, 10, SONG.bfNotes, SONG.speed);
		playerStrums.cameras = [camHUD];
		add(playerStrums);

		debugText = new FlxText(3, 3, 0, "", 20);
		debugText.alpha /= 3;
		add(debugText);

		Conductor.songPosition = 0;
		inst.play();
		voices.play();
	}

	override public function update(elapsed:Float){
		super.update(elapsed);
		
		Conductor.songPosition = inst.time;
		Conductor.update();

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
			camHUD.zoom = 1.05;
			FlxTween.tween(camHUD, {zoom: 1}, (Conductor.bpm / 60) * 0.4, {ease: FlxEase.circOut});
		}
	}
}
