package com.unsafemethods.io.specific {
	import flash.system.LoaderContext;
	import flash.net.URLVariables;
	import flash.display.Bitmap;

	import com.unsafemethods.io.specific.DisplayObjectLoader;

	/**
	 * @author jonathanpetersson
	 */
	public class ImageLoader extends DisplayObjectLoader {
		
		function ImageLoader(urlString:String, bytesTotal:int, variables:URLVariables=null, method:String = "post", context:LoaderContext=null) {
			super(urlString, bytesTotal, variables, method, context);
		}
		
		public function getBitmap():Bitmap {
			return getDisplayObject() as Bitmap;
		}
	}
}
