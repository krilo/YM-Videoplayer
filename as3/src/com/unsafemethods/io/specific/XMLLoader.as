package com.unsafemethods.io.specific {
	import flash.system.LoaderContext;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.URLLoader;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.Event;

	import com.unsafemethods.io.Loader;


	/**
	 * @author jonathanpetersson
	 */
	public class XMLLoader extends Loader {
		
		private var xml		:XML;
		private var loader	:URLLoader;

		function XMLLoader(urlString:String, bytesTotal:int, variables:URLVariables=null, method:String = "post", context:LoaderContext=null) {
			super(urlString, bytesTotal, variables, method, context);
		}

		protected override function init():void {	
			
			if(loader) {
				loader.removeEventListener(Event.COMPLETE, onLoadedEvent);	
				loader.removeEventListener(ProgressEvent.PROGRESS, onProgressEvent);	
				loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
			}
			
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadedEvent);	
			loader.addEventListener(ProgressEvent.PROGRESS, onProgressEvent);	
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
			
		}
		
		protected override function doStart():Boolean {
			try {
				loader.load(url);
			}catch(e:Error) {
				errorString += e.message;
				return false;
			}
			
			return true;
		}
		
		protected override function doStop():Boolean {
			try {
				loader.close();
			}catch(e:Error) {
				errorString += e.message;
				return false;
			}
			
			return true;
		}
		
		private function onIOErrorEvent(event:IOErrorEvent):void {
			errorString += event.text;
			failed();
		}

		private function onProgressEvent(event:ProgressEvent):void {
			progress.setBytesLoaded(event.bytesLoaded);
			progress.setBytesTotal(event.bytesTotal);
						
			onProgress();
		}

		private function onLoadedEvent(event:Event):void {
			xml = new XML(loader.data);
			loaded();
		}

		public function getXML():XML {
			return xml;
		}
		
	}
}
