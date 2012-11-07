package pingPong.view.gameObjectsSkins 
{
	import com.greensock.TweenMax;
	import core.view.skin.Skin;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class PlatformSkin extends Skin 
	{
		
		public function PlatformSkin() 
		{
			super();
			
			graphics.lineStyle(2, 0xAAAAAA);
			graphics.beginFill(0xDDDDDD);
			graphics.drawRect(0, 0, 25, 100);
			
			
		}
		
		private var startx:Number = 0;
		private var lock:Boolean = false;
		private var lock2:Boolean = false;
		
		override public function doAction(actionKey:uint, horSpeed:Number = 0):void 
		{
			if (actionKey == 5)
			{
				lock = false;
				lock2 = false;
				this.x = horSpeed;
				return;
			}
			
			if (actionKey == 4 && !lock2)
			{
				TweenMax.killTweensOf(this);
				lock = false
				lock2 = true;
				return;
			}
				
			//if (lock || lock2)
			//	return;
			
			var dir:int = 1;
			if (actionKey == 1)
				dir = -1;
				
			horSpeed = Math.abs(horSpeed) / 2;
			
			if (horSpeed > 20)
				horSpeed = 20;
				
			startx = this.x;
			lock = true;
			
			//trace(image.color.toString(16));
			//TweenMax.to(image, 2, { colorTransform:{ tint:0xFFFFFF, tintAmount:10 } } );
			//TweenMax.to(this, 0.1, { superx:(dir * horSpeed) + this.x});
			
			//TweenMax.to(image, 0.5, { color:0xFFFFFF, onComplete:titntBack } );
			
		}
		
		
		public function get superx():Number 
		{
			return super.x;
		}
		
		public function set superx(value:Number):void 
		{
			
				
			super.x = value;
		}
		
		override public function get x():Number 
		{
			return super.x;
		}
		
		override public function set x(value:Number):void 
		{
			if (lock)
				return;
				
			super.x = value;
		}
		
		private function titntBack():void 
		{
			
			TweenMax.to(image, 0.5, {color:0});
		}
		
		private function unlock():void 
		{
			lock = false;
		}
		
	}

}