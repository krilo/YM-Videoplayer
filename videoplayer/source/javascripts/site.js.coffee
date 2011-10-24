#= require "plugins"
#= require "libs/jquery-1.6.2.js"
#= require "libs/ym/core"

#= require "libs/ym/utils"
#= require "libs/ym/videoplayer/videoPlayer"

$ ->
  	
  @supportsTouch = "createTouch" of document
	videos = document.body.getElementsByTagName("video")

	playBtnToggle = true

	i = 0
	while i < videos.length
		
		###
		
			Possible values for the options object
			---------------------------------------

			basepath:		The base for flash videoplayer .swf file

		###

		player = new ym.VideoPlayer(videos[i], ["basepath": "./flash/"])
		
		# Set Play Button
		playBtn = document.getElementById("playBtn")
		playBtn[(if @supportsTouch then "ontouchend" else "onmouseup")] = (event) ->
				
				if player.getState() == "paused" && playBtnToggle == true			
					player.playVideo()
				else
					player.pauseVideo()
				
				return false

		# Set Pause Button
		pauseBtn = document.getElementById("pauseBtn")
		pauseBtn[(if @supportsTouch then "ontouchend" else "onmouseup")] = (event) ->
			
			player.pauseVideo()
			return false

		# Set Mute Button
		pauseBtn = document.getElementById("muteBtn")
		pauseBtn[(if @supportsTouch then "ontouchend" else "onmouseup")] = (event) ->
			
			player.setVolume(0)
			return false
		
		# Set Unmute Button
		pauseBtn = document.getElementById("unmuteBtn")
		pauseBtn[(if @supportsTouch then "ontouchend" else "onmouseup")] = (event) ->
			
			player.setVolume(1)
			return false

		# Set Progress Button
		pauseBtn = document.getElementById("setProgBtn")
		pauseBtn[(if @supportsTouch then "ontouchend" else "onmouseup")] = (event) ->
			
			player.setPosition(0.5);
			return false
	
		i++

