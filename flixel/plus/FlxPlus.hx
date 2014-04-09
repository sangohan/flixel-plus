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
		timeScale:Float, duration:Float, ?callback:FlxTimer->Void):Void
	{
		FlxG.timeScale = timeScale;
		FlxTimer.start(duration * timeScale, function(timer:FlxTimer) {
			FlxG.timeScale = 1.0;
			if (callback != null)
				callback(timer);
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
		duration:Float, ?callback:FlxTimer->Void):Void
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
	 * Remap a value to another value from 2 arrays.
	 * 
	 * @param	value	The value you want to remap
	 * @param	from	The array of possible values that contains the input value
	 * @param	to		The array of possible output values that maps to [from]
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