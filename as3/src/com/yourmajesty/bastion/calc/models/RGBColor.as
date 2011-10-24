package com.yourmajesty.bastion.calc.models {

	/**
	 * @author Kasper
	 */
	public class RGBColor {
		
		private var _r				:int;
		private var _g				:int;
		private var _b 				:int;
		
		public function RGBColor($r:int = 0, $g:int = 0, $b:int = 0){
			_r = $r;
			_g = $g;
			_b = $b;
		}
		
		public function get r():int { return _r; }
		public function set r(r:int):void {	_r = r; }		
		
		public function get g():int { return _g; }		
		public function set g(g:int):void {	_g = g;	}
		
		public function get b():int { return _b; }
		public function set b(b:int):void {	_b = b;	}		
	}
}
