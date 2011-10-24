package com.yourmajesty.bastion.debug {
	import com.greensock.TweenLite;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
    * @author Kasper
	 */

   
   public class DebugMessage extends Sprite {
		
		public var obj			:*;
		public var message		:String;
		public var anonymous	:Boolean;
		public var color		:uint;
		public var persistent	:Boolean;
		
		private var textField	:TextField = new TextField();
		
		public function DebugMessage(obj:*, message:String, color:uint = 0xCDCDCD, persistent:Boolean = false){
			this.obj = obj;
			this.message = message;
			this.color = color;
			this.persistent = persistent;
						
			var tf:TextFormat = new TextFormat("Arial", 12);
			
			this.addChild(textField);
			textField.setTextFormat(tf);
			if(obj != null){
				textField.htmlText = "<font face=\"Arial\">" + obj.toString() + ":		<b>" + message + "</b></font>";
			} else {
				 textField.htmlText = "<font face=\"Arial\">null:		<b>" + message + "</b></font>";
			}
			textField.width = 800;
			textField.height = 40;
			textField.selectable = false;
			
			this.graphics.beginFill(color, 1);
			this.graphics.drawRect(1, 1, textField.textWidth + 40, 20 * textField.numLines);
			this.graphics.endFill();
			
			this.hide();
			this.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true); 
		}

		private function onOver(event : MouseEvent) : void {
			dispatchEvent(new DebugEvent(DebugEvent.REMOVE, false));
			TweenLite.killTweensOf(this);	
		}

		public function hide():void {
			if(!persistent){
				TweenLite.to(this, 0.3, {
					delay: 3,
					alpha: 0,
					onComplete:function():void {
						dispatchEvent(new DebugEvent(DebugEvent.REMOVE, false));	
					},
					overwrite:1
				});
			}
		}
	}
}
