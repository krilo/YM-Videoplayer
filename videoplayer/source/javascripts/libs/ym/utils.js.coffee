@module "ym", ->
 @module "utils", ->
			
		@objectSize = (obj) ->
			size = 0
			for key of obj
				size++  if obj.hasOwnProperty(key)
			size

		# Helper functions
		@getFlashVersion = ->
  			try
  			  try
  			    axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash.6")
  			    try
  			      axo.AllowScriptAccess = "always"
  			    catch e
  			      return "6,0,0"
  			  return new ActiveXObject("ShockwaveFlash.ShockwaveFlash").GetVariable("$version").replace(/\D+/g, ",").match(/^,?(.+			),?$/)[1]
  			catch e
  			  try
  			    return (navigator.plugins["Shockwave Flash 2.0"] or navigator.plugins["Shockwave Flash"]).description.replace(			/\D+/g, ",").match(/^,?(.+),?$/)[1]  if navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin
  			return false
    
    @getFlashMovie = (movieName) ->
      isIE = navigator.appName.indexOf("Microsoft") != -1
      (if (isIE) then window[movieName] else document[movieName])
    
    @removeElement = (elementToRemove) ->
      elementToRemove.parentNode.removeChild elementToRemove
      false

    @addElement = (container, elementToAdd) ->
      container.insertBefore elementToAdd, container.firstChild
    
    @addVideoPlayer = (videoPlayer) ->
      window.videoPlayers = new Array() if window.videoPlayers == undefined
      window.videoPlayers.push(videoPlayer);

    @getVideoPlayer = (playerId) ->
      i = 0
      while i < window.videoPlayers.length
        console.log window.videoPlayers[i].playerId
        i++
    
    @videoPlayerReady = (playerId) ->
      i = 0
      while i < window.videoPlayers.length
        video = window.videoPlayers[i] if(window.videoPlayers[i].playerId == playerId)
        i++
      
      video.flashReady();