package com.unsafemethods.state {

	/**
	 * @author jonathanpetersson
	 */
	public interface StateMachineListener {
		
		function transition(sm:StateMachine, from:State, to:State):void;

	}
}
