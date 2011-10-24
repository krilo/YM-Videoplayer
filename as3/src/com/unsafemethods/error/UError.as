package com.unsafemethods.error {

	/**
	 * @author jonathanpetersson
	 */
	public class UError extends Error {
		
		public static const UNIMPLEMENTED_METHOD	:String = "Unimplemented method.";
		public static const NO_LISTENER				:String = "No listener registered.";

		public function UError(message:* = "", id:* = 0)
		{
			super(message, id);
		}
	}
}
