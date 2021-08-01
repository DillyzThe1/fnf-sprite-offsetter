package;

import flixel.FlxSprite;

using StringTools;

class Character extends FlxSprite
{
    public var offsets:Map<String,Array<Dynamic>>;
    public var isRight:Bool = false;
    public var curChar:String = 'bf';
    
    public function new(x:Float,y:Float,?char:String = 'bf',?isRight:Bool = false,?skipMe:Bool = false)
    {
        super(x,y);

        offsets = new Map<String, Array<Dynamic>>();
        curChar = char;
        this.isRight = isRight;

        antialiasing = true;

        if (!skipMe)
        {
            switch (curChar)
            {
                case 'gf':
                    frames = AtlasCache.getCachedTexture('girlfriend');
                    animation.addByPrefix('cheer', 'GF Cheer', 24, false);
                    animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
                    animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

                    addOffset('cheer');
                    addOffset('danceLeft', 0, -9);
                    addOffset('danceRight', 0, -9);

                    playAnim('danceRight');
                case 'bf':
                    frames = AtlasCache.getCachedTexture('boyfriend');
                    animation.addByPrefix('idle', 'BF idle dance', 24, false);
                    animation.addByPrefix('hey', 'BF HEY', 24, false);

                    addOffset('idle', -5);
                    addOffset("hey", 7, 4);

                    playAnim('idle');
                case 'dad':
                    frames = AtlasCache.getCachedTexture('dad');
                    animation.addByPrefix('idle', 'Dad idle dance', 24);
                    animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);

                    addOffset('idle');
                    addOffset("singUP", -6, 50);

                    playAnim('idle');
            }
            dance();
        }

        
    }
    
    public function flip(?forceDir:Null<Bool> = false)
    {
        if (forceDir != null) this.flipX = forceDir;
        else this.flipX = !this.flipX;
    }

    var danced:Bool = false;

    public function dance()
    {
        switch (curChar)
        {
            default:
                if (curChar.startsWith('gf'))
                {
                    if (!animation.curAnim.name.startsWith('hair'))
                    {
                        danced = !danced;

                        if (danced)
                            playAnim('danceRight');
                        else
                            playAnim('danceLeft');
                    }
                }
                playAnim('idle');
        }
    }

    public function playAnim(name:String,force:Bool = false,reverse:Bool = false,frame:Int = 0)
    {
        animation.play(name,force,reverse,frame);

        var off = offsets.get(name);
        if (offsets.exists(name)) offset.set(off[0],off[1]);
        else offset.set(0,0);
    }

    public function addOffset(name:String,x:Float = 0,y:Float = 0)
    {
        offsets.set(name, [x,y]);
    }
}