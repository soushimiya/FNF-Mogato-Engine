package mogato.song;

import flixel.util.FlxSignal.FlxTypedSignal;
import mogato.song.formats.ChartFormat;

typedef BPMChangeEvent = {
	var bpm:Float;
	var time:Float;
	var step:Float;
}

class Conductor
{
	public static var songPosition:Float = 0;

	public static var bpm:Float = 100;

	public static var curStep:Int = 0;
	public static var curBeat:Int = 0;
	
	public static var crochet:Float = (60 / bpm) * 1000;
	public static var stepCrochet:Float = crochet / 4;

	public static var bpmChanges:Array<BPMChangeEvent> = [];

	public static var onStepHit:FlxTypedSignal<Int->Void> = new FlxTypedSignal();
	public static var onBeatHit:FlxTypedSignal<Int->Void> = new FlxTypedSignal();

	public static function mapBPMChanges(song:ChartFormat) {
		songPosition = 0;
		bpm = song.bpm;
		curStep = 0;
		curBeat = 0;

		bpmChanges = [];

		if(song.events == null)
			return;

		var currentBPM = bpm;
		var curTime:Float = 0;
		var curStepEvent:Float = 0;

		for(e in song.events) {
			if(e.name == "Change BPM") {
				if(e.params[0] == currentBPM)
					continue;

				var steps:Float = (e.time - curTime) / ((60 / currentBPM) * 1000 / 4);
				curStepEvent += steps;
				curTime = e.time;
				currentBPM = e.params[0];

				bpmChanges.push({
					step: curStepEvent,
					time: curTime,
					bpm: currentBPM
				});
			}
		}
	}

	public static function update() {
		var bpmChange:BPMChangeEvent = {
			step: 0,
			time: 0,
			bpm: 0
		};

		for (bpmEvent in bpmChanges) {
			if (songPosition >= bpmEvent.time) {
				bpmChange = bpmEvent;
				break;
			}
		}

		if (bpmChange.bpm > 0 && bpm != bpmChange.bpm)
			bpm = bpmChange.bpm;

		var oldStep:Int = curStep;
		curStep = Math.floor((bpmChange.step + (songPosition - bpmChange.time) / stepCrochet));

		curBeat = Math.floor(curStep / 4);

		if(oldStep != curStep)
			stepHit(curStep);
	}

	public static function stepHit(curStep:Int) {
		onStepHit.dispatch(curStep);
		if (curStep % 4 == 0)
			beatHit(curBeat);
	}

	public static function beatHit(curBeat:Int) {
		onBeatHit.dispatch(curBeat);
	}
}