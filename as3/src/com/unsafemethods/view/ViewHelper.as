package com.unsafemethods.view {

	import flash.utils.Dictionary;

	/**
	 * @author jonathanpetersson
	 */
	public class ViewHelper {

		public static function open(view:View):Boolean {
			if(!(lineageIsBusy(view) && !view.isOpened())) {
				return openView(view);
			}
			
			return false;
		}
		
		public static function close(view:View):Boolean {
			if(!(lineageIsBusy(view) && view.isOpened())) {
				return closeView(view);
			}
			
			return false;
		}
		
		public static function toggle(view:View):Boolean {
			if(view.isOpened()) {
				return ViewHelper.close(view);
			}else{
				return ViewHelper.open(view);
			}
		}
		
		private static function openView(view:View):Boolean {
			var vp:View = view.getParent();
			
			if(vp) {
				if(vp.isOpened()) {
					var siblings:Dictionary = vp.getChildren();
					for(var o:Object in siblings) {
						var sibling:View = o as View;
						if(sibling.isOpened()) {
							sibling.setOnClosedAction(new Action(view, Action.TYPE_OPEN));	
							return closeView(sibling);
						}
					}
				}else{
					vp.setOnOpenedAction(new Action(view, Action.TYPE_OPEN));
					return ViewHelper.open(vp);
				}
			}
			
			return view.toState(View.STATE_OPENED);
		}
		
		private static function closeView(view:View):Boolean {
			var children:Dictionary = view.getChildren();
			for(var o:Object in children) {
				var child:View = o as View;
				if(child.isOpened()) {
					child.setOnClosedAction(new Action(view, Action.TYPE_CLOSE));	
					return ViewHelper.closeView(child);
				}
			}
			
			return view.toState(View.STATE_CLOSED);
		}
		
		private static function lineageIsBusy(view:View):Boolean {
			var vp:View = view.getParent();
			
			if(vp) {
				if(vp.isBusy()) return true;
				
				while(vp = vp.getParent()) {
					if(vp.isBusy()) return true;
				}
			}
			
			return false;
		}
		
		public static function onViewOpened(view:View):void {
			var action:Action = view.getOnOpenedAction();

			if(action) {
				if(action.getType() == Action.TYPE_OPEN) {
					ViewHelper.openView(action.getView());
				}
			}
		}
		
		public static function onViewClosed(view:View):void {
			var action:Action = view.getOnClosedAction();	
			
			if(action) {	
				if(action.getType() == Action.TYPE_CLOSE) {
					ViewHelper.closeView(action.getView());	
				}else if(action.getType() == Action.TYPE_OPEN) {
					ViewHelper.openView(action.getView());
				}
			}
		}
	}
}