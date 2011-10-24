package com.yourmajesty.bastion.dialog {
	import flash.events.Event;
	
	/**
	 * @author Kristofer
	 */
	public class DialogEvent extends Event {
		
		public static const CLOSE			:String = "close";
		public static const ACCEPT			:String = "accept";
		public static const CANCEL			:String = "cancel";
		
		public var progress				:Number;
		
		public function DialogEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			
			this.progress = progress;
		}
	}
}
