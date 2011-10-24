package com.unsafemethods.io.specific {
	import com.unsafemethods.io.Loader;
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.net.URLVariables;
	import flash.display.DisplayObject;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.events.Event;

	/**
	 * @author jonathanpetersson
	 */
	public class DisplayObjectLoader extends com.unsafemethods.io.Loader {
		
		protected var displayObject	:DisplayObject;
		private var loader			:flash.display.Loader;
		
		function DisplayObjectLoader(urlString:String, bytesTotal:int, variables:URLVariables=null, method:String = "post", context:LoaderContext=null) {
			super(urlString, bytesTotal, variables, method, context);
		}
		
		protected override function init():void {
			if(loader) {	
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadedEvent);
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgressEvent);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
			}
			
			loader = new flash.display.Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadedEvent);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressEvent);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
		}
		
		protected override function doStart():Boolean {
			try {
				loader.load(url, context);
			}catch(error:Error){
				errorString += error.message;
				return false;
			}
			
			return true;
		}
		
		protected override function doStop():Boolean {
			try {
				loader.close();
			}catch(error:Error) {
				errorString +=error.message;
				return false;
			}
			
			return true;
		}
		
		private function onIOErrorEvent(event:IOErrorEvent):void {
			trace(event);
			failed();
		}

		private function onProgressEvent(event:ProgressEvent):void {
			progress.setBytesLoaded(event.bytesLoaded);
			progress.setBytesTotal(event.bytesTotal);
			onProgress();
		}

		private function onLoadedEvent(e:Event):void {
			displayObject = loader.contentLoaderInfo.content;
			loaded();
		}		
		
		public function getDisplayObject():DisplayObject {
			return displayObject;
		}
	}
}
