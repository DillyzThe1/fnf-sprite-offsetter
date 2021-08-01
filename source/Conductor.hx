package;

typedef BPMChangeEvent = {
    var stepTime:Int;
    var songTime:Float;
    var bpm:Int;
}

class Conductor
{
    public static var bpm:Int = 100;
    public static var crochet:Float = ((60 / bpm) * 1000);
    public static var stepCrochet:Float = crochet / 4;
    public static var songPos:Float;
    public static var lastSongPos:Float;
    public static var offset:Float = 0;

    public static var safeFrames:Int = 10;
    public static var safeZoneOffsets:Float = (safeFrames / 60) * 100;

    public static var bpmChangeMap:Array<BPMChangeEvent> = [];

    public function new() {}

    public static function changeBPM(newBPM:Int)
    {
        bpm = newBPM;

        crochet = ((60 / bpm) * 1000);
        stepCrochet = crochet / 4;
    }
}