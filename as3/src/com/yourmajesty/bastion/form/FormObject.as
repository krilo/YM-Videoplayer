package com.yourmajesty.bastion.form {
	import com.yourmajesty.castellum.display.ui.text.CTextField;
	import com.yourmajesty.bastion.debug.Debug;
	import com.yourmajesty.bastion.display.Asset;

	/**
	 * @author Kasper
	 */
	public class FormObject extends Asset {
		
		public var id				:String = "";
		public var marginLeft		:int = 0;
		public var marginRight		:int = 0;
		public var stringId			:String = "";
		public var fieldWidth 		:int;
		public var fieldHeight		:int;
		public var optional			:Boolean;
		public var input			:CTextField;
		public var label			:CTextField;
		public var defaultInput		:String;
		public var fieldTabIndex	:int;
		public var xml 				:XML;

		
		public function FormObject() {
		}

		override public function init() : void {
			this.stringId = xml.@stringId;
			this.id = xml.@id;
			this.fieldWidth = xml.@width;
			this.fieldHeight = xml.@height;
			this.fieldTabIndex = xml.@tabIndex;
			/*this.defaultInput = xml.@stringId;*/
			
			this.tabEnabled = false;
			
			if(xml.@optional == "true"){
				this.optional = true;
			} else {
				this.optional = false;
			}
			
			super.init();
		}

		override public function destroy() : void {
			super.destroy();
		}
		
		public function get value():* {
			return;
		}
		
		public function invalidate(index:int):void {
			Debug.log(this, "invalidate(" + [index] + ")");
		}
	}
}
