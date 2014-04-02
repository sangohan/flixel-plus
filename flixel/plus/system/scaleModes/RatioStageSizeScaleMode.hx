package flixel.plus.system.scaleModes;

import flixel.FlxG;
import flixel.system.scaleModes.StageSizeScaleMode;

/**
 * A ScaleMode that resizes the stage to the window's size,
 * but keeps aspect ratio.
 * Essentially a combination of RatioScaleMode and StageSizeScaleMode.
 * @author Malody Hoe
 */
class RatioStageSizeScaleMode extends StageSizeScaleMode
{

	override public function onMeasure(Width:Int, Height:Int):Void 
	{
		var ratio:Float = FlxG.width / FlxG.height;
		var realRatio:Float = Width / Height;
		
		var newWidth:Int;
		var newHeight:Int;
		
		if (realRatio < ratio)
		{
			newWidth = Width;
			newHeight = Math.floor(newWidth / ratio);
		}
		else
		{
			newHeight = Height;
			newWidth = Math.floor(newHeight * ratio);
		}
		
		super.onMeasure(newWidth, newHeight);
		
		FlxG.game.x = cast (Width - newWidth) / 2;
		FlxG.game.y = cast (Height - newHeight) / 2;
	}
	
}