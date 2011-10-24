package com.yourmajesty.bastion.scrollbar
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class Handle extends Sprite
	{
		
		private var background : Sprite;
		private var up : Bitmap;
		private var down : Bitmap;
		
		
		public function Handle(_color:uint, _alpha:Number ) : void 
		{
			background = new Sprite( );
			background.graphics.beginFill( _color, _alpha );
			background.graphics.drawRect( 0, 0, 10, 10 );
			background.graphics.endFill( );
			addChild( background );
			
			buttonMode = true;
			mouseChildren = false;
		}
		
		override public function set width( value : Number ) : void
		{
			background.width = value;
		}
		
		override public function set height( value : Number ) : void
		{
			background.height = value;
		}
	}
}