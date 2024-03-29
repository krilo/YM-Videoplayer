@module "ym", ->

  class @VideoPlayer	

    constructor: ( @element, @options ) ->

      @playerId = Math.random().toString(36).substr(2,9)
      @flashPlayer = ym.utils.getFlashVersion()

      @rendermode = "html5"
      @rendermode = "flash" if @flashPlayer != false
      if @options
        @rendermode = @options[0].rendermode if @options[0].rendermode != undefined
      
      @video = @element
      @video = "Flash not ready" if @rendermode == "flash"

      @embeddFlash() if @rendermode == "flash"
      @flashConnected = false;

      ym.utils.addVideoPlayer(@);


    embeddFlash: ->
      flashWidth = @element.width
      flashHeight = @element.height

      basePath = "./"
      if @options
        basePath = @options[0].basepath if @options[0].basepath != undefined

      container = document.getElementById(@element.parentNode.id)
      ym.utils.removeElement(@element)

      autoplay = false
      autoplay = true if @element.getAttribute("autoplay") == "autoplay"

      flashUrl = @element.getAttribute("data-flash-video")
      flashvars = "initWidth="+flashWidth+"&initHeight="+flashHeight+"&debug=true&playerId="+@playerId+"&videoUrl="+flashUrl+"&autoplay="+autoplay

      flashDiv = document.createElement("div")
      flashDiv.innerHTML = "
      <object classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000' width='"+flashWidth+"' height='"+flashHeight+"' id='"+@playerId+"' name='name_"+@playerId+"'>
          <param name='movie' value='"+basePath+"VideoPlayer.swf'>
          <param name='allowfullscreen' value='true'>
          <param name='allowscriptaccess' value='always'>
          <param name='flashvars' value='"+flashvars+"'>
          <embed id='"+@playerId+"'
            name='name_"+@playerId+"'
            src='"+basePath+"VideoPlayer.swf'
            width='"+flashWidth+"'
            height='"+flashHeight+"'
            allowscriptaccess='always'
            allowfullscreen='true'
            flashvars='"+flashvars+"'
          />
          </object>"

      ym.utils.addElement(container, flashDiv)


    flashReady: () ->
      @video = ym.utils.getFlashMovie("name_"+@playerId)
      @flashConnected = true


    setVolume: (vol) ->
      
      # HTML 5
      if @rendermode == "html5"
        @video.volume = vol
      else if @rendermode == "flash" && @flashConnected == true
        @video.setVolume(vol)

    playVideo: () ->
      _t = @

      # HTML 5
      if @rendermode == "html5"
        @video.play()
        @progressInterval = setInterval( ->
          _t.update(_t)
        , 33)
      else if @rendermode == "flash" && @flashConnected == true
        @video.play()

    pauseVideo: () ->

      # HTML 5
      if @rendermode == "html5"
        @video.pause();
        clearInterval(@progressInterval);
      else if @rendermode == "flash" && @flashConnected == true
        @video.pause()

    update: (_t) ->
    
      # HTML 5
      if _t.rendermode == "html5"
        _t.progress = _t.video.currentTime / _t.video.duration
      else if @rendermode == "flash" && @flashConnected == true
        _t.progress = @video.getProgress()

    setPosition: (p) ->
      
      # HTML 5
      if @rendermode == "html5"
        @video.currentTime = @video.duration*p
      else if @rendermode == "flash" && @flashConnected == true
        @video.setProgress(p)
    
    getPosition: (p) ->
      
      # HTML 5
      if @rendermode == "html5"
        p = @video.currentTime
      else if @rendermode == "flash" && @flashConnected == true
       p = @video.getProgress()

      return p

    getState: () ->
      
      state = "not set"
      
      # HTML 5
      if @rendermode == "html5"
      	
        if @video.paused == true
          state = "paused"
        else
          state= "playing"
      
      else if @rendermode == "flash" && @flashConnected == true
        state = @video.getState()
      
      return state
