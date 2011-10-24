package com.yourmajesty.bastion.media.videoplayer.events {
	import flash.events.Event;

	public class StreamClientEvent extends Event
	{
		public static const ON_METADATA			:String = "on.metadata";
		
		public function StreamClientEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}