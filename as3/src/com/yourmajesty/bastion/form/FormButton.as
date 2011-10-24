package com.yourmajesty.bastion.form {
	import com.yourmajesty.castellum.display.ui.button.CButton;
	import flash.display.DisplayObject;

	/**
	 * @author Kasper
	 */
	public class FormButton extends FormObject {
		
		public var buttonClass:Class;
		public var button:CButton;
		
		
		public function FormButton(buttonClass:Class) {
			
			this.buttonClass = buttonClass;
			
			super();
		}

		override public function init() : void {
			super.init();
			
			this.button = new buttonClass("form", this.stringId);
			this.button.prepare();
			this.button.open();
			
			//if(this.button!=null){
				this.addChild(this.button);
			//}
		}
	}
}
