package com.yourmajesty.bastion.dialog {

	/**
	 * @author Kasper
	 */
	public class DialogError extends Error {
		public function DialogError(message : * = "", id : * = 0) {
			super(message, id);
		}
	}
}
