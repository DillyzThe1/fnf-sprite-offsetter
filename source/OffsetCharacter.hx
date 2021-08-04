package;

import openfl.display.BitmapData;
import flixel.system.FlxAssets;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import lime.utils.Assets;
import lime.graphics.Image;
#if cpp
import sys.FileSystem;
import sys.io.File;
#end
using StringTools;

class OffsetCharacter extends Character
{
    public var animNames:Array<String> = new Array<String>();
    public var charLocation:String;
    public var charDir:String;
    public var preventOffsetChange:Bool = false;

    public function new(x:Float,y:Float,?charLocation:String = 'Pico_FNF_assetss',?charDir:String = 'pico',?right:Bool = false) 
    {

        super(x,y,'custom',right,true);
        this.charLocation = charLocation;
        this.charDir = charDir;

        #if cpp
        var animInfo = parseTextFile('assets/custom-characters/$charDir/$charLocation.txt');
        var hackerReal = parseWithPrecaution('assets/exports/ForKE1.6/$charLocation' + (right ? '-right' : '-left') + 'Offsets.txt');

        var img = BitmapData.fromImage(Image.fromFile('assets/custom-characters/$charDir/$charLocation.png'));
        var xml = File.getContent('assets/custom-characters/$charDir/$charLocation.xml');
        frames = FlxAtlasFrames.fromSparrow(img,xml);

        for (i in animInfo)
        {
            var animStuff = i.split(':');
            if (animStuff[0] != 'flip')
            {
                animNames.push(animStuff[0]);
                animation.addByPrefix(animStuff[0], animStuff[1], 24, false);
                addOffset(animStuff[0]);
            }
            else this.flip(animStuff[1] == 'true');
        }

        for (i in hackerReal)
        {
            var stuff = i.split(' ');

            addOffset(stuff[0],Std.parseInt(stuff[1]),Std.parseInt(stuff[2]));
            this.preventOffsetChange = true;
        }

        if (right) this.flip();

        playAnim('idle');

        dance();
        #end
    }

    public function parseWithPrecaution(path:String):Array<String>
    {
        #if cpp
        if (FileSystem.exists(FileSystem.absolutePath(path)))
        {
            var a:Array<String> = File.getContent(path).trim().split('\n');
            for (i in 0...a.length) a[i] = a[i].trim();
            trace('offsets found! pogrz!');
            return a;
        }
        else trace('no KE offset file found!');
        #end
        return [];
    }

    public function parseTextFile(path:String):Array<String>
    {
        #if cpp
        var a:Array<String> = File.getContent(path).trim().split('\n');
        for (i in 0...a.length) a[i] = a[i].trim();
        return a;
        #end
        return [];
    }
}