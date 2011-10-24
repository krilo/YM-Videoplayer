package com.unsafemethods.view {

	/**
	 * @author jonathanpetersson
	 */
	public class ViewError extends Error {
		
		public static var ID_CONFLICT	:String = "FATAL ERROR: A view ID must be unique, or not defined at all.";
		
		public function ViewError(message:* = "", id:* = 0)
		{
			super(message, id);
		}
	}
}
