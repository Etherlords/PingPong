package pingPong.logic
{

	import core.Box2D.scene.BaseBox2DScene;
	import core.events.GameObjectPhysicEvent;
	import core.game.GameProcessor;
	import core.GlobalConstants;
	import core.services.ServicesLocator;
	import core.ui.KeyBoardController;
	import core.view.gameobject.GameObject;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import pingPong.BollCamera;
	import pingPong.logic.BollConstructor;
	import pingPong.logic.IIPlatformController;
	import pingPong.logic.PlatformConstructor;
	import pingPong.logic.PlayerPlatformController;
	import pingPong.model.GameStatModel;
	import pingPong.net.ConnectionController;
	import pingPong.settings.PingPongSettingsModel;
	import pingPong.SharedObjectService;
	import pingPong.view.gameObjectsSkins.CenterPlatformSkin;
	import pingPong.view.PingPongSceneView;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;
	import ui.services.CameraService;
	import utils.BoundariesConstructor;
	import utils.GlobalUIContext;
	
	public class PingPong extends BaseBox2DScene
	{
		
		private var maxBollSpeed:Number = 0;
		
		static private const GAMEFIELD_WIDTH:Number = 760;
		static private const GAMEFIELD_HEIGH:Number = 500;
		
		private var sceneView:PingPongSceneView;
		
		private var _boundaries:BoundariesConstructor;
		
		private var camera:BollCamera;
		private var boll:GameObject;
		
		private var intensity:Number = 1.05;
		private var speedUpt:Number = 1.07;
		
		private var platform:GameObject;
		private var platform2:GameObject;
		
		private var scoreService:SharedObjectService;
		private var mouseDown:Boolean = false;
		
		private var playerPlatformer:PlayerPlatformController;
		private var iiController:PlayerPlatformController;
		
		private var settings:PingPongSettingsModel;
		private var gameStatModel:GameStatModel;
		private var energyFlow:EnergyFlow;
		private var winner:String;
		private var connectionManager:ConnectionController;
		
		public function PingPong()
		{
			super();
		}
		
		override protected function initilize():void
		{
			//create using services
			
			connectionManager = new ConnectionController
			var gameProcessor:GameProcessor = new GameProcessor();
			gameProcessor.pingPongController = this;
			
			gameStatModel = new GameStatModel();
			scoreService = ServicesLocator.instance.getService(SharedObjectService) as SharedObjectService;
			settings = scoreService.settings;
			scoreService.controllScore(gameStatModel);
			
			
			
			super.initilize();
		}
		
		public function startRaund(needSend:Boolean = true):void 
		{
			boll.applyActionView(1);
			
			prepareGameStart();
			
			var side:Number = 1;
			
			if (Math.random() > 1.5)
				side = -1;
				
			Mouse.cursor = 'noCursor';
			
			speedUpt = 1.09;
			boll.physicalProperties.applyForce(settings.startBollPower * side, 0)
			
			//if (Starling.current.nativeStage.contains(gameStartDialog))
			//	Starling.current.nativeStage.removeChild(gameStartDialog);
			
			gameStatModel.ricoshet = 0;
			gameStatModel.bollSpeed = 0;
				
			isGameInProgress = true;
			
			sceneView.hideDialog();
			
			if(needSend)
				connectionManager.startRaund();
		}
		
		private function prepareGameStart():void 
		{
			
			platform2.body.x = GAMEFIELD_WIDTH - platform2.body.width * 2
			//platform2.body.y = platform.body.y;
			platform.body.x = 0;
			
			boll.physicalProperties.stopXVelocity();
			boll.physicalProperties.stopYVelocity();
			
			boll.body.x = (GAMEFIELD_WIDTH + boll.body.width / 2) / 2;
			boll.body.y = (GAMEFIELD_HEIGH - boll.body.width / 2) / 2;
			
			sceneView.showDialog();
		}
		
		private function postInitilize():void
		{
			
			isGameInProgress = true;
			
			createWorld();
			createViewComponents();
			
			
			camera = new BollCamera(boll, new Point(GAMEFIELD_WIDTH/2, GAMEFIELD_HEIGH/2));
			
			ServicesLocator.instance.addService(new CameraService(camera));
			
			camera.tracingTarget = boll;
			
			
			
			//view.x = (view.stage.stageWidth - view.width) / 2;
			
			gameStep(1)
			
			isGameInProgress = false
		}
		
		override public function gameStep(e:Number):void
		{
			if (!sceneView)
				return;
				
			super.gameStep(e);
			
			
			
			sceneView.renderScene();
			
			if(isGameInProgress)
				gameStatModel.bollSpeed = int((Math.abs(boll.physicalProperties.physicModel.linearVelocity.x) + Math.abs(boll.physicalProperties.physicModel.linearVelocity.y)));
				
			if (gameStatModel.bollSpeed > maxBollSpeed)
				maxBollSpeed = gameStatModel.bollSpeed 
			
			GlobalUIContext.debugContainer.x = view.x;
			GlobalUIContext.debugContainer.y = sceneView.gameObjectsInstance.y;
			
			if (settings.isUseBollParticles)
			{
				energyFlow.emitterX = boll.skin.x;
				energyFlow.emitterY = boll.skin.y;
			}
		}
		
		private function createViewComponents():void
		{
			_boundaries = new BoundariesConstructor();
			_boundaries.createBoundaries(sceneView.gameObjectsInstance, worldController);
			
			
			platform = new PlatformConstructor().make(sceneView.gameObjectsInstance, worldController);
			platform2 = new PlatformConstructor().make(sceneView.gameObjectsInstance, worldController);
				
			if (settings.isCenterPlatformOn)
			{
				
				var centerPlatform2:GameObject = new PlatformConstructor().make(sceneView.gameObjectsInstance, worldController, CenterPlatformSkin);
				centerPlatform2.body.y = (GAMEFIELD_HEIGH - centerPlatform2.body.height) / 2 - 55;
				centerPlatform2.body.x = (GAMEFIELD_WIDTH - centerPlatform2.body.width) / 2 + 5;
				
				var centerPlatform:GameObject = new PlatformConstructor().make(sceneView.gameObjectsInstance, worldController, CenterPlatformSkin);
				centerPlatform.body.y = (GAMEFIELD_HEIGH - centerPlatform.body.height) / 2 + 50;
				centerPlatform.body.x = (GAMEFIELD_WIDTH - centerPlatform.body.width) / 2 + 5;
			}
			
			boll = new BollConstructor().make(sceneView.gameObjectsInstance, worldController);
			
			prepareGameStart();
			
			playerPlatformer = new NetPlatformController(sceneView.gameObjectsInstance, worldController, platform2);
			//playerPlatformer = new IIPlatformController(sceneView.gameObjectsInstance, worldController, platform, boll);
			//iiController = new IIPlatformController(sceneView.gameObjectsInstance, worldController, platform2, boll);
			iiController = new RemotePlatformController(sceneView.gameObjectsInstance, worldController, platform);
			
			var keyController:KeyBoardController = new KeyBoardController(Starling.current.nativeStage);
			keyController.registerKeyDownReaction(Keyboard.SPACE, startRaund);
		
			_boundaries.left.addEventListener(GameObjectPhysicEvent.COLLIDE, playerLose);
			_boundaries.right.addEventListener(GameObjectPhysicEvent.COLLIDE, iiLose);
			
			boll.addEventListener(GameObjectPhysicEvent.COLLIDE, onBollCollide);
			GlobalUIContext.vectorStage.addEventListener(MouseEvent.MOUSE_DOWN, click);
			view.stage.addEventListener(MouseEvent.MOUSE_UP, unClick);
			
			if (settings.isUseBollParticles)
			{
				energyFlow = new EnergyFlow();
				sceneView.gameObjectsInstance.addChild(energyFlow);
			}
		}
		
		private function iiLose(e:GameObjectPhysicEvent):void 
		{
			winner = 'R2D2';
			scoreService.updateScore(scoreService.localScore - 1);
			gameOver();
		}
		
		private function playerLose(e:GameObjectPhysicEvent):void 
		{
			winner = settings.playerName
			scoreService.updateScore(scoreService.localScore + 1);
			gameOver();
		}
		
		private function gameOver():void 
		{
			Mouse.cursor = MouseCursor.AUTO;
			
			isGameInProgress = false;
			
			if (settings.isUseBollParticles)
			{
				var bigBlow:BigBlowEffect = createBigBlow();
				
				bigBlow.x = boll.body.x 
				bigBlow.y = boll.body.y + 40
			}
			
			
			
			boll.applyActionView(0);
			
			
			prepareGameStart();
			//{"gamesStatistic":[{"reportId":"3b0b1c47-0e2c-4f57-9924-dcff01129b7b","statistic":{"winner":"LESHINA","maxBallSpeed":25,"ricoshets":1}}],"reportId":"LESHINA"}
			var request:URLRequest = new URLRequest('http://st.depositphotos.net:8080/ametisten-stat/game/end');
			
			var variables:URLVariables = new URLVariables();
			variables.accountName = settings.playerName;
			variables.ricoshetsCount = gameStatModel.ricoshet;
			variables.maxBallSpeed = maxBollSpeed;
			variables.winnerName = winner;
			request.data = variables
			
			request.method = URLRequestMethod.POST;
			
			var urlLoader:URLLoader = new URLLoader(request);
			
		}
		
		private function unClick(e:MouseEvent):void 
		{
			mouseDown = false
		}
		
		private function click(e:MouseEvent):void 
		{
			return;
			mouseDown = true;
			
			if(isActivated)
				deactivate();
			else
				activate(currentViewContainer);
				
			playerPlatformer.impulse();
		}
		
		private function createBigBlow():BigBlowEffect
		{
			var blow:BigBlowEffect = new BigBlowEffect();
			
			//boll.skin.visible = false;
			boll.applyActionView(0);
			sceneView.gameObjectsInstance.addChild(blow);
			
			return blow;
		}
		
		private function onBollCollide(e:GameObjectPhysicEvent):void 
		{

			var y_delta:Number;
			var ang:Number = 0;
			var currVel:Point = boll.physicalProperties.physicModel.linearVelocity;
			
			if(e.interactionWith == platform)
				e.interactionWith.applyActionView(1, currVel.x);
			else
				e.interactionWith.applyActionView(0, currVel.x);
				
			var dir:Point = new Point();
			
			speedUpt -= 0.00175
			
			if (speedUpt < 1.00950)
				speedUpt = 1.00950;
				
			var localSpeedUp:Number = speedUpt;
		
			dir.x = currVel.x
			dir.y = currVel.y
			
			if (e.interactionWith == platform2 && false)
			{
				y_delta = (boll.body.y - e.interactionWith.body.y + e.interactionWith.body.height )
				
				ang = (180 / 100 * y_delta) - 90;
				
				ang /= 3;
				ang *= GlobalConstants.DEGREE_TO_RAD;
				
				intensity = 5;
				
				var yPolar:int = 1;
				var xPolar:Number = 1;
				
				if (dir.x < 0)
					xPolar = -1;
				
				if (dir.y < 0)
					yPolar = -1;
				
				//dir.x += xPolar * intensity * Math.cos(ang);
				dir.y += yPolar * intensity * Math.sin(ang);
				
				//gameStatModel.ricoshet++;
				
				
				/*y_delta = Math.abs(y_delta - 50);
				trace("bonus", y_delta);
				y_delta /= 3000;
				y_delta = 0.01 - y_delta;
				localSpeedUp -= y_delta;*/
				
			}
			
			if (e.interactionWith == platform || e.interactionWith == platform2)
			{
				dir.x *= localSpeedUp;
				dir.y *= (localSpeedUp - 0.01) < 1.005? 1.005:(localSpeedUp - 0.01);
				gameStatModel.ricoshet++;
			}
			
			if (e.interactionWith == platform)
			{
				var contact:Point = new Point(boll.body.x, boll.body.y - e.interactionWith.body.y);
				
				//if(boll.body.x > e.interactionWith.body.x + e.interactionWith.body.width)
					//contact.x = e.interactionWith.body.x + e.interactionWith.body.width;
				
				var convas:BitmapData = new BitmapData(5, 5, false, 0xFFFFFF);
				var contactEffect:Texture = Texture.fromBitmapData(convas);
				var image:Image = new Image(contactEffect);
				
				image.x = contact.x - image.width/ 2 - e.interactionWith.body.width / 2;
				image.y = contact.y;
				
				
				
				platform.skin.addChild(image);
				
				var tw:Tween = new Tween(image, 0.6);
				tw.animate('alpha', 0);
				tw.onComplete = Delegate.create(function(image:Image):void
				{
					platform.skin.removeChild(image);
				}, image)
				Starling.juggler.add(tw);
			}
			
			
			
			boll.physicalProperties.physicModel.linearVelocity = dir;
			
		}
		
		override public function deactivate():void 
		{
			
			if (!isActivated)
				return;
			
			stopGameCycles();
			sceneView.deactivate();
			
			super.deactivate();
			
			
		}
		
		public override function activate(instance:DisplayObjectContainer):void
		{
			if (isActivated)
				return;
				
			var initilize:Boolean = !sceneView
				
			if (initilize)
			{
				sceneView = new PingPongSceneView(gameStatModel);
				gameObjectsInstance = sceneView.gameObjectsInstance;
			}
			
			sceneView.activate();
			
			setViewComponent(sceneView);
			
			super.activate(instance);
			
			if (initilize)
				postInitilize();
			
			initGameCycles();
		
		}
	
	}

}