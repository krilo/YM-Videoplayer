package com.yourmajesty.bastion.media.videoplayer.app {
	import com.yourmajesty.bastion.debug.Debug;
	import com.yourmajesty.bastion.media.videoplayer.events.StreamClientEvent;
	import com.yourmajesty.bastion.media.videoplayer.events.VideoPlayerEvent;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	/**
	 * @author Kasper
	 * attempt to create abstracted videoplayer, which should be able to roll with rtmp too
	 */
	public class VideoPlayerApp extends MovieClip {

		public var video:Video;
		private var netStream:NetStream;
		private var netConnection:NetConnection;
		private var streamClient:StreamClient = new StreamClient();
		private var soundTrans:SoundTransform = new SoundTransform(1, 0);

		private var isConnected:Boolean = false;
		private var isPlaying:Boolean = false;
		private var autoPlay:Boolean = false;
		private var halt:Boolean = false;
		private var isSeeking:Boolean = false;
		private var url:String = "";
		
		private var firstLoad:Boolean = false;

		public function VideoPlayerApp() {

		}

		public function init(width:int, height:int, rtmpConnection:String = null):void {
			isConnected = false;

			// setup video - zz
			video = new Video(width, height);

			addChild(video);

			connect(rtmpConnection);
		}

		private function connect(rtmpConnection:String = null):void {
			// set up netconnection
			netConnection = new NetConnection();
			netConnection.client = new StreamClient();
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, onNetConnectionStatus, false, 0, true);
			netConnection.connect(null);
		}

		private function onNetConnectionStatus(event:NetStatusEvent):void {
			trace("NetConnection NetStatus:" + event.info.code);

			switch (event.info.code) {
				case "NetConnection.Connect.Success":
					setNetStream();

					break;
			}
		}

		private function setNetStream():void {
			streamClient.addEventListener(StreamClientEvent.ON_METADATA, onMetaData, false, 0, true);

			netStream = new NetStream(netConnection);
			netStream.client = streamClient;
			netStream.bufferTime = 5;
			netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStreamStatus, false, 0, true);
			video.attachNetStream(netStream);

			isConnected = true;

			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.CONNECTED, false, false));
		}

		public function load(videoURL:String, autoPlay:Boolean = false, ... args):void {
			if (isConnected) {
				this.autoPlay = autoPlay;
				this.netStream.play(videoURL);
				this.url = videoURL;

				this.addEventListener(Event.ENTER_FRAME, loadProgress, false, 0, true);

				if(!firstLoad){
					this.addEventListener(Event.ENTER_FRAME, playback, false, 0, true);
					
					firstLoad = true;
				}

				if (!autoPlay) {
					isPlaying = true;
					halt = true;
						//_video.visible = false;
				} else {
					isPlaying = true;
					halt = false;
				}
			} else {
				throw new Error("VideoPlayerApp not yet initialized/connected");
			}
		}

		private function playback(event:Event):void {
			if (isSeeking) {
				//	Debug.log(this, "seekframe", false, 0x00CCFF);
			}
		}

		private function loadProgress(event:Event):void {
			var progress:Number = netStream.bytesLoaded / netStream.bytesTotal;

			if (progress < 1) {
				dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.LOAD_PROGRESS, false, false, progress));
			} else {
				Debug.log(this, "LOAD COMPLETE("+[event]+")", true, 0xFF00FF);
				dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.LOAD_COMPLETE, false, false, progress));
				this.removeEventListener(Event.ENTER_FRAME, loadProgress);
			}
		}

		private function onMetaData(event:StreamClientEvent):void {
			if (halt) {
				this.seek(0);
				this.pause();
				halt = false;
				video.visible = true;
			}
		}

		private function onNetStreamStatus(event:NetStatusEvent):void {

			//Debug.log(this, "onNetStreamStatus("+[$e.info.code]+")");

			switch (event.info.code) {
				case "NetStream.Play.StreamNotFound":
					//dispatchEvent(new StreamEvent(StreamEvent.STREAM_FAILED));
					throw new Error("Unable to locate video: " + url);
					break;

				case "NetStream.Buffer.Full":


					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.STREAM_BUFFER_FULL));
					//bBufferFull = true;
					isSeeking = false;

					break;
				case "NetStream.Buffer.Empty":
					break;
				case "NetStream.Play.Start":
					//bIsPlaying = false;
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.STREAM_BUFFERING));


					break;

				case "NetStream.Buffer.Flush":
					//dispatchEvent(new StreamEvent(StreamEvent.STREAM_BUFFER_FLUSHED));
					// Debug.log(this, "onNetStreamStatus("+[$e.info.code]+")");

					break;

				case "NetStream.Play.Stop":
					//bIsPlaying = false;
					//dispatchEvent(new StreamEvent(StreamEvent.STREAM_STOPPED));

					break;
			}
		}

		public function resume():void {
			if (netStream && !isPlaying) {
				netStream.resume();
				isPlaying = true;
			}
		}

		public function pause():void {
			if (netStream && isPlaying) {
				netStream.pause();
				isPlaying = false;
			}
		}

		public function set volume(value:Number):void {
			soundTransform = new SoundTransform(value, 0);
			netStream.soundTransform = soundTransform;
		}

		public function seek(offset:Number):void {
			if (netStream) {
				//Debug.log(this, "seek("+[$offset]+")", false, 0xFF00FF);

				this.isSeeking = true;

				netStream.seek(offset * streamClient.duration);
			}
		}

		public function destroy():void {
			netStream.pause();
			netStream.close();
			video.clear();

			this.removeChild(video);
			video.attachNetStream(null);
			video = null;
			netStream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStreamStatus);
			netConnection.removeEventListener(NetStatusEvent.NET_STATUS, onNetConnectionStatus);
			netConnection = null;
			
			streamClient.removeEventListener(StreamClientEvent.ON_METADATA, onMetaData);
			streamClient = null;

			netStream = null;
			//_netStream = new NetStream(_netConnection);
			
			this.removeEventListener(Event.ENTER_FRAME, loadProgress);
			this.removeEventListener(Event.ENTER_FRAME, playback);
		}
		
		public function toBitmap():Bitmap {
			var bm:BitmapData = new BitmapData(video.width, video.height, true, 0xFFFFFF);
			bm.draw(video);
			
			var bitmap:Bitmap = new Bitmap(bm);
			return bitmap;
		}

		public function set smooth(value:Boolean):void {
			video.smoothing = value;
		}

		public function get smooth():Boolean {
			return video.smoothing;
		}

		public function get progress():Number {
			return netStream.time / streamClient.duration;
		}

		public function get currentTime():Number {
			return netStream.time;
		}

		public function get duration():Number {
			return streamClient.duration;
		}
	}
}
