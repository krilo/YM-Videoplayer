package com.unsafemethods.state {
	import flash.utils.Dictionary;

	/**
	 * @author jonathanpetersson
	 * 
	 * Mealy Machine
	 * 
	 */
	public class StateMachine {
		
		private var states					:Dictionary;
		
		private var initialState			:State;
		private var currentState			:State;
		private var nextState				:State;

		private var listeners				:Dictionary;
		
		private var enabled					:Boolean = true;
		
		public static const REGULAR_STATE	:int = 0;
		public static const INITIAL_STATE	:int = 1;
		
		function StateMachine() {
			states = new Dictionary();
			listeners = new Dictionary();
		}
		
		public function addListener(listener:StateMachineListener):void {
			listeners[listener] = true;
		}
		
		public function removeListener(listener:StateMachineListener):void {
			if(listeners[listener]) delete listeners[listener];
		}
		
		protected function addState(state:State, type:int=REGULAR_STATE):void {
			states[state] = true;
			
			if(type == INITIAL_STATE) currentState = initialState = state;
		}
		
		public function activate(state:State):Boolean {
			if(states[state]) {
				if(enabled && !nextState && state != currentState) {
					nextState = state;
					for(var listener:Object in listeners) (listener as StateMachineListener).transition(this, currentState, nextState);
					return true;
				}
			}
			
			return false;
		}
		
		public function onTransitionComplete():void {
			currentState = nextState;
			nextState = null;
		}
		
		public function getCurrentState():State {
			return currentState;
		}
		
		public function getNextState():State {
			return nextState;
		}
		
		public function enable():void {
			enabled = true;
		}
		
		public function disable():void {
			enabled = false;
		}
		
		public function isEnabled():Boolean {
			return enabled;
		}
		
		public function reset():void {
			nextState = null;
			currentState = initialState;
		}
		
	}
}