package com.unsafemethods.io {

	/**
	 * @author jonathanpetersson
	 */
	public class Progress {
		
		private var bytesTotal	:int = 0;
		private var bytesLoaded	:int = 0;
		
		public function getBytesTotal():int { 
			return bytesTotal;
		}
		
		public function setBytesTotal(b:int):void {
			bytesTotal = b;
		}
		
		public function getBytesLoaded():int { 
			return bytesLoaded;	
		}
		
		public function setBytesLoaded(b:int):void { 
			bytesLoaded = b;
		}
		
		public function toFraction():Number { 
			return bytesLoaded / bytesTotal;	
		}
		
	}
}
