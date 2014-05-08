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
	
	/**
	 * Plays a sound, and sets its persist to "true" so that it will play across states.
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
		sound.persist = true;
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
		delay(duration * timeScale, function(_):Void {
			if (callback != null)
				callback();
			else				
				FlxG.timeScale = 1.0;
		} );
	}
	
	/**
	 * Sleeps the current state (sets active to "false") for a period of time.
	 * 
	 * @param	duration	The duration to sleep the game, in seconds.
	 * @param	?callback	Optional callback parameter.
	 */
	public static inline function sleep(
		duration:Float, ?callback:Void->Void):Void
	{
		FlxG.state.active = false;
		delay(duration, function(_):Void {
			FlxG.state.active = true;
			if(callback != null)
				callback();
		} );
	}
	
	/**
	 * Sets up a timer using FlxTimer. Basically the same as creating a FlxTimer object, but makes more sense as a function!
	 * 
	 * @param	duration	How many seconds it takes for the timer to go off.
	 * @param	callback	The function to call each time the timer ends.
	 * @param	loops   	How many times the timer should go off. 0 means "looping forever".
	 * @return	Returns the FlxTimer just in case you need it.
	 */
	public static inline function delay(
		duration:Float, callback:FlxTimer->Void, loops:Int=1):FlxTimer
	{
		return new FlxTimer(duration, callback, loops);
	}
	
	/**
	 * Quits the game. Shorthand for System.exit(0). Force-closes for Android.
	 */
	public static inline function quit():Void
	{
		// Have no idea why but I need to call Lib.forceClose() twice!
		#if android
		Lib.forceClose();
		Lib.forceClose();
		#else
		System.exit(0);
		#end
	}
	
	/*
	 * UTILITIES
	 * ========================================================================
	 */
	
	/**
	 * Remap a value to another value from 2 arrays. If unable to map, returns null.
	 * Eg. ["A", "B", "C", "D"] -> [1, 2, 3, 4], "B" maps to 2.
	 * 
	 * @param	value	The value you want to remap
	 * @param	from	The array of possible values that contains the input value
	 * @param	to		The array of possible output values that maps to [from]
	 */
	@:generic
	public static inline function remapValue<T, U>(
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