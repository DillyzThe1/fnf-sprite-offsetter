package;

import Conductor.BPMChangeEvent;
import flixel.addons.ui.FlxUIState;

class MusicBeatState extends FlxUIState
{
    var lastBeat:Float = 0;
    var lastStep:Float = 0;
    var curStep:Int = 0;
    var curBeat:Int = 0;

    override function create()
    {
        super.create();
        trace('music beat state was created');
    }

    override function update(elapsed:Float)
    {
        var oldStep:Int = curStep;

        updateCurStep();
        updateBeat();

        if (oldStep != curStep && curStep > 0) stepHit();

        super.update(elapsed);
    }

    function updateBeat()
    {
        curBeat = Math.floor(curStep / 4);
    }

    function updateCurStep()
    {
        var lastChange:BPMChangeEvent = {
            stepTime: 0,
            songTime: 0,
            bpm: 0
        }

        for (i in 0...Conductor.bpmChangeMap.length)
        {
            if (Conductor.songPos >= Conductor.bpmChangeMap[i].songTime) lastChange = Conductor.bpmChangeMap[i];
        }

        curStep = lastChange.stepTime + Math.floor((Conductor.songPos - lastChange.songTime) / Conductor.stepCrochet);
    }

    function stepHit()
    {
        if (curStep % 4 == 0) beatHit();
    }

    function beatHit()
    {
        // literally nothing lol
    }
}