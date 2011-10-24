package com.yourmajesty.bastion.debug {
	import net.hires.debug.Stats;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
    * @author Kasper
	 */

   
   public class DebugContainer extends Sprite {
		
		private static var _instance	:DebugContainer;
		
		private var stats				:Stats;
		private const Y_DIST			:int = 20;
		
		public function DebugContainer(){
			stats = new Stats();
	
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}

		private function onAddedToStage(event : Event) : void {
			if(!this.contains(stats)){
				this.addChild(stats);
				stats.cacheAsBitmap = true;
			}
			
			stage.addEventListener(Event.RESIZE, onResize, false, 0, true);
			onResize(null);
		}
		
		public static function get instance():DebugContainer {
			if(!_instance){
				_instance = new DebugContainer();
			}
			
			return _instance;
		}
		
		public function log(obj:*, message:String, color:uint = 0xCDCDCD, persistent:Boolean = false):void {
			var debugMessage:DebugMessage = new DebugMessage(obj, message, color, persistent);
			debugMessage.addEventListener(DebugEvent.REMOVE, onRemoveMessage, false, 0, true);
			
			debugMessage.y = this.numChildren * Y_DIST;
			this.addChild(debugMessage);
		}

		private function onRemoveMessage(event : DebugEvent) : void {
			var debugMessage:DebugMessage = DebugMessage(event.currentTarget);
			this.removeChild(debugMessage);
			debugMessage = null;
			
			for (var i : int = 0; i < this.numChildren; i++) {
				if(this.getChildAt(i) is DebugMessage){
				
					var child:DebugMessage = DebugMessage(this.getChildAt(i));
					child.y = i * Y_DIST;
				}
			}		
		}
		
		private function onResize(event : Event) : void {
			stats.x = stage.stageWidth - stats.width;
		}
	}
}
