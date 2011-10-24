package com.yourmajesty.bastion.media.videoplayer.events {
	import flash.events.Event;

	/**
	 * @author Kasper
	 */
	public class VideoPlayerEvent extends Event {
		
		public static const CONNECTED			:String = "connected";
		public static const LOAD_PROGRESS 		:String = "LOAD_PROGRESS";
		public static const LOAD_COMPLETE 		:String = "LOAD_COMPLETE";
		public static const END 				:String = "END";
		public static const STREAM_BUFFER_FULL 	:String = "STREAM_BUFFER_FULL";
		public static const STREAM_BUFFERING 	:String = "STREAM_BUFFERING";
		public static const PLAYBACK 			:String = "PLAYBACK";

		public var progress				:Number;

		public function VideoPlayerEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false, progress:Number = 0) {
			super(type, bubbles, cancelable);
			
			this.progress = progress;
		}
	}
}
