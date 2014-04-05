package flixel.plus.fixes;

import flixel.FlxG;
import flixel.input.touch.FlxTouch;
import flixel.plugin.FlxPlugin;

/**
 * A plugin class to fix the one-touch-behind bug caused by lime/openfl update.
 * @author Malody Hoe
 */
class FlxTouchFix extends FlxPlugin
{
	
	private var oldList:Array<FlxTouch>;
	private var list:Array<FlxTouch>;

	public function new() 
	{
		super();
		
		oldList = new Array<FlxTouch>();
		list = FlxG.touches.list;
	}
	
	@:access(flixel.input.touch.FlxTouch._current)
	override public function update():Void 
	{
		super.update();
		
		for (n in list)
		{
			var justPressed:Bool = true;
			
			for (o in oldList)
			{
				if (n == o)
				{
					justPressed = false;
					break;
				}
			}
			
			if (justPressed)
				n._current = 2;
			else
				n._current = 1;
			
		}
		
		for (o in oldList)
		{
			var released:Bool = true;
			
			for (n in list)
			{
				if (o == n)
				{
					released = false;
					break;
				}
			}
			
			if (released)
				o._current = -1;
			else
				o._current = 1;
		}
		
		oldList = list.copy();
	}
	
}