package pingPong.settings 
{
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Timer;
	import pingPong.settings.model.UILables;
	import ui.components.Switch;
	import utils.GlobalUIContext;
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class SettingsView extends Sprite 
	{
		private var settingsModel:PingPongSettingsModel;
		private var format:TextFormat;
		private var componentCreationStrategy:Object;
		
		private var componentPlacement:Point = new Point(50, 100);
		private var header:TextField;
		private var nameInput:TextField;
		
		private var isTypingName:Boolean = false;
		private var typingTimer:Timer = new Timer(3000, 0);
		private var statisticField:TextField;
		
		public function SettingsView(settingsModel:PingPongSettingsModel) 
		{
			super();
			
			this.settingsModel = settingsModel
			
			initilzie();
		}
		
		private function initilzie():void 
		{
			
			componentCreationStrategy = { 'Boolean':createSwitchComponent };
			
			format = new TextFormat('Verdana', 15, 0xCCCCCC, true);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			typingTimer.addEventListener(TimerEvent.TIMER, endTyping);
			
		}
		
		public function set freezeInput(value:Boolean):void
		{
			nameInput.type = value? TextFieldType.DYNAMIC:TextFieldType.INPUT;
		}
		
		private function endTyping(e:TimerEvent):void 
		{
			isTypingName = false;
			dispatchEvent(new Event('endTypingName'));
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			crateSettingsUI();
		}
		
		private function createText(text:String):TextField
		{
			var tf:TextField = new TextField();
			tf.defaultTextFormat = format;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.text = text;
			tf.selectable = false;
			addChild(tf);
			
			return tf;
		}
		
		private function alignTextField(tf:TextField, component:Sprite):void
		{
			component.x = tf.x + tf.width + 5;
			component.y = tf.y + (component.height - tf.height)/2;
		}
		
		private function crateSettingsUI():void 
		{
			
			header = createText('МЕНЮ НАСТРОЕК');
			header.x = (stage.stageWidth - header.width) / 2;
			
			componentPlacement.y = header.y + header.height + 5;
			
			addChild(header);
			
			createComponent('isUseBollParticles');
			createComponent('isUseSoftwareBliting');
			createComponent('isShowSettingsOnStart');
			createComponent('isCenterPlatformOn');
			
			var hint:TextField = createText(UILables.GENERAL_HINT);
			addChild(hint);
			
			hint.x = (stage.stageWidth - hint.width) / 2;
			hint.y = componentPlacement.y + 5;
			componentPlacement.y += hint.height + 5;
			
			var bt:Sprite = new Sprite()
			bt.addChild(createText('NEXT'));
			bt.graphics.beginFill(0x0, 0);
			bt.graphics.drawRect(0, 0, bt.width, bt.height);
			addChild(bt);
			bt.x = (stage.stageWidth - bt.width) / 2;
			bt.y = componentPlacement.y + 10//stage.stageHeight - bt.height - 5;
			bt.addEventListener(MouseEvent.MOUSE_DOWN, goToNext);
			
			var bt2:Sprite = new Sprite()
			bt2.addChild(createText('FULL SCREEN'));
			bt2.graphics.beginFill(0x0, 0);
			bt2.graphics.drawRect(0, 0, bt.width, bt.height);
			addChild(bt2);
			bt2.x = (stage.stageWidth - bt2.width) / 2;
			bt2.y = componentPlacement.y + 10 + bt.height + 10//stage.stageHeight - bt.height - 5;
			bt2.addEventListener(MouseEvent.MOUSE_DOWN, goFUll);
			
			
			componentPlacement.y = bt2.y + bt2.height + 10;
			
			
			var nameHint:TextField = createText('Name:');
			
			addChild(nameHint);
			nameHint.x = componentPlacement.x //(stage.stageWidth - nameHint.width) / 2;
			nameHint.y = componentPlacement.y;
			
			nameInput = createText('TEST NAME ALALALLA');
			nameInput.type = 'input';
			
			addChild(nameInput);
			nameInput.x = componentPlacement.x + nameHint.width //(stage.stageWidth - nameHint.width) / 2;
			nameInput.y = componentPlacement.y;
			nameInput.autoSize = TextFieldAutoSize.NONE;
			nameInput.border = true;
			nameInput.borderColor = 0xCCCCCC;
			nameInput.selectable = true;
			nameInput.text = settingsModel.playerName;
			nameInput.addEventListener(Event.CHANGE, setPlayerNameToModel);
			
			statisticField = createText('');
			statisticField.autoSize = TextFieldAutoSize.NONE;
			statisticField.border = true;
			statisticField.borderColor = 0xCCCCCC;
			statisticField.selectable = true;
			statisticField.x = componentPlacement.x;
			statisticField.y = nameInput.y + nameInput.height + 10;
			statisticField.width = stage.stageWidth - statisticField.x - 10
			statisticField.height = stage.stageHeight - statisticField.y - 10
			statisticField.multiline = true;
			statisticField.wordWrap = true;
			
			addChild(statisticField);
		}
		
		public function printStatistic(statistic:String):void
		{
			trace(statistic);
			statisticField.appendText(statistic + String.fromCharCode(10)); 
		}
		
		private function setPlayerNameToModel(e:Event):void 
		{
			typingTimer.reset();
			typingTimer.start();
			isTypingName = true;
			settingsModel.playerName = nameInput.text;
		}
		
		private function goFUll(e:MouseEvent):void 
		{
			GlobalUIContext.vectorStage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE
		}
		
		private function goToNext(e:MouseEvent):void 
		{
			dispatchEvent(new Event('exit'));
		}
		
		private function createComponent(fieldname:String):void
		{
			var field:Object = settingsModel[fieldname];
			
			componentCreationStrategy[getQualifiedClassName(field)](fieldname);
		}
		
		private function createSwitchComponent(fieldName:String):void 
		{
			var switchComponent:Switch = new Switch(settingsModel[fieldName]);
			
			addChild(switchComponent);
			
			var hint:TextField = createText(fieldName);
			hint.x = componentPlacement.x;
			hint.y = componentPlacement.y;
			setHintText(hint, fieldName);
			
			
			alignTextField(hint, switchComponent);
			
			componentPlacement.y += switchComponent.height + 5;
			
			switchComponent.addEventListener(MouseEvent.MOUSE_DOWN, Delegate.create(switchProperty, hint, fieldName))
		}
		
		private function setHintText(hint:TextField, fieldName:String):void
		{
			hint.text = UILables.getSwitchText(fieldName, settingsModel[fieldName]);
		}
		
		private function switchProperty(e:MouseEvent, hint:TextField, fieldName:String):void 
		{
			(e.target as Switch).switchBur();
			settingsModel[fieldName] = !settingsModel[fieldName]
			trace(settingsModel[fieldName]);
			setHintText(hint, fieldName);
			//alignTextField(hint, (e.target as Switch));
		}
	}

}