package com.yourmajesty.bastion.debug {

   /**
    * @author Kasper
    */
   public class Debug {
   		public static function log(obj:*, message:String, persistent:Boolean = false, color:uint = 0xCDCDCD):void {
   			DebugContainer.instance.log(obj, message, color, persistent);
   		}   
   }
}
