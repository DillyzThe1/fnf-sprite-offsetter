// small reminder: everything is ripped right from fnf or the original version of this lolll
package;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

class Paths
{
    inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

    inline static public function getSparrowAtlas(key:String,?library:String)
    { 
        //trace(image(key, library));
        return FlxAtlasFrames.fromSparrow(image(key, library), file('$key.xml', library));
    }

    inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
    {
        return getPath(file, type, library);
    }

    inline static public function image(key:String, ?library:String)
    {
        return getPath('$key.png', IMAGE, library);
    }

    static function getPath(file:String, type:AssetType, ?library:String = 'char')
    {
        var lib:String;
        switch (library)
        {
            case 'char': lib = 'characters';
            case 'other-char': lib = 'custom-characters';
            case 'music': lib = 'music';
            case 'title': lib = 'title-stuff';
            case 'img': lib = 'images';
            default: lib = 'bruh';
        }

        var levelPath = getFullPath(file, lib);
        //if (OpenFlAssets.exists(levelPath, type)) trace('get real');// return levelPath;
        //levelPath = getFullPath(file, 'characters');

        return levelPath;
    }

    inline static function getFullPath(file:String, library:String)
    {
        return '$library:assets/$library/$file';
    }

    inline static public function music(key:String, ?library:String = 'music')
    {
        return getPath('$key.$SOUND_EXT', MUSIC, library);
    }

    static public function sound(key:String, ?library:String)
    {
        return getPath('sounds/$key.$SOUND_EXT', SOUND, library);
    }

    static public function txt(key:String, ?library:String)
    {
        return getPath('$key.txt', TEXT, library);
    }
}