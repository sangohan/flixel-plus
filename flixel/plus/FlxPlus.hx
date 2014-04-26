package flixel.plus;

import flash.Lib;
import flash.system.System;
import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;

/**
 * A static class that contains misc functions.
 * @author Malody Hoe
 */
class FlxPlus
{
	
	@:access(flixel.system.FlxSound._position)
	/**
	 * Gets the playback position of a FlxSound.
	 * 
	 * @param	music	The FlxSound you want to retrieve the position of.
	 * 					If null, uses FlxG.sound.music.
	 * @return	The playback position in seconds.
	 */
	public static inline function getMusicTime(music:FlxSound=null):Float
	{
		if (music == null)
			music = FlxG.sound.music;
		return music._position / 1000;
	}
	
	/**
	 * Plays a sound, and sets its survive to "true" so that it will play across states.
	 * 
	 * @param	embeddedSound	The sound you want to play.
	 * @param	volume			How loud to play it (0 to 1).
	 * @param	looped			Whether to loop this sound.
	 * @param	autoDestroy		Whether to destroy this on finish playing.
	 * 							Set this to "false" if you want to re-use.
	 * @param	?onComplete		The callback when the sound finishes playing.
	 * @return	The FlxSound object for chaining.
	 */
	public static inline function playPersistingSound(
		embeddedSound:String, volume:Float=1.0, looped:Bool=false,
		autoDestroy:Bool=false, ?onComplete:Void->Void):FlxSound
	{
		var sound:FlxSound = FlxG.sound.play(
			embeddedSound, volume, looped, autoDestroy, onComplete);
		sound.survive = true;
		return sound;
	}
	
	/**
	 * Modifies the game's timeScale for a period of time. Changes the timeScale back to 1.0 afterwards.
	 * If you do not want this to happen, set a callback.
	 * 
	 * @param	timeScale	The new FlxG.timeScale you want to set it to.
	 * 						WARNING: Don't set it to 0! Use FlxPlus.sleep instead.
	 * @param	duration	The duration to change the timeScale, in seconds.
	 * @param	?callback	Optional callback parameter.
	 */
	public static inline function tempChangeTimeScale(
		timeScale:Float, duration:Float, ?callback:Void->Void):Void
	{
		FlxG.timeScale = timeScale;
		FlxTimer.start(duration * timeScale, function(timer:FlxTimer) {
			FlxG.timeScale = 1.0;
			if (callback != null)
				callback();
		} );
	}
	
	/**
	 * Pseudo-sleeps the game for a period of time. Changes the timeScale back to 1.0 afterwards.
	 * If you do not want this to happen, set a callback.
	 * 
	 * @param	duration	The duration to sleep the game, in seconds.
	 * @param	?callback	Optional callback parameter.
	 */
	public static inline function sleep(
		duration:Float, ?callback:Void->Void):Void
	{
		tempChangeTimeScale(0.01, duration, callback);
	}
	
	/**
	 * Quits the game. Shorthand for System.exit(0). Force-closes for Android.
	 */
	public static inline function quit():Void
	{
		#if android
		Lib.forceClose();
		Lib.forceClose();
		#else
		System.exit(0);
		#end
	}
	
	/**
	 * Remap a value to another value from 2 arrays. If unable to map, returns null.
	 * Eg. ["A", "B", "C", "D"] -> [1, 2, 3, 4], "B" maps to 2.
	 * 
	 * @param	value	The value you want to remap
	 * @param	from	The array of possible values that contains the input value
	 * @param	to		The array of possible output values that maps to [from]
	 */
	@:generic public static inline function remapValue<T, U>(
		value:T, from:Array<T>, to:Array<U>):Null<U>
	{
		var toVal:Null<U> = null;
		for (i in 0...from.length)
		{
			if (from[i] == value)
			{
				toVal = to[i];
				break;
			}
		}
		return toVal;
	}
	
	/**
	 * Converts a float to string while being able to round it off decimal places.
	 * Eg. 9.4673 2dp => 9.47
	 * 
	 * @param	value	The float you want to convert.
	 * @param	dp		The decimal places to round off the float. Default 0 means no rounding.
	 * 					If default, you might as well just use Std.string!
	 * @return	The string.
	 */
	public static inline function floatToString(value:Float, dp:Int=0):String
	{
		if (dp == 0)
			return Std.string(value);
		else
		{
			var parts:Array<String> = Std.string(value).split(".");
			if (parts.length == 1)
				return parts[0];
			else
			{
				var decimal:Int = Math.round(
					Std.parseFloat(parts[1].substr(0, dp + 1)) / 10);
				var dstr:String = Std.string(decimal);
				while (dstr.length < dp)
					dstr += "0";
				return parts[0] + "." + dstr;
			}
		}
	}
	
}