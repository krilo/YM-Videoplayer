package com.yourmajesty.bastion.calc.expressions {
	import com.yourmajesty.bastion.calc.models.RGBColor;

	/**
	 * @author kasperkuijpers
	 * 
	 * Simple algorithms to help converting color scales
	 */
	
	public class Color
	{
		public static function rgbToHex($rgbColor:RGBColor):uint {
			return($rgbColor.r<< 16 | $rgbColor.g<<8 | $rgbColor.b);
		}
		
		public static function hexToRgb($hex:uint):RGBColor
		{
			var rgbColor:RGBColor = new RGBColor();
			
			rgbColor.r = (($hex & 0xFF0000) >> 16);
			rgbColor.g = (($hex & 0x00FF00) >> 8);
			rgbColor.b = (($hex & 0x0000FF));
			
			return rgbColor;
		}	
	}
}