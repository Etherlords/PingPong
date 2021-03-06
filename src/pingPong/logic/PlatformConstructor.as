package pingPong.logic 
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2Fixture;
	import core.Box2D.utils.Box2DWorldController;
	import core.view.gameobject.config.GameobjectConfig;
	import core.view.gameobject.physicalpropeties.PhysicModel;
	import core.view.gameobject.physicalpropeties.SimplePhysicalProperties;
	import pingPong.view.gameObjectsSkins.PlatformSkin;
	import starling.display.DisplayObjectContainer;
	import core.view.gameobject.GameObject;
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class PlatformConstructor 
	{
		
		public function PlatformConstructor() 
		{
			
		}
		
		public function make(stage:DisplayObjectContainer, worldController:Box2DWorldController, skin:Class = null):GameObject 
		{
			var config:GameobjectConfig = new GameobjectConfig(true);
			//rabbitConfig.physicConfiguration.friction = 1;
			config.type = 0; //todo replace
			 //todo replace
			if (!skin)
			{
				config.shapeType = 2;
				skin = PlatformSkin;
			}
			config.skinClass = skin;
			
			var gameObject:GameObject = worldController.constructGameObject(GameObject, config, new PhysicModel(40, 1, 0.1),  stage);
			gameObject.physicalProperties.physicModel.fixedRotation = true;
			
			var body:b2Body = (gameObject.physicalProperties as SimplePhysicalProperties).physicBodyKey
			
			var fix:b2Fixture = body.GetFixtureList();
			fix.SetRestitution(0.5);
			fix.SetFriction(0);
			
			body.SetSleepingAllowed(false);
			
			return gameObject;
		}
		
	}

}