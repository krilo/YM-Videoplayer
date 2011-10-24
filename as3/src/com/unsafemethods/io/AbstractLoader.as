package com.unsafemethods.io {

	/**
	 * @author jonathanpetersson
	 * 
	 * This class should <b>NEVER</b> be instantiated directly, think of it as an Abstract JAVA class. 
	 * 
	 * 
	 */
	public class AbstractLoader {
		
		public static const STATE_WAITING	:int = 0;
		public static const STATE_RUNNING	:int = 1;
		public static const STATE_LOADED	:int = 2;
		public static const STATE_FAILED	:int = 3;
		
		private var state					:int = STATE_WAITING;
		
		protected var progress				:Progress;
		protected var errorString			:String = "";
		
		/**
		 * It is <i>required</i> to call this constructor.
		 */
		function AbstractLoader() {
			progress = new Progress();
		}
		
		/**
		 * Brings the AbstractLoader back to STATE_WAITING. Does nothing if the loader is currently in STATE_RUNNING.
		 */
		public function reset():void {
			if(state != STATE_RUNNING) {
				state = STATE_WAITING;
				init();
			}
		}
		
		/**
		 * Tells the AbstractLoader to start load. Will return true upon success and false if it's currently in a blocked state.
		 */
		public function start():Boolean {
			if(state == STATE_WAITING) {
				state = STATE_RUNNING;
				
				if(doStart()) {
					//O(this, "start: true");
					return true;
				}else{
					//O(this, "start: false");
					state = STATE_FAILED;
				}
			}
			
			return false;
		}
		
		/**
		 * Will try to stop the AbstractLoader if it's currently in STATE_RUNNING.
		 */
		public function stop():Boolean {
			if(state == STATE_RUNNING) {
				state = STATE_FAILED;
				return doStop();
			}
			
			//O(this, "stop");
			
			return false;	
		}
		
		/**
		 * Override this method and use it to initalize your specialized loader.
		 * For instance, all internal instantiation should be called here, <b>not</b> in the constructor.
		 */
		protected function init():void { }
		
		/**
		 * Override this method and use it to start your specialized loader.
		 */
		protected function doStart():Boolean { return false; }
		/**
		 * Override this method and use it to stop your specialized loader.
		 */
		protected function doStop():Boolean { return false; }
		/**
		 * Override this method and use it to reset your specialized loader.
		 */
		protected function doReset():void { }
		/**
		 * Override this method and use it to report a on progress change.
		 */
		protected function onProgress():void { }
		
		/**
		 * Call this method once the load is done.
		 */
		protected function loaded():void {
			//O(this, "loaded");
			state = STATE_LOADED;
		}
		
		/**
		 * Call this method when the load failed.
		 */
		protected function failed():void {
			//O(this, "failed");
			state = STATE_FAILED;
		}
		
		/**
		 * Returns the current state.
		 */
		public function getState():int {
			return state;
		}
		
		/**
		 * Manually set the current internal state. This should not be used unless absolutely necessary.
		 */
		public function setState(state:int):void {
			this.state = state;
		}
		
		/**
		 * Returns the Progress object
		 */
		public function getProgress():Progress {
			return progress;
		}
		
		/**
		 * Returns the current errorString.
		 */
		public function getErrorString():String { 
			return errorString;
		}

	}
}