package com.yourmajesty.bastion.calc.expressions {
	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * @author kasperkuijpers
	 * 
	 * Simple algorithms to help common scaleing problems 
	 */
	
	public class Scaling
	{
		
		/**
		 * This method should resize and center a displayObject to fit within certain bounds while keeping it's ratio intact
		 *  
		 * @param displayObject: The object that needs to be rescaled
		 * @param dyanmicBounds: The desired width or height of the displayobject, for example: stageWidth & stageHeight 
		 * @param ratio, optional: displayObject's orginal dimensions, or desired ratio, !! recommended input to avoid redrawing/flickering
		 */
		
		public static function maxInsideBounds(displayObject:DisplayObject, dynamicBounds:Point, ratio:Point = null):void {
			if(!ratio){
				displayObject.scaleX = displayObject.scaleY = 1;
				ratio = new Point(displayObject.width, displayObject.height);
			}
			
    		var scaleX:Number = dynamicBounds.x / ratio.x;
			var scaleY:Number = dynamicBounds.y / ratio.y;
		
			if(scaleX < scaleY){
				displayObject.scaleX = scaleX;
				displayObject.scaleY = scaleX;
			} else if(scaleY < scaleX){
				displayObject.scaleX = scaleY;
				displayObject.scaleY = scaleY;
			} else if(scaleX == scaleY){
				displayObject.scaleX = scaleX;
				displayObject.scaleX = scaleX;
			}
			
			
			displayObject.x = Math.round((dynamicBounds.x - displayObject.width) / 2);
			displayObject.y = Math.round((dynamicBounds.y - displayObject.height) / 2);
		}
		
		public static function getScaleInsideBounds(dynamicBounds:Point, ratio:Point):Number {
			var scale:Number;
			
			var scaleX:Number = dynamicBounds.x / ratio.x;
			var scaleY:Number = dynamicBounds.y / ratio.y;
		
			if(scaleX < scaleY){
				scale = scaleX;
			} else if(scaleY < scaleX){
				scale = scaleY;
			} else if(scaleX == scaleY){
				scale = scaleX;
			}
			
			
			return scale;
		}
		
		/**
		 * This method will resize and center a displayObject to maximally fit certain bounds while keeping it's ratio intact
		 * 
		 * @param displayObject: The object that needs to be rescaled
		 * @param dyanmicBounds: The desired width or height of the displayobject, for example: stageWidth & stageHeight 
		 * @param ratio, optional: displayObject's orginal dimensions, or desired ratio, !! recommended input to avoid redrawing/flickeering
		 */
		
		public static function maxOutsideBounds(displayObject:DisplayObject, dynamicBounds:Point, ratio:Point = null):void {
			
			if(!ratio){
				displayObject.scaleX = displayObject.scaleY = 1;
				ratio = new Point(displayObject.width, displayObject.height);
			}
						
			var scaleX:Number = dynamicBounds.x / ratio.x;
			var scaleY:Number = dynamicBounds.y / ratio.y;
								
			if(scaleX > scaleY){
				displayObject.scaleX = scaleX;
				displayObject.scaleY = scaleX;
			} else if(scaleY > scaleX){
				displayObject.scaleX = scaleY;
				displayObject.scaleY = scaleY;
			}
				
			displayObject.x = (-(displayObject.width - (dynamicBounds.x))/2); 
			displayObject.y = (-(displayObject.height - (dynamicBounds.y))/2);	
		}
	}
}