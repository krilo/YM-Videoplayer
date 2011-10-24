package com.yourmajesty.bastion.debug {
	import flash.events.Event;

	/**
    * @author Kasper
    */
   public class DebugEvent extends Event {
      public static const REMOVE			:String = "remove";
      
      public function DebugEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
         super(type, bubbles, cancelable);
      }
   }
}
