package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
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
    public var customCharDir:String = 'pico';
    private var charOnRight:Bool = false;
    private var starterOffsets:Map<String,Array<Dynamic>>;

    private var camFollow:FlxObject;
    private var defZoom:Float = 0;

    var gameOffset:FlxText;
    var spriteOffset:FlxText;
    var curAnim:Int = 0;
    var animDispaly:FlxText;

    var reminderText:FlxText;

    var camGame:FlxCamera;
    var camHUD:FlxCamera;

    public function new(customChar:String = 'Pico_FNF_assetss',charDir:String = 'pico',?flip:Bool = false,?animOffsets:Map<String,Array<Dynamic>> = null)
    {
        super();
        this.customCharName = customChar;
        this.charOnRight = flip;
        this.starterOffsets = animOffsets;
        this.customCharDir = charDir;
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
        if (!charOnRight)
        {
            offsetChar = new OffsetCharacter(100,100,customCharName,customCharDir,false);
            ghostChar = new OffsetCharacter(100,100,customCharName,customCharDir,false);
        }
        else
        {
            offsetChar = new OffsetCharacter(770,450,customCharName,customCharDir,true);
            ghostChar = new OffsetCharacter(770,450,customCharName,customCharDir,true);
        }
        if (starterOffsets != null && !offsetChar.preventOffsetChange) offsetChar.offsets = starterOffsets;
        ghostChar.alpha = 0.5;

        add(gf);
        add(dad);
        if (charOnRight) add(boyfriend);
        add(ghostChar);
        add(offsetChar);
        if (!charOnRight) add(boyfriend);
		
        var chips = 85;
        var crisps = 125;

        gameOffset = new FlxText(100 - chips, 150 - crisps, 0,
			"X and Y is controlled with WASD\nOffsets are controlled with SHIFT + WASD", 20);
		add(gameOffset);

        spriteOffset = new FlxText(100 - chips, 200 - crisps, 0,
			"Hit Q&E to swap animations.\nHit CONTROL + arrow keys to zoom, and normal arrow keys to move the camera.", 20);
		add(spriteOffset);

        reminderText = new FlxText(100 - chips, 250 - crisps, 0,
			'Hit space to swap sides, and V to preview the in-game camera.', 20);
		add(reminderText);

        camGame = new FlxCamera();
        camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(690, 480);
		add(camFollow);
        camHUD = new FlxCamera();
        camHUD.bgColor.alpha = 0;
        
        FlxG.cameras.reset(camGame);
        FlxG.cameras.add(camHUD,false);
        FlxG.camera.follow(camFollow, LOCKON, 0.04);
		FlxG.camera.zoom = defZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

        gameOffset.cameras = [camHUD];
        spriteOffset.cameras = [camHUD];
        reminderText.cameras = [camHUD];

        super.create();
    }

    public function getOffsetPos():Offset
    {
        if (charOnRight) return new Offset(770,450);
        return new Offset(100,100);
    }

    var stopSpammingCamera = false;

    function tweenCam(zoomAmount:Float):Void
    {
        FlxTween.tween(FlxG.camera, {zoom: zoomAmount}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.smootherStepInOut});
    }
        

    override public function update(elapsed:Float)
    {
        if (FlxG.sound.music != null) Conductor.songPos = FlxG.sound.music.time;
        FlxG.watch.addQuick('funni beat', curBeat);
        FlxG.watch.addQuick('funni step', curStep);

        var shiftHeld = FlxG.keys.pressed.SHIFT;
        var controlHeld = FlxG.keys.pressed.CONTROL;

        var topActionArray = [FlxG.keys.justPressed.SPACE,FlxG.keys.justPressed.ESCAPE,FlxG.keys.justPressed.Q,
                                FlxG.keys.justPressed.E,FlxG.keys.justPressed.ENTER,FlxG.keys.justPressed.C,FlxG.keys.justPressed.V];

        if (topActionArray.contains(true)) 
        {
            for (i in 0...topActionArray.length)
                if (topActionArray[i] == true)
                {
                    switch (i)
                    {
                        case 0:
                            FlxG.switchState(new OffsetState(customCharName,customCharDir,!charOnRight,offsetChar.offsets));
                        case 1:
                            FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.1);
                            FlxG.sound.music.fadeIn(4, 0, 0.7);
                            Conductor.changeBPM(102);
                            FlxG.switchState(new CharacterSelectionState());
                            FlxG.sound.play(Paths.sound('cancelMenu','title'));
                        case 2: changeAnim(-1);
                        case 3: changeAnim(1);
                        case 4: 
                            #if cpp
                            var content:String = "Offsets for '" + customCharName + "' on the " + (charOnRight ? 'right' : 'left') + ' side.';
                            content += '\nIn-game basic offsets (add ' + getOffsetPos().x + ',' + getOffsetPos().y + ' as default place): X' + (offsetChar.x - getOffsetPos().x) + " Y" + (offsetChar.y - getOffsetPos().y);
                            for (i in offsetChar.animNames) content += "\nAnimation '" + i + "' offsets: " + offsetChar.offsets[i];
                            sys.io.File.saveContent('assets/exports/' + customCharName + (charOnRight ? '-right' : '-left') + '.txt',content);
                            trace('Exported content!');

                            content = "";
                            for (i in offsetChar.animNames) content += i + " " + offsetChar.offsets[i][0] + " " + offsetChar.offsets[i][1] + "\n";
                            sys.io.File.saveContent('assets/exports/ForKE1.6/$customCharName' + (charOnRight ? '-right' : '-left') + 'Offsets.txt',content);
                            trace('Exported offset content!');

                            Sys.command('start .\\assets\\exports\\');
                            #else
                            trace("Can't save content :(");
                            #end
                        case 5: resetOffsetText();
                        case 6: 
                            if (!stopSpammingCamera)
                            {
                                stopSpammingCamera = true;
                                var ex = camFollow.x;
                                var dee = camFollow.y;
                                var zoom = FlxG.camera.zoom;
                                tweenCam(defZoom);
                                if (charOnRight) camFollow.setPosition(offsetChar.getMidpoint().x - 100, offsetChar.getMidpoint().y - 100);
                                else camFollow.setPosition(offsetChar.getMidpoint().x + 150, offsetChar.getMidpoint().y - 100);
                                new FlxTimer().start(2, function(tmr:FlxTimer)
                                {
                                    if (charOnRight) camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
                                    else camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
                                    new FlxTimer().start(1.25, function(tmr:FlxTimer)
                                    {
                                        tweenCam(zoom);
                                        camFollow.setPosition(ex, dee);
                                        stopSpammingCamera = false;
                                    });
                                });
                            }
                    }
                }
        }

        

        var camArray = [FlxG.keys.pressed.UP,FlxG.keys.pressed.DOWN,FlxG.keys.pressed.LEFT,FlxG.keys.pressed.RIGHT];
        if (camArray.contains(true) && !stopSpammingCamera)
            for (i in 0...camArray.length)
                if (camArray[i] == true)
                {
                    var multiplier = (shiftHeld ? 5 : 1);
                    if (!controlHeld)
                    {
                        switch (i) 
                        {
                            case 0:
                                camFollow.y -= 1 * multiplier;
                            case 1:
                                camFollow.y += 1 * multiplier;
                            case 2:
                                camFollow.x -= 1 * multiplier;
                            case 3:
                                camFollow.x += 1 * multiplier;
                        }
                    }
                    else
                    {
                        switch (i)
                        {
                            case 0:
                                FlxG.camera.zoom += (shiftHeld ? 0.10 : 0.025);
                            case 1:
                                FlxG.camera.zoom -= (shiftHeld ? 0.10 : 0.025);
                        }
                    }
                    FlxG.camera.focusOn(camFollow.getPosition());
                }

        var moveArray = [FlxG.keys.pressed.W,FlxG.keys.pressed.S,FlxG.keys.pressed.A,FlxG.keys.pressed.D];
        if (moveArray.contains(true))
            for (i in 0...moveArray.length)
                if (moveArray[i] == true)
                {
                    var anim = offsetChar.animNames[curAnim];
                    if (!shiftHeld)
                    {
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
                        }
                    }
                    else
                    {
                        switch (i)
                        {
                            case 0:
                                offsetChar.offsets[anim][1] += 1;
                            case 1:
                                offsetChar.offsets[anim][1] -= 1;
                            case 2:
                                offsetChar.offsets[anim][0] += 1;
                            case 3:
                                offsetChar.offsets[anim][0] -= 1;
                        }
                    }
                    
                    if (![8,9].contains(i)) updateOffsetText();
                    
                }

        super.update(elapsed);
    }

    public function resetOffsetText()
    {
        gameOffset.text = "X and Y is controlled with WASD\nOffsets are controlled with SHIFT + WASD";
        spriteOffset.text = "Hit Q&E to swap animations.\nHit CONTROL + arrow keys to zoom, and normal arrow keys to move the camera.";
        reminderText.text = 'Hit space to swap sides, and V to preview the in-game camera.';
    }

    public function updateOffsetText()
    {
        var anim = offsetChar.animNames[curAnim];
        offsetChar.playAnim(offsetChar.animNames[curAnim],true);
        gameOffset.text = 'Character offsets: X' + (offsetChar.x - getOffsetPos().x) + ' Y' + (offsetChar.y - getOffsetPos().y) + '\n(these are added with ' + getOffsetPos().x + ',' + getOffsetPos().y +')';
        spriteOffset.text = "Anim: '" + anim + "'\nOffsets: X" + offsetChar.offsets[anim][0] + " Y" + offsetChar.offsets[anim][1];
        ghostChar.setPosition(offsetChar.getPosition().x,offsetChar.getPosition().y);
        ghostChar.offsets['idle'] = offsetChar.offsets['idle'];
        reminderText.text = "Hit C to view controls, and Enter to export.";
    }

    public function changeAnim(?amount:Int)
    {
        curAnim += amount;
        if (curAnim > offsetChar.animNames.length - 1) curAnim = 0;
        else if (curAnim < 0) curAnim = offsetChar.animNames.length - 1;

        updateOffsetText();
        //var anim = offsetChar.animNames[curAnim];
        //spriteOffset.text = "Anim: '" + anim + "'\nOffsets: X" + offsetChar.offsets[anim][0] + " Y" + offsetChar.offsets[anim][1];
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

class Offset
{
    public var x:Int;
    public var y:Int;
    public function new(x:Int,y:Int)
    {
        this.x = x;
        this.y = y;
    }
}