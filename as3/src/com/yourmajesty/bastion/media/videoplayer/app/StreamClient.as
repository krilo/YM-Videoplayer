package com.yourmajesty.bastion.media.videoplayer.app {
	import com.yourmajesty.bastion.media.videoplayer.events.StreamClientEvent;

	import flash.events.EventDispatcher;

	public class StreamClient extends EventDispatcher
	{
		public var duration:Number;
		public var width:Number;
		public var height:Number;
		public var fps:Number;
		public var videoSampleAccess:String = "/";
		
		public function StreamClient()
		{
			trace("STREAMCLEINT");
		}
		
	    public function onMetaData(info:Object):void 
	    {
	    	//trace("StreamClient.onMetaData // duration = " + info.duration);
			duration = info.duration;
			width = info.width;
			height = info.height;
			fps = info.framerate;
			
			trace("StreamClient // onMetaData: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
			
			dispatchEvent(new StreamClientEvent(StreamClientEvent.ON_METADATA));		    
	    }
	
	    public function onCuePoint(info:Object):void 
	    {
	        trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
	    }
	    
	    public function onXMPData(info:Object):void {
	    	trace("onXMPData:", info);
	    }
	    
	    public function onBWDone():void {
	    	
	    }
	    
	    public function onPlayStatus(info:Object = null):void {
	    	trace("playstatus");
	    }

	}
}