package com.yourmajesty.bastion.display {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;

	public class Asset extends MovieClip
	{
		protected var xmlData:XML;
		
		public function Asset()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
		}
		
		protected function onAddedToStage(eo:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		
		protected function onRemovedFromStage(eo:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			destroy();
		}
		
		public function init():void {
			
		}
		
		public function destroy():void {
			
		}
		
		protected function empty(clip:MovieClip):void {
			if(clip.numChildren > 0){
				for(var i:uint=0; i<clip.numChildren; i++){
					var child:DisplayObject = DisplayObject(clip.getChildAt(i));
					clip.removeChildAt(i);
					child = null;
				}
				
				if(clip.numChildren > 0){
					empty(clip);
				}
			}	
		}
		
		public function disable():void {
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		
		public function enable():void {
			this.mouseChildren = true;
			this.mouseEnabled = true;
		}
	}
}