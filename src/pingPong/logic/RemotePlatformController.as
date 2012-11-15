package pingPong.logic 
{
	import core.Box2D.utils.Box2DWorldController;
	import core.game.GameProcessor;
	import core.services.ServicesLocator;
	import core.view.gameobject.GameObject;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class RemotePlatformController extends PlayerPlatformController 
	{
		private var gameProcessor:GameProcessor;
		
		public function RemotePlatformController(viewInstance:DisplayObjectContainer, worldController:Box2DWorldController, platform:GameObject) 
		{
			super(viewInstance, worldController, platform);
		}
		
		override protected function initilize():void 
		{
			viewInstance.addEventListener(Event.ENTER_FRAME, onFrameUpdate);

			setPlatformPosition(Starling.current.nativeStage.mouseY) //viewInstance.stage.mouseY);
			
			gameProcessor = ServicesLocator.instance.getService(GameProcessor) as GameProcessor;
			gameProcessor.setPlatformView(this);
		}
		
	
	}

}