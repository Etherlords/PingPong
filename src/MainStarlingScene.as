package  
{
	import core.services.ServicesLocator;
	import core.states.config.StateConfig;
	import core.states.State;
	import core.states.StatesManager;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Rectangle;
	import pingPong.logic.PingPong;
	import pingPong.settings.PingPongSettingsController;
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.ConcreteTexture;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class MainStarlingScene extends DisplayObjectContainer 
	{
		
		public function MainStarlingScene() 
		{
			super();
			
				
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			
			var stateManager:StatesManager = new StatesManager(this as DisplayObjectContainer);
			
			var gameStateConfig:StateConfig = new StateConfig('Game', PingPong);
			var gameState:State = new State(gameStateConfig);
			
			var settinsStateConfig:StateConfig = new StateConfig('Settings', PingPongSettingsController);
			var settingsState:State = new State(settinsStateConfig);
			
			if(StarlingInit.settings.isShowSettingsOnStart)
				stateManager.nextState(settingsState);
			
			stateManager.nextState(gameState);
			
			stateManager.start();
			
			Starling.current.root.x = (Starling.current.nativeStage.stageWidth - 800) / 2;
			Starling.current.root.y = (Starling.current.nativeStage.stageHeight - 600) / 2;
			Starling.current.viewPort = new Rectangle(Starling.current.root.x, Starling.current.root.y, 800, 600);
			Starling.current.root.x = 10
			Starling.current.root.y = 0
		}
		
		
		
	}

}