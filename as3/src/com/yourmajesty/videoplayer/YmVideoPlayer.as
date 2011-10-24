package com.yourmajesty.videoplayer {
	import flash.text.TextField;
	import flash.external.ExternalInterface;
	import com.yourmajesty.videoplayer.views.VideoPlayer;
	import flash.events.Event;
	import flash.display.LoaderInfo;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.Sprite;
	import flash.system.Security;

	/**
	 * @author kristofer
	 */
	 
	public class YmVideoPlayer extends Sprite {
		
		
		private static var instance 	:YmVideoPlayer = null;
		
		private var paramObj			:Object;
		private var debugMode			:Boolean;
		private var videoPlayer			:VideoPlayer;
		
		private static function setInstance(inst : YmVideoPlayer) : Boolean {
			
			if(instance == null) {
				instance = inst;
				return true;
			}
			
			return false;
		}
		
		public static function getInstance() : YmVideoPlayer {
			return instance;
		}
		
		public function YmVideoPlayer() {
			
			if (setInstance(this)) {
				
				// Set scale
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				stage.addEventListener(Event.RESIZE, stageResize);
				
				flash.system.Security.allowDomain("*");
				
				var isAvailable:Boolean = ExternalInterface.available;
           		var availTxt:TextField = new TextField();
           		availTxt.text = isAvailable.toString();
           		addChild(availTxt);
				
				// Catch Flashvars
				paramObj = LoaderInfo(this.root.loaderInfo).parameters;
				
				// Catch Debugmode
				debugMode = false;
				if(paramObj["debug"] == "true"){
					debugMode = true;
				}
				
				// Init Videoplayer
				videoPlayer = new VideoPlayer();
				videoPlayer.init(paramObj["initWidth"],paramObj["initHeight"]);
				
				// Autoplay
				var autoplay:Boolean = false;
				if(paramObj["autoplay"] == "true"){
					autoplay = true;
				}
				
				// Go go gadget VideoPlayer
				videoPlayer.smooth = true;
				addChild(videoPlayer);
				
				// Add event listeners
				ExternalInterface.addCallback("play", playVideo); 
				
				doResize();
				
				if (debugMode) {
					ExternalInterface.call( "console.log" , "Flash Video "+ paramObj["playerId"] +" is initiated");
				}
				
				ExternalInterface.call("ym.utils.videoPlayerReady", paramObj["playerId"]);
				
			}
			
		}
		
		private function playVideo():void
		{
			ExternalInterface.call( "console.log" , "I should play");
			videoPlayer.play();
		}
		
		private function stageResize(e:Event):void
		{
			doResize();
		}
		
		private function doResize():void
		{
			//
			//videoUI.doResize(w,h);
			
		}
		
	}
}
