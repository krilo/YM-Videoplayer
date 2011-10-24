package com.unsafemethods.util {
		
	public function O(o:*, m:String=""):void {
		if(o is String) {
			trace(o + " " + m);
		}else{
			if(o && m)		
				trace(o.toString() + " " + m);
			else
				trace("Out(): Error, null object reference.");
		}
	}

}
