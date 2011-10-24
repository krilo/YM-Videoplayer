package com.yourmajesty.bastion.scrollbar
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;
	import com.yourmajesty.castellum.Castellum;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class Scroller extends Sprite
	{
		
		private var WIDTH 				: int;
		private var HEIGHT 				: int;	
		private var barColor			: uint;
		private var handleColor			: uint;
		private var barAlpha			: Number;
		private var handleAlpha			: Number;
		private var base 				: Sprite;
		private var handle 				: Handle;
		
		public function Scroller( _width:int = 10, _height:int = 200, _barColor:uint = 0x1A1A1A, _handleColor:uint = 0xFFFFFF, _barAlpha:Number = 1, _handleAlpha:Number = 1) : void 
		{
			super( );
			
			WIDTH = _width;
			HEIGHT = _height;
			barColor = _barColor;
			handleColor = _handleColor;
			barAlpha= _barAlpha;
			handleColor =_handleColor;
		}
		
		public function init( ) : void
		{
			base = new Sprite( );
			base.buttonMode = true;
			addChild( base );	
			
			handle = new Handle( handleColor, barAlpha );
			handle.width = WIDTH;
			handle.height = HEIGHT;
			addChild( handle );	
			
			base.addEventListener( MouseEvent.CLICK, baseClickHandler );
			handle.addEventListener( MouseEvent.MOUSE_DOWN, handleMouseDownHandler );
			
		}
		
		private function scroll( y : Number, duration : Number = .3 ) : void
		{
			if ( !visible ) return;
			
			if ( y < 0 )
				y = 0;
			else if ( y > base.height - handle.height )
				y = base.height - handle.height;
			
			TweenLite.killTweensOf( handle );
			new TweenLite( handle, duration, { y: y, ease: Quint.easeInOut, onUpdate: dispatchChange } );
		}
		
		private function dispatchChange( ) : void
		{
			dispatchEvent( new Event( Event.CHANGE ) );
		}
		
		public function doResize( w:Number, h:Number ) : void
		{
			base.graphics.clear( );
			base.graphics.beginFill( barColor, barAlpha );
			base.graphics.drawRect( 0, 0, WIDTH, h - y);
			base.graphics.endFill( );
			
			dispatchChange( );
		}
		
		private function baseClickHandler( event : MouseEvent ) : void
		{
			var y : Number = base.mouseY - handle.height / 2;
			scroll( y );
		}
		
		private function handleMouseDownHandler( event : MouseEvent ) : void
		{
			Castellum.getStage().addEventListener( MouseEvent.MOUSE_UP, stageMouseUpHandler, false, 0, true );
			Castellum.getStage().addEventListener( MouseEvent.MOUSE_MOVE, stageMouseMoveHandler, false, 0, true );
			handle.startDrag( false, new Rectangle( base.x, base.y, 0, base.height - handle.height ) );
		}
		
		private function stageMouseUpHandler( event : MouseEvent ) : void
		{
			handle.stopDrag( );
			Castellum.getStage().removeEventListener( MouseEvent.MOUSE_UP, stageMouseUpHandler );
			Castellum.getStage().removeEventListener( MouseEvent.MOUSE_UP, stageMouseMoveHandler );
		}		
		
		private function stageMouseMoveHandler( event : MouseEvent ) : void
		{
			dispatchChange( );
		}
		
		public function get position( ) : Number
		{
			return handle.y / ( base.height - handle.height );
		}
		
		public function set container( container : Sprite ) : void
		{
			
			visible = container.height > base.height;
		}
	}
}