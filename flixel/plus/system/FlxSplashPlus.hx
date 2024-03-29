package flixel.plus.system;

import flixel.FlxG;
import flixel.FlxState;
import flixel.system.FlxSplash;

/**
 * A FlxSplash that fixes centering of logo on mobile, and also includes a handy initDefaults.
 * If you're not overriding this:
 * - You should set the static var nextState to the next state's class you want to load.
 * Otherwise, if you're overriding this:
 * - You can just pass in the class in the super constructor. ie. ... new() { super(nextState); }
 * - Overriding initDefaults() should be all you ever need to do.
 * NOTE: the subclass MUST NOT have any non-optional parameters in the constructor.
 * @author Malody Hoe
 */
class FlxSplashPlus extends FlxSplash
{

	public function new(nextState:Class<FlxState>=null)
	{
		super();
		if(nextState != null)
			FlxSplash.nextState = nextState;
	}
	
	override public function create():Void 
	{
		initDefaults();
		
		#if debug
		FlxG.switchState(Type.createInstance(FlxSplash.nextState, []));
		#else
		super.create();
		#end
		
		#if mobile
		onResize(Std.int(FlxG.stage.width), Std.int(FlxG.stage.height));
		#end
	}
	
	/**
	 * Add any initialization code you might have here!
	 * Such as default save values, plugins, etc.
	 */
	public function initDefaults():Void
	{
	}
	
}