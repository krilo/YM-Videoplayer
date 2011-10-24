package com.yourmajesty.bastion.form {
	import flash.events.Event;

	/**
	 * @author Kasper
	 */
	public class FormEvent extends Event {
		public static const DOWN : String = "DOWN";
		public static const DROPDOWN_SELECT : String = "DROPDOWN_SELECT";
		public static const SELECT : String = "SELECT";
		public static const COMPLETE : String = "COMPLETE";
		public static const CANCEL : String = "CANCEL";
		public static const ERROR : String = "ERROR";

		public var value		:String;
		public var item			:String;
		
		public function FormEvent(type : String, bubbles : Boolean = false, value:String = "", item:String="", cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			
			this.value = value;
			this.item = item;
		}
	}
}
