package com.unsafemethods.view {

	import flash.utils.Dictionary;

	import com.unsafemethods.state.StateMachine;
	import com.unsafemethods.state.StateMachineListener;
	import com.unsafemethods.state.State;

	import flash.display.Sprite;

	/**
	 * @author jonathanpetersson
	 */
	public class View extends Sprite implements StateMachineListener {
		
		private static var IDList		:Dictionary;
		
		public static const STATE_OPENED	:State = new State();
		public static const STATE_CLOSED	:State = new State();
		
		private var id					:String;
		private var sm					:VSM;
		
		private var listeners			:Dictionary;
		
		private var parentView			:View;
		
		private var children			:Dictionary;
		private var onClosedAction		:Action = null;
		private var onOpenedAction		:Action = null;
		
		private var defaultChild		:View;
		
		public function View() {
			sm = new VSM();
			sm.addListener(this);
			listeners = new Dictionary();
			children = new Dictionary();
		}
		
		public function prepare():void {
			
		}
		
		public function setId(id:String):void {
			if(!IDList) IDList = new Dictionary();
			if(id != null && IDList[id]) throw new ViewError(ViewError.ID_CONFLICT);
			if(id != null) IDList[id] = true;
			
			this.id = id;
		}
		
		public function addListener(listener:ViewListener):void {
			listeners[listener] = true;
		}
		
		public function removeListener(listener:ViewListener):void {
			if(listeners[listener]) delete listeners[listener];
		}
		
		
		public function addView(child:View, isDefaultView:Boolean=false):void {
	
			children[child] = true;
			child.setParent(this);
			
			if(isDefaultView) setDefaultChild(child);
		
		}
		
		public function removeView(child:View):void {
			if(children[child]) {
				delete children[child];	
			}
		}
		
		private function setDefaultChild(defaultChild:View):void {
			this.defaultChild = defaultChild;
		}
		
		public function setParent(parentView:View):void {
			this.parentView = parentView;
		}
		
		public function toState(state:State):Boolean {
			if(sm.activate(state)) {
				return true;
			}
			return false;
		}
		
		public function open():Boolean {
			return ViewHelper.open(this);
		}
		
		public function close():Boolean {
			return ViewHelper.close(this);
		}
		
		public function toggle():Boolean {
			return ViewHelper.toggle(this);
		}
		
		protected function doOpen():void  {
			
		}
		
		protected function doClose():void {
	
		}
		
		protected function onOpened():void {
			sm.onTransitionComplete();
			ViewHelper.onViewOpened(this);
			onOpenedAction = null;
			for(var o:Object in listeners) (o as ViewListener).onViewOpened(this);
		}
		
		protected function onClosed():void {
			sm.onTransitionComplete();
			ViewHelper.onViewClosed(this);
			onClosedAction = null;
			for(var o:Object in listeners) (o as ViewListener).onViewClosed(this);
		}
		
		//StateMachineListener
		public function transition(sm:StateMachine, from:State, to:State):void {
			if(sm === this.sm) {
				if(to === View.STATE_OPENED) {
					doOpen();
				}else if(to === View.STATE_CLOSED) {
					doClose();
				}
			}			
		}
		
		//Conditions
		public function isOpened():Boolean {
			return sm.getCurrentState() === View.STATE_OPENED && sm.getNextState() == null;
		}
		
		public function isTransitioning():Boolean {
			return sm.getNextState() != null;
		}
		
		public function isBusy():Boolean {
			
			if(isTransitioning()) return true;
			
			for(var o:Object in children) {
				var child:View = o as View;
				if(child.isBusy()) return true;
			}
			
			if(onOpenedAction) return true;
			if(onClosedAction) return true;
			
			return false;
		}
		
		//Fields
		public function getId():String {
			return id;
		}
		
		public function getChildren():Dictionary {
			return children;
		}
		
		public function getChildById(id:String):View {
			for(var o:Object in children) if((o as View).getId() == id) return o as View;
			return null;
		}
		
		public function getDescendantById(id:String):View {
			var child:View = getChildById(id);
			if(child) {
				return child;
			}
			
			for(var o:Object in children) {
				var descendant:View = (o as View).getDescendantById(id);	
				if(descendant) return descendant;
			}
			
			return null;
		}
		
		public function getParent():View {
			return parentView;
		}
		
		public function setOnClosedAction(action:Action):void {
			onClosedAction = action;
		}
		
		public function getOnClosedAction():Action {
			return onClosedAction;
		}
		
		public function setOnOpenedAction(action:Action):void {
			onOpenedAction = action;
		}
		
		public function getOnOpenedAction():Action {
			return onOpenedAction;
		}
		
		public function resize(w:Number, h:Number):void {
			if(sm.getNextState() == View.STATE_OPENED || isOpened()) doResize(w, h);	
		}
		
		protected function doResize(w:Number, h:Number):void {
			
		}
	}
}

import com.unsafemethods.state.StateMachine;
import com.unsafemethods.view.View;

//ViewStateMachine
class VSM extends StateMachine {

	function VSM() {	
		addState(View.STATE_CLOSED, StateMachine.INITIAL_STATE);
		addState(View.STATE_OPENED);
	}

}

