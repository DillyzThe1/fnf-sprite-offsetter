package;

import flixel.FlxG;
import openfl.Lib;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	static function main() 
	{
		trace("'do stuff' -Dillyz");
		
		AtlasCache.setAssetPaths();
		Lib.current.addChild(new FlxGame(0,0,TitleState));
		FlxG.save.bind('fnfoffsetter', 'dillyzthe1');
	}

	public function new()
	{
		super();
	} // FlxG.switchState(new TitleState());
}
