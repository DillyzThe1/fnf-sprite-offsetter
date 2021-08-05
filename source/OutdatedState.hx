package;

import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
using StringTools;

// based on https://github.com/KadeDev/Kade-Engine/blob/stable/source/OutdatedSubState.hx
class OutdatedState extends MusicBeatState
{
    public static var curVers:String = '1.1.2';
    public static var goodVers:String = '1.0.0';
    public static var releaseVers = 3;
    public static var newRelease = 1;
    public static var changeList:String = '- removed herobrine';

    public static var ignored:Bool = false;

    public var versText:FlxText;

    private var bgColors:Array<String> = [
		'#00FFFF',
		'#51FF00',
		'#AE00FF',
		'#FF0000'
	];
	private var colorRotation:Int = 1;

    public function new(update:String,data:String,newRelVers:Int)
    {
        goodVers = update;
        changeList = data;
        newRelease = newRelVers;
        super();
    }

    override function create()
    {
        super.create();
        var bg = new FlxSprite().loadGraphic(Paths.image('outdated','img'));
        bg.setGraphicSize(FlxG.width,FlxG.height);
        bg.antialiasing = true;

        versText = new FlxText(0,45,FlxG.width,getReleaseText(),32);
        versText.alignment = FlxTextAlign.CENTER;
        versText.screenCenter(X);
        versText.x -= FlxG.width * 0.01;

        // I STOLE ALL THIS FROM KADEDEV LEL
        FlxTween.color(bg, 2, bg.color, FlxColor.fromString(bgColors[colorRotation]));
        new FlxTimer().start(2, function(tmr:FlxTimer)
        {
            FlxTween.color(bg, 2, bg.color, FlxColor.fromString(bgColors[colorRotation]));
            if(colorRotation < (bgColors.length - 1)) colorRotation++;
            else colorRotation = 0;

            tmr.reset();
        });

        add(bg);
        add(versText);
    }

    override function update(elapsed:Float)
    {
        var keyArray = [FlxG.keys.justPressed.ENTER,FlxG.keys.justPressed.ESCAPE];
        if (keyArray[0])
        {
            var link = "https://github.com/DillyzThe1/fnf-sprite-offsetter/releases";
            #if linux
            Sys.command('/usr/bin/xdg-open', [link, "&"]);
            #else
            FlxG.openURL(link);
            #end
        }
        else if (keyArray[1])
        {
            ignored = true;
            FlxG.switchState(new CharacterSelectionState());
        }
        super.update(elapsed);
    }

    public function getReleaseText():String
    {
        if (newRelease < releaseVers)
            return "Wait, you're on a pre-release!\n"
                    + "You're on " + curVers
                    + ',\nbut the stable version is $goodVers!'
                    + '\n\nWorking stuff:\n'
                    + changeList
                    + '\n\nHit ENTER to get a stable build!'
                    + '\nHit ESCAPE to IGNORE!!!!';
        
        return "Wait, you're outdated!\nYou're on "
            + curVers
            + '.\nBut, the most recent version is $goodVers.'
            + '\n\nNew stuff:\n'
            + changeList
            + '\n\nHit ENTER to open the release tab!'
            + '\nHit ESCAPE to IGNORE!!!!';
    }
}