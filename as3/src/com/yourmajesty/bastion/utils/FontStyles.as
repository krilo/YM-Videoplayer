package com.yourmajesty.bastion.utils {
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	/**
	 * @author Kasper
	 */
	public class FontStyles {
		
		private static var _instance			:FontStyles;
		private var _styles						:Dictionary = new Dictionary();
		
		public static function get instance():FontStyles {
			if(!_instance){
				_instance = new FontStyles();
			}
			return _instance;
		} 
		
		public function FontStyles() {
			
		}
		
		public function addStyle($id:String, $styleObject:Object):void {
			_styles[$id] = $styleObject;	
		}
		
		public function getStyle($id:String):Object {
			return _styles[$id];
		}
		
		public function createStylesFromXML($xml:XML):void {
			for (var i : int = 0; i < $xml.style.length(); i++) {
				var style:XML = $xml.style[i];
				var id:String =  $xml.style[i].@id;
				
				_styles[id] = parseFormats(style);
			}
		}
		
		private function parseFormats($xml:XML):Object {
			var formatObject:Object = new Object();
			
			for (var i : int = 0; i < $xml.format.length(); i++) {
				formatObject[$xml.format[i].@id] = $xml.format[i].@value; 
				//trace( "formatObject:" + formatObject[$xml.format[i].@id] );
			}
			
			//for each (var s : String in formatObject) {
				//trace( "formatObject:" + s );
			//}
			
			
			return formatObject;
		}
		
		public function getStyleAsFormat($id:String):TextFormat {
			var format:TextFormat = new TextFormat();
			format.color = 0xFF00FF;
			
			var style:Object = getStyle($id);

			if(style)
			{
				for(var i:String in style)
				{
					format[i] = style[i];
				}
			}
			
			return format;
		}
	}
}
