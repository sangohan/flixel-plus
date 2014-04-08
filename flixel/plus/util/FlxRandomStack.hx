package flixel.plus.util;

import flixel.interfaces.IFlxDestroyable;
import flixel.util.FlxRandom;

/**
 * An object that simulates a random stack/bag of values.
 * You should call destroy() when you don't need this anymore.
 * @author Malody Hoe
 */
class FlxRandomStack<T> implements IFlxDestroyable
{

	/**
	 * The array of original values that will be used to fill up the stack.
	 */
	public var source:Array<T>;
	
	/**
	 * The array of values currently in the stack.
	 */
	private var current:Array<T>;
	
	/**
	 * Whether the current stack is empty.
	 */
	public var isEmpty(get, never):Bool;
	private function get_isEmpty():Bool
	{
		if (current == null)
			return true;
		else if (current.length == 0)
			return true;
		else
			return false;
	}
	
	/**
	 * An object that simulates a random stack/bag of values.
	 * 
	 * @param	source	The array of original values in the stack.
	 * @param	clone	Whether to copy the passed in array or not. Default false.
	 */
	public function new(source:Array<T>=null, clone:Bool=false)
	{
		setSource(source, clone);
		generate();
	}
	
	public function destroy():Void
	{
		source = null;
		current = null;
	}
	
	/**
	 * Retrieves a value from the stack.
	 * 
	 * @param	autoRefill Whether to auto generate the stack if it is empty. Default true.
	 * @return	The value retrieved.
	 */
	public function next(autoRefill:Bool=true):T
	{
		if (current.length == 0 || current == null)
		{
			if (autoRefill)
				generate();
			else
				return null;
		}
		return current.shift();
	}
	
	/**
	 * Sets the source; ie. the original values in the stack.
	 * 
	 * @param	source	The array of values.
	 * @param	clone	Whether to copy the passed in array or not. Default false.
	 * @return	This FlxRandomStack for chaining.
	 */
	public function setSource(
		source:Array<T>=null, clone:Bool=false):FlxRandomStack<T>
	{
		if(clone)
			this.source = source.copy();
		else
			this.source = source;
		return this;
	}
	
	/**
	 * Generates the stack (and shuffles it).
	 * @return This FlxRandomStack for chaining.
	 */
	public function generate():FlxRandomStack<T>
	{
		if (source == null)
		{
			current = new Array<T>();
			return this;
		}
		
		current = source.copy();
		return shuffle();
	}
	
	/**
	 * Shuffles the current stack.
	 * @return This FlxRandomStack for chaining.
	 */
	public function shuffle():FlxRandomStack<T>
	{
		FlxRandom.shuffleArray(current, current.length * 4);
		return this;
	}
	
	/**
	 * Inserts values into the current stack, and optionally the source as well.
	 * 
	 * @param	values		The values to add into the current stack.
	 * @param	addToSource	Whether to add the values into the source as well. Default false.
	 * @return	This FlxRandomStack for chaining.
	 */
	public function insert(
		values:Array<T>, addToSource:Bool=false):FlxRandomStack<T>
	{
		for (value in values)
		{
			current.insert(FlxRandom.intRanged(0, current.length - 1), value);
			if (addToSource)
				source.push(value);
		}
		return this;
	}
	
}