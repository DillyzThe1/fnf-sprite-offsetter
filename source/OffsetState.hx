package;

import flixel.text.FlxText;
import flixel.*;
import Random;
using StringTools;

class OffsetState extends MusicBeatState
{
    private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;
    private var offsetChar:OffsetCharacter;
    private var ghostChar:OffsetCharacter;

    public var backStage:FlxSprite;
    public var frontStage:FlxSprite;
    public var curtains:FlxSprite;

    public var customCharName:String = 'Pico_FNF_assetss';

    private var camFollow:FlxObject;
    private var defZoom:Float = 0;

    var gameOffset:FlxText;
    var spriteOffset:FlxText;
    var curAnim:Int = 0;
    var animDispaly:FlxText;

    public function new(customChar:String = 'Pico_FNF_assetss')
    {
        super();
        this.customCharName = customChar;
    }

    override public function create()
    {
        if (FlxG.sound.music != null) FlxG.sound.music.stop();

        FlxG.sound.playMusic(Paths.music('bopeebo'), 0.1);
        FlxG.sound.music.fadeIn(4, 0, 0.7);
        Conductor.changeBPM(100);

        defZoom = 0.9;
        backStage = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback','img'));
        backStage.antialiasing = true;
        backStage.scrollFactor.set(0.9, 0.9);
        backStage.active = false;

        frontStage = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront','img'));
        frontStage.setGraphicSize(Std.int(frontStage.width * 1.1));
        frontStage.updateHitbox();
        frontStage.antialiasing = true;
        frontStage.scrollFactor.set(0.9, 0.9);
        frontStage.active = false;

        curtains = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains','img'));
        curtains.setGraphicSize(Std.int(curtains.width * 0.9));
        curtains.updateHitbox();
        curtains.antialiasing = true;
        curtains.scrollFactor.set(1.3, 1.3);
        curtains.active = false;

        add(backStage);
        add(frontStage);
        add(curtains);


        gf = new Character(400, 130, 'gf');
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, 'dad');

        boyfriend = new Boyfriend(770, 450, 'bf');
        offsetChar = new OffsetCharacter(100,100,customCharName);
        ghostChar = new OffsetCharacter(100,100,customCharName);
        ghostChar.alpha = 0.5;

        add(gf);
        add(dad);
        add(ghostChar);
        add(offsetChar);
		add(boyfriend);

        gameOffset = new FlxText(100, 150, 0,
			"X and Y is controlled with WASD\nOffsets are controlled with IJKL", 20);
		add(gameOffset);

        spriteOffset = new FlxText(100, 200, 0,
			"null", 20);
		add(spriteOffset);

        camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(690, 480);
		add(camFollow);

        FlxG.camera.follow(camFollow, LOCKON, 0.04);
		FlxG.camera.zoom = defZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

        super.create();
    }

    override public function update(elapsed:Float)
    {
        if (FlxG.sound.music != null) Conductor.songPos = FlxG.sound.music.time;
        FlxG.watch.addQuick('funni beat', curBeat);
        FlxG.watch.addQuick('funni step', curStep);


        var topActionArray = [FlxG.keys.justPressed.R,FlxG.keys.justPressed.ESCAPE,FlxG.keys.justPressed.Q,
                                FlxG.keys.justPressed.E,FlxG.keys.justPressed.ENTER];

        if (topActionArray.contains(true)) 
        {
            for (i in 0...topActionArray.length)
                if (topActionArray[i] == true)
                {
                    switch (i)
                    {
                        case 0:
                            FlxG.switchState(new OffsetState(customCharName));
                        case 1:
                            FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.1);
                            FlxG.sound.music.fadeIn(4, 0, 0.7);
                            Conductor.changeBPM(102);
                            FlxG.switchState(new CharacterSelectionState());
                        case 2: changeAnim(-1);
                        case 3: changeAnim(1);
                        case 4: 
                            #if cpp
                            var content:String = "Offsets for '" + customCharName + "'";
                            content += '\nIn-game basic offsets (add 100,100 as default place): X' + (offsetChar.x - 100) + " Y" + (offsetChar.y - 100);
                            for (i in offsetChar.animNames) content += "\nAnimation '" + i + "' offsets: " + offsetChar.offsets[i];
                            sys.io.File.saveContent('assets/exports/' + customCharName + '.txt',content);
                            trace('Exported content!');
                            #else
                            trace("Can't save content :(");
                            #end
                    }
                }
        }

        var camArray = [FlxG.keys.pressed.UP,FlxG.keys.pressed.DOWN,FlxG.keys.pressed.LEFT,FlxG.keys.pressed.RIGHT];
        if (camArray.contains(true))
            for (i in 0...camArray.length)
                if (camArray[i] == true)
                {
                    switch (i)
                    {
                        case 0:
                            camFollow.y -= 1;
                        case 1:
                            camFollow.y += 1;
                        case 2:
                            camFollow.x -= 1;
                        case 3:
                            camFollow.x += 1;
                    }
                    FlxG.camera.focusOn(camFollow.getPosition());
                }

        var moveArray = [FlxG.keys.pressed.W,FlxG.keys.pressed.S,FlxG.keys.pressed.A,FlxG.keys.pressed.D,
                        FlxG.keys.pressed.I,FlxG.keys.pressed.K,FlxG.keys.pressed.J,FlxG.keys.pressed.L,
                        FlxG.keys.pressed.U, FlxG.keys.pressed.O];
        if (moveArray.contains(true))
            for (i in 0...moveArray.length)
                if (moveArray[i] == true)
                {
                    var anim = offsetChar.animNames[curAnim];
                    switch (i)
                    {
                        case 0:
                            offsetChar.y -= 1;
                        case 1:
                            offsetChar.y += 1;
                        case 2:
                            offsetChar.x -= 1;
                        case 3:
                            offsetChar.x += 1;
                        case 4:
                            offsetChar.offsets[anim][1] += 1;
                        case 5:
                            offsetChar.offsets[anim][1] -= 1;
                        case 6:
                            offsetChar.offsets[anim][0] += 1;
                        case 7:
                            offsetChar.offsets[anim][0] -= 1;
                        case 8:
                            FlxG.camera.zoom += 0.05;
                        case 9:
                            FlxG.camera.zoom -= 0.05;
                    }
                    if (![8,9].contains(i))
                    {
                        offsetChar.playAnim(offsetChar.animNames[curAnim],true);
                        gameOffset.text = 'Character offsets: X' + (offsetChar.x - 100) + ' Y' + (offsetChar.y - 100) + '\n(these are added with 100,100)';
                        spriteOffset.text = "Anim: '" + anim + "'\nOffsets: X" + offsetChar.offsets[anim][0] + " Y" + offsetChar.offsets[anim][1];
                        ghostChar.setPosition(offsetChar.getPosition().x,offsetChar.getPosition().y);
                        ghostChar.offsets['idle'] = offsetChar.offsets['idle'];
                    }
                    
                }

        super.update(elapsed);
    }

    public function changeAnim(?amount:Int)
    {
        curAnim += amount;
        if (curAnim > offsetChar.animNames.length - 1) curAnim = 0;
        else if (curAnim < 0) curAnim = offsetChar.animNames.length - 1;

        var anim = offsetChar.animNames[curAnim];
        spriteOffset.text = "Anim: '" + anim + "'\nOffsets: X" + offsetChar.offsets[anim][0] + " Y" + offsetChar.offsets[anim][1];
    }

    override function beatHit()
    {
        super.beatHit();

        if ([8,16,24,32,40,48,49,56,64,72,88,96,104,112,113,120,128].contains(curBeat)) 
        {
            gf.playAnim('cheer'); // again, i recommend using a non-hardcoded method.
            boyfriend.playAnim('hey');
            offsetChar.playAnim(offsetChar.animNames[curAnim]);
            ghostChar.dance();
            dad.playAnim('singUP');
        }
        else 
        {
            gf.dance();
            dad.dance();
            boyfriend.dance();
            offsetChar.playAnim(offsetChar.animNames[curAnim]);
            ghostChar.dance();
        }
    }
}