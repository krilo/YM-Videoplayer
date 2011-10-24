package com.yourmajesty.bastion.calc.expressions {
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Kasper
	 */
	public class Bounds {
		public static function isInBounds(point:Point, bounds:Rectangle):Boolean {
			var result:Boolean = false;
			
			if(point.x > bounds.x && point.y > bounds.y && point.x < bounds.width && point.y < bounds.height) {
				result = true;
			} 
			
			return result;
		}
	}
}
