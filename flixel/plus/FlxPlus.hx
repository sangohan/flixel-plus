package flixel.plus;

import flixel.system.FlxSound;

/**
 * A static class that contains misc functions
 * @author Malody Hoe
 */
class FlxPlus
{
	
	@:access(flixel.system.FlxSound._position)
	/**
	 * Gets the playback position of a FlxSound.
	 * @param	music The FlxSound you want to retrieve the position of.
	 * If null, uses FlxG.sound.music.
	 * @return The playback position in seconds.
	 */
	public static inline function getMusicTime(music:FlxSound):Float
	{
		if (music == null)
			music = FlxG.sound.music;
		return music._position / 1000;
	}
	
	/**
	 * Remap a value to another value from 2 arrays
	 * @param	value The value you want to remap
	 * @param	from The array of possible values that contains the input value
	 * @param	to The array of possible output values that maps to [from]
	 */
	static public function remapValue(
		value:Dynamic, from:Array<Dynamic>, to:Array<Dynamic>):Dynamic
	{
		for (i in 0...from.length)
		{
			if (from[i] == value)
				return to[i];
		}
		return value;
	}
	
}