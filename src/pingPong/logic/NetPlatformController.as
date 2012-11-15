package pingPong.logic 
{
	import core.Box2D.utils.Box2DWorldController;
	import core.game.GameProcessor;
	import core.pingPong.PlatformRemoteController;
	import core.services.ServicesLocator;
	import core.view.gameobject.GameObject;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class NetPlatformController extends PlayerPlatformController 
	{
		private var _gameProcessor:GameProcessor;
		private var _remote:PlatformRemoteController;
		
		public function NetPlatformController(viewInstance:DisplayObjectContainer, worldController:Box2DWorldController, platform:GameObject) 
		{
			super(viewInstance, worldController, platform);
		}
		
		override protected function initilize():void 
		{
			super.initilize();
		}
		
		override public function setPlatformPosition(position:Number):void 
		{
			super.setPlatformPosition(position);
			remote.onMouseMove(position);
		}
		
		override public function turnToNormal():void 
		{
			super.turnToNormal();
			remote.turnToNormal();
		}
		
		override public function turnPlatformRight():void 
		{
			super.turnPlatformRight();
			remote.turnToRight();
		}
		
		override public function turnPlatformLeft():void 
		{
			super.turnPlatformLeft();
			remote.turnToLeft()
		}
		
		public function get gameProcessor():GameProcessor 
		{
			
			if (!_gameProcessor)
				_gameProcessor = ServicesLocator.instance.getService(GameProcessor) as GameProcessor;
			
			return _gameProcessor;
		}
		
		public function get remote():PlatformRemoteController 
		{
			if (!_remote)
				_remote = gameProcessor.platformController;
			
			return _remote;
		}
		
	
	}

}