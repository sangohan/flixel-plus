package flixel.plus.effects.particles;

import flixel.effects.particles.FlxEmitterExt;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;

/**
 * A FlxEmitterExt that fades out old particles. For now, only works on
 * particles that live forever.
 * @author Malody Hoe
 */
class FlxFadingEmitter extends FlxEmitterExt 
{

	/**
	 * If the number of dead particles is less than this threshold, it will
	 * try to fade out the old particles.
	 */
	public var threshold:Int;
	
	/**
	 * The duration of the fading out.
	 */
	public var fadeDuration:Float;
	
	/**
	 * The number of particles to fade out each time.
	 */
	public var fadeNumber:Int;
	
	/**
	 * @param	threshold If the number of dead particles is less than this threshold, it will
	 * try to fade out the old particles.
	 * @param	fadeDuration The duration of the fading out.
	 * @param	fadeNumber The number of particles to fade out each time.
	 */
	public function new(
		threshold:Int=100, fadeDuration:Float=1.0, fadeNumber:Int=10)
	{
		super();
		
		this.threshold = threshold;
		this.fadeDuration = fadeDuration;
		this.fadeNumber = fadeNumber;
	}
	
	override public function update():Void
	{
		if (_quantity > 0)
		{
			var notExistNum:Int = 0;
			for (particle in members)
			{
				if (!particle.exists)
					notExistNum++;
			}
			
			if (notExistNum < threshold)
			{
				tryFade();
			}
		}
		
		super.update();
	}
	
	private function tryFade():Void
	{
		var i:Int = 0;
		var count:Int = fadeNumber;
		var len:Int = members.length;
		
		while (fadeNumber > 0 || i < len)
		{
			var p:FlxSprite = members[i];
			if (p.exists)
			{
				members.splice(i, 1);
				members.push(p);
				i--;
				fadeNumber--;
				len--;
				
				FlxTween.singleVar(p, "alpha", 0, fadeDuration,
					{ type: FlxTween.ONESHOT,
						complete: function(tween:FlxTween):Void {
							tween.userData.particle.kill();
						} } ).userData = { particle: p };
			}
			
			i++;
		}
	}
	
}