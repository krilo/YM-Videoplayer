package com.yourmajesty.bastion.media.videoplayer.ui {
	import flash.events.Event;

	/**
	 * @author Kasper
	 */
	public class MultiVideoUI extends BaseVideoPlayerUI {
	
		protected var videoArray				:Array;
		protected var currentVideoIndex			:int;
		protected var currentPlayingVideoIndex	:int = 0;
		
		public function MultiVideoUI() {
			super();
		}

		
		override public function init(width : int = 0, height : int = 0, rtmpConnection : String = null) : void {
			super.init(width, height, rtmpConnection);
			
			currentVideoIndex = 0;
			
			// wtf! 
		}

		public function addVideo(id:String, url:String, strId:String):void {
			
			if(videoArray==null) {
				videoArray = new Array();
			}
			
			videoArray.push({ id:id, url: url, progress:0, strId:strId });
		}
		
		public function loadVideoByIndex(index:int = 0, autoPlay:Boolean = false):void {
			currentVideoIndex = index;
			
			this.load(videoArray[index].url, autoPlay);
		}

		
		override public function load(videoURL : String = null, autoPlay : Boolean = false, ...args) : void {
			super.load(videoURL, autoPlay, args);
			
			this.app.seek(0);
		}

		
		
		
		override protected function onEnd() : void {
			super.onEnd();
			
			videoArray[currentVideoIndex].progress = 1;
		//	this.prepareNextVideo(); --zz
		
		}

		
		override protected function onPlayback(event : Event) : void {
			super.onPlayback(event);
			
			 videoArray[currentVideoIndex].progress = app.progress;
		}
		
		public function prepareNextVideo(playAfterPreparation:Boolean = false) : void {
			
			if(currentVideoIndex + 1 < videoArray.length){
				this.loadVideoByIndex(currentVideoIndex+1, playAfterPreparation);
			} else {
				if(this.replay){
					this.loadVideoByIndex(0, playAfterPreparation);
				}
			}
		
		}
		
		public function getVideoProgressOf(videoIndex:int):Number {
			return videoArray[videoIndex].progress;
		}
		
		public function reset():void
		{	
			for(var i:int = 0; i < videoArray.length; i++)
			{
				videoArray[i].progress = 0;
			}
			
			currentVideoIndex = 0;
			currentPlayingVideoIndex = 0;
			
			this.loadVideoByIndex(0, true);
	
		}
		
	}
}
