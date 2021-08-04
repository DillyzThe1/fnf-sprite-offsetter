package;

import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
#if cpp
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class CharacterSelectionState extends MusicBeatState
{
    public var characters:Array<String> = new Array<String>();
    public var charDir:Array<String> = new Array<String>();

    var curSel:Int = 0;
    var grpStuff:FlxTypedGroup<Alphabet>;
    
    public function new() {super();}

    override function create()
    {
        super.create();

        #if cpp
        for (dir in FileSystem.readDirectory("assets/custom-characters/"))
        {
            if (dir.endsWith('.txt') || dir.endsWith('.png') || dir.endsWith('.xml'))
                continue;

            for (file in FileSystem.readDirectory("assets/custom-characters/" + dir))
            {
                if (!file.endsWith('.png'))
                    continue;
                
                var assetName = file.split('.png')[0];
                characters.push(assetName);
                charDir.push(dir);
                trace(assetName + " at " + dir);
            }
            
           //characters.push(i.split('.')[0]);
        }
        #else
        trace('C++ is NOT active. Cannot reach files!');
        characters.push('error');
        charDir.push('error');
        #end

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue','img'));
		add(bg);

        grpStuff = new FlxTypedGroup<Alphabet>();
		add(grpStuff);

        for (i in 0...charDir.length)
        {
            var txt:Alphabet = new Alphabet(0, (70 * i) + 30, charDir[i], true, false);
            txt.targetY = i;
            txt.x += 25;
            grpStuff.add(txt);
        }

        changeSelection();
    }

    var inTransition:Bool = false;

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        var topActionArray = [FlxG.keys.justPressed.UP,FlxG.keys.justPressed.DOWN,FlxG.keys.justPressed.ESCAPE,FlxG.keys.justPressed.ENTER];

        if (topActionArray.contains(true)) 
        {
            for (i in 0...topActionArray.length)
                if (topActionArray[i] == true)
                {
                    switch (i)
                    {
                        case 0:
                            changeSelection(-1);
                        case 1:
                            changeSelection(1);
                        case 2:
                            FlxG.switchState(new TitleState());
                            FlxG.sound.play(Paths.sound('cancelMenu','title'));
                        case 3:
                            if (!inTransition)
                            {
                                for (item in grpStuff.members)
                                {
                                    item.alpha = 0;
                                    if (item.targetY == 0) item.alpha = 1;
                                }
                    
                                FlxG.camera.flash(FlxColor.WHITE, 1);
                                FlxG.sound.play(Paths.sound('confirmMenu','title'), 0.7);
                    
                                inTransition = true;
                    
                                new FlxTimer().start(2, function(tmr:FlxTimer)
                                {
                                    FlxG.switchState(new OffsetState(characters[curSel],charDir[curSel]));
                                });
                            }
                    }
                }
        }
    }

    public function changeSelection(?amount:Int = 0)
    {
        FlxG.sound.play(Paths.sound('scrollMenu','title'), 0.4);
        curSel += amount;

        if (curSel < 0) curSel = characters.length - 1;
		if (curSel >= characters.length) curSel = 0;

        var hahaFunni:Int = 0;

        for (item in grpStuff.members)
        {
            item.targetY = hahaFunni - curSel;
            hahaFunni++;
            item.alpha = 0.6;
            if (item.targetY == 0) item.alpha = 1;
        }
    }
}