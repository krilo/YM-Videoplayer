package com.unsafemethods.io {
	import flash.system.LoaderContext;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.net.URLVariables;

	/**
	 * @author jonathanpetersson
	 */
	public class Loader extends AbstractLoader {

		protected var url					:URLRequest;
		protected var context				:LoaderContext;
		
		protected var method				:String;
		protected var variables				:URLVariables;

		protected var listeners				:Dictionary;
		
		function Loader(urlString:String, bytesTotal:int, variables:URLVariables=null, method:String = "post", context:LoaderContext=null) {
			super();
			
			progress.setBytesTotal(bytesTotal);
			
			this.variables = variables;
			this.method = method;
			
			url = new URLRequest(urlString);
			url.data = variables;
			url.method = this.method;
			
			if(context == null) context = new LoaderContext(true);
			
			listeners = new Dictionary();
			
			init();
		}
		/**
		 * Override this method and use it to initalize your specialized loader.
		 * For instance, all internal instantiation should be called here, <b>not</b> in the constructor.
		 */
		protected override function init():void {
			
		}
		
		/**
		 * Add a LoaderListener to be notified when something interesting happens.
		 */
		public function addListener(listener:LoaderListener):void {
			listeners[listener] = true;
		}
		
		/**
		 * Unregister a LoaderListener.
		 */
		public function removeListener(listener:LoaderListener):void {
			if(listeners[listener]) delete listeners[listener];
		}
		
		/**
		 * Returns the current URLRequest.  
		 */		
		public function getURL():URLRequest {
			return url;
		}
		
		/**
		 * Returns the current HTTP method type. "post" or "get".
		 * 
		 */
		public function getMethod():String {
			return method;
		}
		
		/**
		 * Returns the current URLVariables, if defined.
		 */
		public function getVariables():URLVariables {
			return variables;
		}
		
		/**
		 * Call this method once your specialized loader is done.
		 */
		protected override function loaded():void {
			super.loaded();
			
			for(var o:Object in listeners) (o as LoaderListener).onLoaderDone(this);
		}
		
		/**
		 * Call this method when your specialized loader has failed.
		 */
		protected override function failed():void {
			for(var o:Object in listeners) (o as LoaderListener).onLoaderFailed(this);
		}
		
		/**
		 * Call this method to report progress to all LoaderListener objects.
		 */
		protected override function onProgress():void {
			for(var o:Object in listeners) (o as LoaderListener).onLoaderProgressUpdated(this);
		}
	}
}
