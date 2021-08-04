package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.system.FlxAssets;
import flixel.util.*;
import flixel.addons.transition.*;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.graphics.FlxGraphic;
import flixel.*;
import flixel.group.FlxGroup;
import flixel.math.*;

class TitleState extends MusicBeatState
{
    public static var init:Bool = false;

    var blackScreen:FlxSprite;
    var credGroup:FlxGroup;
    var textAlpha:Alphabet;
    var textGroup:FlxGroup;
    var githubSpr:FlxSprite;
    var wackyImage:FlxSprite;

    public function new()
    {
        super();
        //create();
    }

    override public function create()
    {
        super.create();

        new FlxTimer().start(1, function(tmr:FlxTimer)
        {
            startIntro();
        });
    }

    var logoBl:FlxSprite;
    var logoB2:FlxSprite;
	var gfDance:FlxSprite;
    var bfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

    function startIntro()
    {
        var doSkip = false;
        if (!init)
        {
            var thing:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
            thing.persist = true;
            thing.destroyOnNoUse = false;

            FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: thing, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: thing, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

            transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

            FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.1);
			FlxG.sound.music.fadeIn(4, 0, 0.7);
            Conductor.changeBPM(102);
        

            var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		    add(bg);
        }
        else doSkip = true;

        persistentUpdate = true;

        logoBl = new FlxSprite(145, -75);
		logoBl.frames = AtlasCache.getCachedTexture('titleBump');//Paths.getSparrowAtlas('sprites/logoBumpin','title');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
        logoBl.antialiasing = true;
		logoBl.updateHitbox();
        

        logoB2 = new FlxSprite(340, 300);
		logoB2.frames = AtlasCache.getCachedTexture('subTitleBump');//Paths.getSparrowAtlas('sprites/offtest_logo','title');
		logoB2.antialiasing = true;
		logoB2.animation.addByPrefix('bump', 'offset bump idle', 24);
        logoB2.setGraphicSize(Std.int(logoB2.width * 0.5));
		logoB2.animation.play('bump');
        logoB2.antialiasing = true;
		logoB2.updateHitbox();

        //gfDance = new FlxSprite(722, 230);
        gfDance = new FlxSprite(742, 120);
		gfDance.frames = AtlasCache.getCachedTexture('girlfriend');// usually 'gfdance' for the title but the cheer is cool
		gfDance.animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
        gfDance.animation.addByPrefix('cheer', 'GF Cheer', 24, false);
		gfDance.antialiasing = true;

        bfDance = new FlxSprite(-38, 350);
		bfDance.frames = AtlasCache.getCachedTexture('boyfriend');//Paths.getSparrowAtlas('sprites/gfDanceTitle','title');
		bfDance.animation.addByPrefix('idle', 'BF idle dance', 24, false);
        bfDance.animation.addByPrefix('hey', 'BF HEY', 24, false);
		bfDance.antialiasing = true;
        bfDance.flipX = true;

        add(gfDance);
        add(bfDance);
        add(logoBl);
        add(logoB2);

        titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = AtlasCache.getCachedTexture('titleEnter');//Paths.getSparrowAtlas('sprites/titleEnter','title');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		add(titleText);

        credGroup = new FlxGroup();
		add(credGroup);
        textGroup = new FlxGroup();
		add(textGroup);

        blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

        textAlpha = new Alphabet(0, 0, "DillyzThe1", true);
		textAlpha.screenCenter();

        textAlpha.visible = false;

        FlxTween.tween(textAlpha, {y: textAlpha.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

        init = true;

        if (doSkip) skipIntro();
    }

    var inTransition:Bool = false;

    override function update(elapsed:Float)
    {
        if (FlxG.sound.music != null)
			Conductor.songPos = FlxG.sound.music.time;

        

        FlxG.watch.addQuick('funni beat', curBeat);
        FlxG.watch.addQuick('funni step', curStep);

        var moveArray = [FlxG.keys.pressed.UP,FlxG.keys.pressed.DOWN,FlxG.keys.pressed.LEFT,FlxG.keys.pressed.RIGHT];

        /*if (moveArray.contains(true))
            for (i in 0...moveArray.length)
                if (moveArray[i] == true)
                {
                    switch (i)
                    {
                        case 0:
                            bfDance.y -= 10;
                        case 1:
                            bfDance.y += 10;
                        case 2:
                            bfDance.x -= 10;
                        case 3:
                            bfDance.x += 10;
                    }
                    trace("bf coords: " + bfDance.x + "," + bfDance.y);
                }*/ //FORGOT TO REMOVE THIS 

        if (FlxG.keys.justPressed.ENTER && !inTransition && skippedIntro)
        {
            titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu','title'), 0.7);

            inTransition = true;

            new FlxTimer().start(2, function(tmr:FlxTimer)
            {
                FlxG.switchState(new CharacterSelectionState());
            });
        }

        super.update(elapsed);
    }
    
    var transitioning:Bool = false;

    function createCoolText(textArray:Array<String>)
    {
        for (i in 0...textArray.length)
        {
            var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
            money.screenCenter(X);
            money.y += (i * 60) + 200;
            credGroup.add(money);
            textGroup.add(money);
        }
    }

    function addMoreText(text:String)
    {
        var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
        coolText.screenCenter(X);
        coolText.y += (textGroup.length * 60) + 200;
        credGroup.add(coolText);
        textGroup.add(coolText);
    }

    function deleteCoolText()
    {
        while (textGroup.members.length > 0)
        {
            credGroup.remove(textGroup.members[0], true);
            textGroup.remove(textGroup.members[0], true);
        }
    }

    override function beatHit()
    {
        super.beatHit();

        logoBl.animation.play('bump');
        if (curBeat % 1 == 0) logoB2.animation.play('bump');
        danceLeft = !danceLeft;
        
        if ([7,23,39,55,71,87,103,119,135,151,167,183].contains(curBeat)) 
        {
            bfDance.animation.play('hey');
            gfDance.animation.play('cheer');
        } // i would make a better method for this but not rn
        else 
        {
            bfDance.animation.play('idle');
            gfDance.animation.play('dance' + (danceLeft ? 'Left' : 'Right'));
        }

        switch (curBeat)
		{
			case 1:
				createCoolText(['DillyzThe1']);
			case 3:
				addMoreText('presents');
			case 4:
				deleteCoolText();
			case 5:
				createCoolText(['Made for the', 'rythm game']);
			case 7:
				addMoreText("Friday Night Funkin'");
			case 8:
				deleteCoolText();
			case 9:
				createCoolText(['this is not orignal']);
			case 11:
				addMoreText('so dont get mad');
			case 12:
				deleteCoolText();
			case 13:
				addMoreText('FNF');
			case 14:
				addMoreText('Offset');
			case 15:
				addMoreText('Test');
			case 16:
				skipIntro();
		}
    }

    var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
            remove(textGroup);
			skippedIntro = true;
		}
	}
}