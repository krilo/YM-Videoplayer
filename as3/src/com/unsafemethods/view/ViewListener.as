package com.unsafemethods.view {

	/**
	 * @author jonathanpetersson
	 */
	public interface ViewListener {
		
		function onViewOpened(view:View):void;
		function onViewClosed(view:View):void;
		
	}
}
