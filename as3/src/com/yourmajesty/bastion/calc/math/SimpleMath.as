package com.yourmajesty.bastion.calc.math {

	/**
	 * @author kasperkuijpers
	 * 
	 * Simple algorithms to help with common math problems
	 */

	public class SimpleMath
	{
		/**
		 * Returns random -1 or 1
		 * 0.5 - (0 or 1) = -0.5 or 0.5
		 */
		public static function get negOrPos():int {
			return (0.5 - Math.round(Math.random())) * 2;
		}
		
		public static function keepPositive(value:Number):Number {
			var result:Number = value;
			
			if(result < 0){
				result = -result;
			}
			
			return result;
		}
		
		public static function keepNegative(value:Number):Number {
			var result:Number = value;
			
			if(result > 0){
				result = -result;
			}
			
			return result;
		}
	}
}