package com.yourmajesty.videoplayer.views {
	import com.yourmajesty.bastion.media.videoplayer.ui.BaseVideoPlayerUI;

	/**
	 * @author kristofer
	 */
	 
	public class VideoPlayer extends BaseVideoPlayerUI {
		
		public function VideoPlayer() {
			super();
		}
		
		public function getState():String
		{
			var state:String = "paused";
			if(this._isPlaying == true){
				state = "playing";
			}
			
			return state;
		}
		
		public function setVolume(vol:Number):void
		{
			this.app.volume = vol;
		}
		
		public function getProgress():Number
		{
			var p:Number = this.app.currentTime / this.app.duration;
			return p;
		}
		
		public function setProgress(p:Number):void
		{
			this.app.seek(p);
		}
		
	}
}
