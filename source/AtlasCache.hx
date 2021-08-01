package;

import flixel.graphics.frames.FlxFramesCollection;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;

class AtlasCache
{
    public static var instance:AtlasCache;
    public static var assetPaths:Map<String,PathLibrary> = new Map<String,PathLibrary>(); // key, path, & library
    public var cachedTextures:Map<String,FlxFramesCollection>; // key & atlasframes

    public function new()
    {
        instance = this;
        this.cachedTextures = new Map<String,FlxFramesCollection>();
    }

    public static function checkInstance():Bool
    {
        if (instance == null) 
        {
            instance = new AtlasCache();
            setAssetPaths();
            return false;
        }
        return false;
    }

    public static function setAssetPaths()
    {
        assetPaths = new Map<String,PathLibrary>();
        var keys = ['titleBump','gfDance','subTitleBump','titleEnter','boyfriend','girlfriend','dad'];
        var paths = ['sprites/logoBumpin','sprites/gfDanceTitle','sprites/offtest_logo','sprites/titleEnter','BOYFRIEND','GF_assets',
                    'DADDY_DEAREST'];
        var libs = ['title','title','title','title','char','char','char'];

        for (i in 0...keys.length)
        {
            assetPaths.set(keys[i],new PathLibrary(paths[i],libs[i]));
        }
        
    }

    public static function getCachedTexture(key:String)
    {
        checkInstance();
        return instance.obtainTextureAtlas(key);
    }


    public function obtainTextureAtlas(key:String):FlxFramesCollection
    {
        var cached = cachedTextures.get(key);
        if (cached == null)
        {
            trace("The key '" + key + "' is loading into cache.");
            var assetInfo:PathLibrary = assetPaths.get(key);
            var atlas:FlxFramesCollection = Paths.getSparrowAtlas(assetInfo.path,assetInfo.library);
            cachedTextures.set(key,atlas);//atlas);
            var item = cachedTextures.get(key);
            //trace(item);
            return item;
        }
        else 
        {
            trace("The key '" + key + "' was loaded from cache.");
            var assetInfo:PathLibrary = assetPaths.get(key);
            var item:FlxFramesCollection = Paths.getSparrowAtlas(assetInfo.path,assetInfo.library);
            //trace(item);
            return item;
        }
    }
}

class PathLibrary
{
    public var path:String;
    public var library:String;

    public function new(newPath:String,newLibrary:String)
    {
        path = newPath;
        library = newLibrary;
    }

    public function update(updatedPath:String,updatedLibrary:String)
    {
        path = updatedPath;
        library = updatedLibrary;
    }
}