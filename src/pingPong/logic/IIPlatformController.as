package pingPong.logic 
{
	import com.greensock.TweenLite;
	import core.Box2D.utils.Box2DWorldController;
	import core.view.gameobject.GameObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class IIPlatformController extends PlayerPlatformController 
	{
		private var boll:GameObject;
		private var startDelta:Number;
		
		public function IIPlatformController(viewInstance:DisplayObjectContainer, worldController:Box2DWorldController, platform:GameObject, boll:GameObject) 
		{
			super(viewInstance, worldController, platform);
			this.boll = boll;
			changeDelta();
		}
		
		
		override protected function initilize():void 
		{
			var deltatTimer:Timer = new Timer(2000, 0);
			deltatTimer.addEventListener(TimerEvent.TIMER, changeDelta);
			var t:Timer = new Timer(25, 0);
			t.addEventListener(TimerEvent.TIMER, onTimerEvent);
			t.start();
			deltatTimer.start();
		}
		
		private function changeDelta(e:* = null):void 
		{
			startDelta = -20 + Math.random() * 40;
		}
		
		private function onTimerEvent(e:TimerEvent):void 
		{
			onFrameUpdate();
		}
		
		override public function get basex():Number 
		{
			return super.basex;
		}
		
		override public function set basex(value:Number):void 
		{
			super.basex = value// -platform.body.width/2;
		}
		
		override protected function onFrameUpdate(e:Event = null):void 
		{
			super.onFrameUpdate(e);
			
			var __y:Number = boll.body.y + (platform.body.height / 2 - boll.body.height) / 2
			
			
			/*
			if (Math.random() > 0.5)
			{
				if (Math.random() > 0.5)
					__y += boll.body.width *2;
				else
					__y -= boll.body.width *2;
			}*/
			
			__y = __y + startDelta;
			
			if (__y < 0 + platform.skin.phsyHeight)
				__y = 0 + platform.skin.phsyHeight;
			
			if (__y > 400 + platform.skin.phsyHeight)
				__y = 400 + platform.skin.phsyHeight;
			
			platform.body.x = basex;
			TweenLite.to(platform.body, 0.03, { y:__y } );
			
			//setPlatformPosition();
			
		}
	
	}

}