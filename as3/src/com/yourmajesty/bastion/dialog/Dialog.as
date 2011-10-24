package com.yourmajesty.bastion.dialog {
	
	import com.unsafemethods.view.View;
	import com.yourmajesty.bastion.debug.Debug;

	/**
	 * @author Kasper
	 */
	public class Dialog extends View {
		
		protected var props				:Object;
		protected var isPrepared		:Boolean;
		protected var overrideWidth		:int = -1;
		protected var overrideHeight	:int = -1;
		
		public function Dialog(props:Object = null) {
			
			this.props = props;
			
			super();
		}
		
		override public function prepare():void
		{
			this.visible = false;
			
			if(!isPrepared){
			
				if(props){
					for (var key:String in props){
	   					//trace("-- " + key + ": " + obj[key]); // object[key] is value
	   					this[key] = props[key];
	   				}
	   			}
	   			
	   			Debug.log(this, "prepare("+[]+")", true);
	   			
	   			this.populate();
	   			
				isPrepared = true;
			}
	   		
		}
		
		
		public function populate():void
		{
			
		}
		
		public function get overriddenWidth():int
		{
			return overrideWidth;
		}
		
		public function get overriddenHeight():int
		{
			return overrideHeight;
		}
		
		override protected function doOpen():void
		{
			super.doOpen();
		}
		
		override protected function onOpened():void
		{
			super.onOpened();
		}
		
		override protected function doClose():void
		{
			super.doClose();
		}
		
		override protected function onClosed():void
		{
			super.onClosed();
			
			this.dispatchEvent(new DialogEvent(DialogEvent.CLOSE));
			this.visible = false;
		}
	}
}
