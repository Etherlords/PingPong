package pingPong.view.gameObjectsSkins 
{
	import com.greensock.TweenMax;
	import core.view.skin.Skin;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class CenterPlatformSkin extends Skin 
	{
		
		public function CenterPlatformSkin() 
		{
			super();
			
			graphics.lineStyle(2, 0xAAAAAA);
			graphics.beginFill(0xDDDDDD);
			graphics.drawRect(0, 0, 35, 35);
			
			
		}
		
		private var startx:Number = 0;
		private var lock:Boolean = false;
		private var lock2:Boolean = false;
		
		override public function doAction(actionKey:uint, horSpeed:Number = 0):void 
		{
			
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