package flixel.plus.util;

import flixel.interfaces.IFlxDestroyable;
import flixel.util.FlxColorUtil;
import flixel.util.FlxColorUtil.HSBA;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import haxe.ds.StringMap;

/**
 * An object to manage a color scheme. Not very intuitive.
 * Remember to call destroy().
 * @author Malody Hoe
 */
class FlxColorScheme implements IFlxDestroyable
{

	private var colorData:Array<ColorData>;
	public var colorOutput:StringMap<HSBA>;
		
	/**
	 * A class to manage a color scheme.
	 */
	public function new()
	{
		colorData = new Array<ColorData>();
		colorOutput = new StringMap<HSBA>();
	}
	
	public function destroy():Void 
	{
		colorData = null;
		colorOutput = null;
	}
	
	/**
	 * Adds a color to generate.
	 * See ColorVariable for info on setting the parameters.
	 * 
	 * @param	name		Name of the color.
	 * @param	hVariable	Parameters to vary the hue.
	 * @param	sVariable	Parameters to vary the saturation.
	 * @param	bVariable	Parameters to vary the brightness.
	 * @param	aVariable	Parameters to vary the alpha.
	 */
	public function addColor(name:String,
		hVariable:ColorVariable, sVariable:ColorVariable,
		bVariable:ColorVariable, aVariable:ColorVariable):Void
	{
		colorData.push( { name: name,
			hVariable: hVariable, sVariable: sVariable,
			bVariable: bVariable, aVariable: aVariable } );
	}
	
	public function getColor(name:String):Int
	{
		var components:HSBA = colorOutput.get(name);
		return FlxColorUtil.makeFromHSBA(
			components.hue, components.saturation,
			components.brightness, components.alpha);
	}
	
	/**
	 * Generates the color scheme's colors.
	 */
	public function generate():Void
	{
		for (data in colorData)
			generateColor(data);
	}
	
	private function generateColor(data:ColorData):Void
	{
		var color:HSBA = {
			hue: Std.int(generateVariable(data.hVariable, "h")),
			saturation: generateVariable(data.sVariable, "s"),
			brightness: generateVariable(data.bVariable, "b"),
			alpha: generateVariable(data.aVariable, "a")
		};
		color.hue = (color.hue + 360) % 360;
		color.saturation = FlxMath.bound(color.saturation, 0, 1.0);
		color.brightness = FlxMath.bound(color.brightness, 0, 1.0);
		color.alpha = FlxMath.bound(color.alpha, 0, 1.0);
		
		colorOutput.set(data.name, color);
	}
	
	private function generateVariable(data:ColorVariable, comp:String):Float
	{
		var rangeValue:Float = FlxRandom.floatRanged(data.min, data.max);
		
		if (data.base == null)
			return rangeValue;
		
		var baseColor:HSBA = colorOutput.get(data.base);
		var baseValue:Float = 0;
		
		switch(comp)
		{
			case "h":
				baseValue = baseColor.hue;
			case "s":
				baseValue = baseColor.saturation;
			case "b":
				baseValue = baseColor.brightness;
			case "a":
				baseValue = baseColor.alpha;
		}
		
		var sign:Int = data.positive == true ? 1 : FlxRandom.sign();
		return baseValue + sign * rangeValue;
	}
	
}

typedef ColorData = {
	name:String,
	hVariable:ColorVariable,
	sVariable:ColorVariable,
	bVariable:ColorVariable,
	aVariable:ColorVariable
}

/**
 * { min, max, base, positive }
 * [min] and [max] are the inclusive min and max of the lower and upper bound of the range.
 * How the [min] and [max] parameters work depends on whether [base] and [positive] is set.
 * 
 * If base == null && positive == false/true
 * - [min] and [max] is the range of the possible values, and [positive] is not taken into acount.
 * - eg. hue min = 10, max = 90: hue can be a value from 10 - 90 inclusive.
 * 
 * If base == "color" && positive == false
 * - [min] and [max] is the range of the -/+ differences of the corresponding value of "color".
 * - eg. hue min = 10, max = 90, and hue of "color" = 180: hue can be from 90 - 170 and 190 to 270 inclusive.
 * 
 * If base == "color" && positive == true
 * - [min] and [max] is the range of the positive difference of the corresponding value of "color".
 * - eg. hue min = 10, max = 90, and hue of "color" = 180: hue can be from 190 to 270 inclusive.
 */
typedef ColorVariable = {
	min:Float,
	max:Float,
	?positive:Bool,
	?base:String
}