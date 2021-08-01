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

    public function new(x:Float,y:Float,?charLocation:String = 'Pico_FNF_assetss') 
    {

        super(x,y,'custom',false,true);
        this.charLocation = charLocation;

        #if cpp
        var path = 'assets/custom-characters/' + charLocation + '.txt';
        #else
        var path = Paths.txt(charLocation,'other-char');
        #end
        trace (path);
        var animInfo = parseTextFile(path);//

        //FlxAssets.getBitmapData('assets/custom-characters/' + charLocation + '.png');

        var img = BitmapData.fromImage(Image.fromFile('assets/custom-characters/' + charLocation + '.png'));
        #if cpp
        //FlxGraphic.fromAssetKey('assets/custom-characters/' + charLocation + '.png');
        var xml = File.getContent('assets/custom-characters/' + charLocation + '.xml');
        trace(img);
        //trace(xml);
        frames = FlxAtlasFrames.fromSparrow(img,xml);
        #else
        frames = Paths.getSparrowAtlas(charLocation,'other-char');
        #end

        for (i in animInfo)
        {
            var animStuff = i.split(':');
            if (animStuff[0] != 'flip')
            {
                animNames.push(animStuff[0]);
                animation.addByPrefix(animStuff[0], animStuff[1], 24, false);
                addOffset(animStuff[0]);
                trace(animStuff[0] + ' added from ' + charLocation + ' as ' + animStuff[1]);
            }
            else this.flip(animStuff[1] == 'true');
        }

        playAnim('idle');

        dance();
    }

    public function parseTextFile(path:String)
    {
        #if cpp
        trace(path);
        var a:Array<String> = File.getContent(path).trim().split('\n');
        trace(a);
        for (i in 0...a.length) a[i] = a[i].trim();
        return a;
        #else
        var list:Array<String> = Assets.getText(path).trim().split('\n');
        for (i in 0...list.length) list[i] = list[i].trim();
        return list;
        #end
    }
}