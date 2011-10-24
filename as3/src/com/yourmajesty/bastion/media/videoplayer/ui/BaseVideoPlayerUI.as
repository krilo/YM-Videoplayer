package com.yourmajesty.bastion.media.videoplayer.ui {
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.yourmajesty.bastion.debug.Debug;
	import com.yourmajesty.bastion.media.videoplayer.app.VideoPlayerApp;
	import com.yourmajesty.bastion.media.videoplayer.events.VideoPlayerEvent;
	import com.yourmajesty.bastion.media.videoplayer.models.ScrubberOrientation;

	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * @author Kasper
	 * an attempt to an abstracter video player ui and videoplayer
	 * */
	public class BaseVideoPlayerUI extends MovieClip {

		public var app:VideoPlayerApp;

		protected var _container:MovieClip;
		protected var _timeline:MovieClip;
		protected var _playpause:MovieClip;
		protected var _audiotoggle:MovieClip;
		protected var _fullscreenToggle:MovieClip;

		protected var _scrubber:MovieClip;

		protected var _isConnected:Boolean = false; 
		protected var _autoPlay:Boolean = false;
		protected var _isPlaying:Boolean = false;
		protected var _wasPlaying:Boolean = false;
		protected var _isEnd:Boolean = false;

		protected var _lastProgress:Number = 0;

		protected var PROG_START:int = 0;
		protected var PROG_WIDTH:int = 0;

		public var replay:Boolean = false;
		public var scrubberOrientation:String = "CENTER";
		public var isScrubbing:Boolean;

		public var updateScrubber:Boolean = true;

		// TODO:replace with real static vars - zzzz

		public function BaseVideoPlayerUI() {

		}

		public function init(width:int = 0, height:int = 0, rtmpConnection:String = null):void {
			// set app
			app = new VideoPlayerApp();

			// set width & height
			var _width:int;
			var _height:int;

			if (width > 0) {
				_width = width;
			} else {
				_width = _container.width;
			}

			if (height > 0) {
				_height = height;
			} else {
				_height = _container.height;
			}

			app.addEventListener(VideoPlayerEvent.CONNECTED, onConnected, false, 0, true); // on app ready
			app.init(_width, _height, rtmpConnection);

			if (_scrubber != null) {
				_scrubber.x = PROG_START;
			}

			this.addChild(app);
		}

		private function onConnected(event:VideoPlayerEvent):void {
			_isConnected = true;
			this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.CONNECTED, false, false));
		}

		public function load(videoURL:String = null, autoPlay:Boolean = false, ... args):void {
			if (!_isConnected) {
				throw new Error("BaseVideoPlayerUI not (yet) connected!");
			}

			if (!videoURL) {
				throw new Error("BaseVideoPlayerUI url is not supposed to be null");
			}

			if (_isConnected && videoURL != null) {
				_lastProgress = 0;
				_isEnd = false;
				app.load(videoURL, autoPlay, args[0]);
				_autoPlay = autoPlay;
			}


			// if autoplay
			if (_autoPlay) {
				if (_playpause) {
					_playpause._pause.visible = true;
					_playpause._play.visible = false;
				}

				this.addEventListener(Event.ENTER_FRAME, onPlayback, false, 0, true);
				_isPlaying = true;
			} else {
				if (_playpause) {
					_playpause._pause.visible = false;
					_playpause._play.visible = true;
				}

				_isPlaying = false;
			}
		}

		public function resume():void {
			if (!_isPlaying) {
				if (!_isEnd) {
					app.resume();
				} else {
					app.seek(0);
					app.resume();
				}
				_isPlaying = true;
				this.addEventListener(Event.ENTER_FRAME, onPlayback, false, 0, true);
			}
		}

		public function pause():void {
			if (_isPlaying) {
				if (_isEnd) {
					app.seek(0);
				}
				app.pause();
				_isPlaying = false;

				this.removeEventListener(Event.ENTER_FRAME, onPlayback);
			}
		}

		public function mute():void {
			app.volume = 0;
		}

		public function unmute():void {
			app.volume = 1;
		}

		protected function onPlayback(event:Event):void {

			if (_timeline) {
				// update progress bar
				if (_timeline.progress) {
					TweenLite.to(_timeline.progress, 0.99, {width: Math.round(app.progress * PROG_WIDTH), onUpdate: function():void {
								if (_scrubber != null) {
									_scrubber.x = _timeline.progress.width;
								}
							}, ease: Expo.easeOut});
				}

				// update scrubber
				if (_scrubber != null && _timeline.progress == null) {
					//TweenLite.to(_scrubber, 0.99, {
					//x:Math.floor(_app.progress * PROG_WIDTH)
					//});
					if (updateScrubber) {
						if (scrubberOrientation == ScrubberOrientation.CENTER) {
							_scrubber.x = PROG_START + Math.round(app.progress * PROG_WIDTH);
						} else {
							_scrubber.x = PROG_START + Math.round(app.progress * (PROG_WIDTH - _scrubber.bg.width));
						}
					}

				}
			}

			// look for end
			if (app.progress > 0.99 && _lastProgress == app.progress && !_isEnd) {
				dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.END, false));
				_isEnd = true;

				
				// if replay enabled
				if (replay) {
					pause();
					resume();
				} else {
					pause();
					app.seek(app.progress);
				}

				_lastProgress = -1;
				
				onEnd();
			} else {
				_isEnd = false;
				_lastProgress = app.progress;
			}

			this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAYBACK));
		}

		protected function onEnd():void {

		}

		public function togglePlayPause(event:MouseEvent = null):void {
			if (_playpause._play.visible) { // not the best way of evaluating?
				resume();

				//Debug.log(this, "togglePlayPause(resume)", true);

				_playpause._pause.visible = true;
				_playpause._play.visible = false;
			} else if (!_playpause._play.visible) { // not the best way of evaluating?
				pause();

				//Debug.log(this, "togglePlayPause(pause)", true);

				_playpause._pause.visible = false;
				_playpause._play.visible = true;
			}
		}

		public function toggleAudio(event:MouseEvent = null):void {
			if (_audiotoggle._on.visible) {
				mute();

				_audiotoggle._off.visible = true;
				_audiotoggle._on.visible = false;
			} else if (!_audiotoggle._on.visible) {

				unmute();

				_audiotoggle._off.visible = false;
				_audiotoggle._on.visible = true;
			}
		}

		protected function toggleFullScreen(event:MouseEvent):void {
			if (_fullscreenToggle._on.visible) {
				stage.displayState = StageDisplayState.NORMAL;

				_fullscreenToggle._off.visible = true;
				_fullscreenToggle._on.visible = false;
			} else if (!_fullscreenToggle._on.visible) {
				stage.displayState = StageDisplayState.FULL_SCREEN;

				_fullscreenToggle._off.visible = false;
				_fullscreenToggle._on.visible = true;
			}
		}

		protected function onTimelineDown(event:MouseEvent):void {


		}

		public function onSkipStart():void {
			onScrubberDown(null);
		}

		public function onSkipUpdate():void {
			if (isScrubbing) {
				onScrubberDrag(null);
			}
		}

		public function onSkipComplete():void {
			if (isScrubbing) {
				onScrubberRelease(null);
			}
		}


		protected function onScrubberDown(event:MouseEvent):void {
			if (_timeline.progress != null) {
				TweenLite.killTweensOf(_timeline.progress);
			}

			//pause();
			isScrubbing = true;

			if (event != null) {
				if (scrubberOrientation == ScrubberOrientation.CENTER) {
					_scrubber.startDrag(false, new Rectangle(PROG_START, 0, PROG_WIDTH, 0));
				} else {
					_scrubber.startDrag(false, new Rectangle(PROG_START, 0, (PROG_WIDTH - _scrubber.bg.width), 0));
				}
			}

			_scrubber.removeEventListener(MouseEvent.MOUSE_DOWN, onScrubberDown);
			_scrubber.addEventListener(MouseEvent.MOUSE_UP, onScrubberRelease, false, 0, true);

			app.smooth = false;

			if (stage != null && event != null) {
				stage.addEventListener(MouseEvent.MOUSE_UP, onScrubberRelease, false, 0, true);
			}

			this.addEventListener(Event.ENTER_FRAME, onScrubberDrag, false, 0, true);

			if (_playpause != null && _isPlaying) {
				togglePlayPause(null);
				_wasPlaying = true;
			} else {
				_wasPlaying = false;
			}
		}

		protected function onScrubberDrag(event:Event):void {
			if (scrubberOrientation == ScrubberOrientation.CENTER) {
				app.seek((Math.round(_scrubber.x - PROG_START) / PROG_WIDTH));
			} else {
				app.seek((Math.round(_scrubber.x - PROG_START) / (PROG_WIDTH - _scrubber.bg.width)));
			}

			if (_timeline.progress != null) {
				_timeline.progress.width = _scrubber.x;
			}



			//Debug.log(this, "onScrubberDrag("+[(Math.round(_scrubber.x) / (PROG_WIDTH - _scrubber.bg.width))]+")");
		}

		protected function onScrubberRelease(event:MouseEvent):void {
			if (event != null) {
				_scrubber.stopDrag();
			}

			isScrubbing = false;

			if (scrubberOrientation == ScrubberOrientation.CENTER) {
				app.seek((Math.round(_scrubber.x - PROG_START) / PROG_WIDTH));
			} else {
				app.seek((Math.round(_scrubber.x - PROG_START) / (PROG_WIDTH - _scrubber.bg.width)));
			}

			app.smooth = true;

			_scrubber.addEventListener(MouseEvent.MOUSE_DOWN, onScrubberDown, false, 0, true);
			_scrubber.removeEventListener(MouseEvent.MOUSE_UP, onScrubberRelease);
			this.removeEventListener(Event.ENTER_FRAME, onScrubberDrag);

			if (stage) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, onScrubberRelease);
			}

			if (_playpause && !_isPlaying && _wasPlaying) {
				togglePlayPause(null);

					//Debug.log(this, "onScrubberRelease("+[event]+")");
			}

			//Debug.log(this, "onScrubberDrag("+[(Math.round(_scrubber.x) / (PROG_WIDTH - _scrubber.bg.width))]+")");
			//resume();
		}

		public function destroy():void {
			this.removeEventListener(Event.ENTER_FRAME, onPlayback);
			_isPlaying = false;
			if (app != null) {
				app.pause();
				app.destroy();

				this.removeChild(app);
				app = null;
			}
		}

		public function set container($container:MovieClip):void {
			_container = $container;
		}

		public function set timeline($timeline:MovieClip):void {
			_timeline = $timeline;

			// first try to set width by bg
			if (_timeline.bg != null) {
				if (PROG_WIDTH == 0) {
					PROG_WIDTH = _timeline.bg.width;
					PROG_START = _timeline.bg.x;
				}

				_timeline.bg.addEventListener(MouseEvent.MOUSE_DOWN, onTimelineDown, false, 0, true);
					// else try it by progress bar if any
			} else if (_timeline.progress != null) {
				if (PROG_WIDTH == 0) {
					PROG_WIDTH = _timeline.progress.width;
					PROG_START = _timeline.progress.x;
				}

				_timeline.progress.width = 0;
			}

			// setup scrubber
			if (_timeline.scrubber) {
				_scrubber = _timeline.scrubber;

				_scrubber.addEventListener(MouseEvent.MOUSE_DOWN, onScrubberDown, false, 0, true);
				_scrubber.buttonMode = true;
			}
		}


		public function set playpause($playpause:MovieClip):void {
			_playpause = $playpause;

			if (!_playpause._play) {
				throw new Error("the playpause movieclip needs a \"_play\" child movieclip as an instance");
			}

			if (!_playpause._pause) {
				throw new Error("the playpause movieclip needs a \"_pause\" child movieclip as an instance");
			}

			_playpause.addEventListener(MouseEvent.MOUSE_DOWN, togglePlayPause, false, 0, true);
			_playpause.buttonMode = true;
		}

		public function set audiotoggle($audiotoggle:MovieClip):void {
			_audiotoggle = $audiotoggle;

			if (!_audiotoggle._on) {
				throw new Error("the audiotoggle movieclip needs a \"_on\" child movieclip as an instance");
			}

			if (!_audiotoggle._off) {
				throw new Error("the audiotoggle movieclip needs a \"_off\" child movieclip as an instance");
			}

			_audiotoggle.buttonMode = true;
			_audiotoggle.addEventListener(MouseEvent.MOUSE_DOWN, toggleAudio, false, 0, true);

			_audiotoggle._off.visible = true;
			_audiotoggle._on.visible = false;
		}

		public function set fullscreentoggle($fullscreentoggle:MovieClip):void {
			_fullscreenToggle = $fullscreentoggle;

			if (!_fullscreenToggle._on) {
				throw new Error("the audiotoggle movieclip needs a \"_on\" child movieclip as an instance");
			}

			if (!_fullscreenToggle._off) {
				throw new Error("the audiotoggle movieclip needs a \"_off\" child movieclip as an instance");
			}

			_fullscreenToggle.buttonMode = true;
			_fullscreenToggle.addEventListener(MouseEvent.MOUSE_DOWN, toggleFullScreen, false, 0, true);

			_fullscreenToggle._off.visible = true;
			_fullscreenToggle._on.visible = false;
		}
		
	
		
		public function set smooth(value:Boolean):void {
			if (app != null) {
				app.smooth = value;
			}
		}

		public function get smooth():Boolean {
			return app.smooth;
		}

	}
}
