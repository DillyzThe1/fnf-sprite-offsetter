package;

import flixel.addons.display.FlxGridOverlay;
import flixel.FlxG;
import flixel.FlxSprite;

class CacheDebugState extends MusicBeatState
{
    public var gfDance:FlxSprite;
    public var danceLeft:Bool;

    public function new(?selection:String = 'none')
    {
        super();
        trace(selection);
    }

    override public function create()
    {
        super.create();

        persistentUpdate = true;

        var gridBG:FlxSprite = FlxGridOverlay.create(10, 10);
		gridBG.scrollFactor.set(0.5, 0.5);
		add(gridBG);

        gfDance = new FlxSprite(272, 31);
		gfDance.frames = AtlasCache.getCachedTexture('girlfriend');//Paths.getSparrowAtlas('sprites/gfDanceTitle','title');
		gfDance.animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
        gfDance.animation.addByPrefix('cheer', 'GF Cheer', 24, false);
		gfDance.antialiasing = true;
        add(gfDance);
    }

    override public function update(elapsed:Float)
    {
        if (FlxG.sound.music != null)
			Conductor.songPos = FlxG.sound.music.time;

        FlxG.watch.addQuick('funni beat', curBeat);
        FlxG.watch.addQuick('funni step', curStep);


        var moveArray = [FlxG.keys.pressed.UP,FlxG.keys.pressed.DOWN,FlxG.keys.pressed.LEFT,FlxG.keys.pressed.RIGHT];
        var topActionArray = [FlxG.keys.justPressed.R,FlxG.keys.justPressed.ESCAPE];

        if (topActionArray.contains(true)) 
        {
            for (i in 0...topActionArray.length)
                if (topActionArray[i] == true)
                {
                    switch (i)
                    {
                        case 0:
                            FlxG.switchState(new CacheDebugState());
                        case 1:
                            FlxG.switchState(new TitleState());
                    }
                }
        }
        else
        {
            if (moveArray.contains(true))
                for (i in 0...moveArray.length)
                    if (moveArray[i] == true)
                    {
                        switch (i)
                        {
                            case 0:
                                gfDance.y -= 1;
                            case 1:
                                gfDance.y += 1;
                            case 2:
                                gfDance.x -= 1;
                            case 3:
                                gfDance.x += 1;
                        }
                    }
            if (FlxG.keys.justPressed.SPACE) trace('GF POSITION: X' + gfDance.x + ' Y' + gfDance.y);
        }

        super.update(elapsed);
    }

    override function beatHit()
    {
        super.beatHit();

        danceLeft = !danceLeft;

        if ([7,23,39,55,71,87,103,119,135,151,167,183].contains(curBeat)) gfDance.animation.play('cheer'); // again, i recommend using a non-hardcoded method.
        else gfDance.animation.play('dance' + (danceLeft ? 'Left' : 'Right'));
    }
}