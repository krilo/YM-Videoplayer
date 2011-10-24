package com.unsafemethods.view {

	/**
	 * @author jonathanpetersson
	 */
	public class Action {
	
		public static const TYPE_OPEN	:int = 0;
		public static const TYPE_CLOSE	:int = 1;
		
		private var view	:View;
		private var type	:int;
		
		function Action(view:View, type:int) {
			this.view = view;
			this.type = type;
		}
		
		public function getView():View {
			return view;
		}
		
		public function getType():int {
			return type;
		}
		
	}
}
