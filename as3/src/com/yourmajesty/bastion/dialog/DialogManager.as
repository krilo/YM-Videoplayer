package com.yourmajesty.bastion.dialog {
	import com.unsafemethods.view.View;
	import com.yourmajesty.bastion.debug.Debug;
	import com.yourmajesty.castellum.Castellum;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	/**
	 * @author Kasper
	 * This will be an attempt to a Dialog (or popup if you wish) Manager, that can open/close dialogs
	 * load them in an appointed container and style them per project
	 */
	public class DialogManager extends Sprite {
	
		private static var _instance			:DialogManager;
		
		public var overlay						:DisplayObject;
		
		private static var dialogs				:Dictionary;
		
		public static function get instance():DialogManager {
			if(!_instance){
				_instance = new DialogManager();
				
			}
			return _instance;
		} 
		
		public function init():void {
			
		}
		
		/*public static function addDialogClass(id:String, DialogClass:Class):void {
			if(dialogs == null) {
				dialogs = new Dictionary();
			}
			
			if(!dialogs[id]) {
				dialogs[id] = DialogClass;
			}
		}*/
		
		public static function addDialog(id:String, DialogClass:Class, props:Object = null):void {
			if(dialogs == null) {
				dialogs = new Dictionary();
			}
			
			dialogs[id] = { dialogClass:DialogClass, props:props };
		}

		public static function openDialog(id:String, closeCurrent:Boolean = true):void {
			
			// do magic
			
			if(instance.numChildren > 0 && closeCurrent){
				closeDialogs();
			}
			
			var dialog:* = new dialogs[id].dialogClass(dialogs[id].props);
			dialog.prepare();
			
			instance.addChild(dialog);
			dialog.open();
			Castellum.resize();
		}
		
		public static function closeDialogs():void {
			var loopCount:int = instance.numChildren;
			for(var i : int = 0; i < loopCount; i++) {
				var child:View = View(instance.getChildAt(0));
				instance.removeChild(child);
				child = null;
			}
		}
		
		public static function closeDialog(dialogId:String):void {
				
		}
		
		public static function resize(w:int, h:int):void {
			for (var i : int = 0; i < instance.numChildren; i++) {
				var child:DisplayObject = instance.getChildAt(i);
				
				if((child as Dialog).overriddenWidth > 0){
					child.x = Math.round(w / 2 - (child as Dialog).overriddenWidth/2);
				}else {
					child.x = Math.round(w / 2 - child.width/2);
				}
				
				if((child as Dialog).overriddenHeight > 0){
					child.y = Math.round(h / 2 - (child as Dialog).overriddenHeight/2);
				}else {
					child.y = Math.round(h / 2 - child.height/2);
				}
				
			}			
		}
		
		public function get getCurrentDialog():View
		{
			return View(instance.getChildAt(0));
		}
	}
}		
