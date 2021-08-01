package;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
#if cpp
import sys.FileSystem;
import sys.io.File;
#end

class CharacterSelectionState extends MusicBeatState
{
    public var characters:Array<String> = new Array<String>();

    var curSel:Int = 0;
    var grpStuff:FlxTypedGroup<Alphabet>;
    
    public function new() {super();}

    override function create()
    {
        super.create();

        #if cpp
        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/custom-characters")))
        {
            if (!StringTools.endsWith(i,".png"))
                continue;
            
            characters.push(i.split('.')[0]);
        }
        #else
        trace('C++ is NOT active. Cannot reach files!');
        characters.push('error');
        #end

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue','img'));
		add(bg);

        grpStuff = new FlxTypedGroup<Alphabet>();
		add(grpStuff);

        for (i in 0...characters.length)
        {
            var txt:Alphabet = new Alphabet(0, (70 * i) + 30, characters[i], true, false);
            txt.targetY = i;
            txt.x += 25;
            grpStuff.add(txt);
        }

        changeSelection();
    }

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
                        case 3:
                            FlxG.switchState(new OffsetState(characters[curSel]));
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