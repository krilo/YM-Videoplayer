package com.yourmajesty.bastion.form {
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Sine;
	import com.tommyhilfiger.styles.TextStyles;
	import com.yourmajesty.bastion.utils.FontStyles;
	import com.yourmajesty.castellum.data.Data;
	import com.yourmajesty.castellum.display.ui.text.CTextField;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;

	/**
	 * @author Kasper
	 */
	public class FormCheckbox extends FormObject {
		protected var background	:Sprite = new Sprite();
		protected var checked		:Boolean = true;
		
		public var checkMark		:Sprite;
		
		public function FormCheckbox() {
			super();
		}
		
		override public function init() : void {
			// make this 'fit' for locale
			super.init();
			
			this.addChild(background);
			
			this.graphics.beginFill(0x32728f);
			this.graphics.drawRect(0, 0, 1, this.fieldHeight);
			this.graphics.endFill();
			
			this.graphics.beginFill(0x32728f);
			this.graphics.drawRect(1, 0, this.fieldWidth, 1);
			this.graphics.endFill();
			
			background.graphics.beginFill(0xFFFFFF);
			background.graphics.drawRect(1, 1, this.fieldWidth, this.fieldHeight);
			background.graphics.endFill();
				
			label = new CTextField(TextStyles.formLabel);
			label.htmlText = Data.getString("form", this.stringId);
			label.setTextFormat(FontStyles.instance.getStyleAsFormat("formLabel"));
			label.antiAliasType = AntiAliasType.ADVANCED;
			
			label.x = this.fieldWidth + 8;
			label.y = -2;
			
			this.addChild(label);
			
			this.background.buttonMode = true;
			this.background.addEventListener(MouseEvent.MOUSE_DOWN, onCheckboxDown, false, 0, true);
			
			checkMark = new Sprite();
			checkMark.graphics.beginFill(0x126891,1);
			checkMark.graphics.drawRect(0, 1, 1, 3);
			checkMark.graphics.drawRect(1, 2, 1, 3);
			checkMark.graphics.drawRect(2, 3, 1, 3);
			checkMark.graphics.drawRect(3, 2, 1, 3);
			checkMark.graphics.drawRect(4, 1, 1, 3);
			checkMark.graphics.drawRect(5, 0, 1, 3);
			checkMark.graphics.endFill();
			
			checkMark.x = 4;
			checkMark.y = 4;
			
			this.background.addChild(checkMark);
		}

		private function onCheckboxDown(event : MouseEvent) : void {
			if(!checked){ checked = true; } else { checked = false; }
			
			checkMark.visible = checked;
		}

		override public function get value() : * {
			return checked;
		}

		override public function invalidate(index : int) : void {
			super.invalidate(index);
			
			TweenMax.to(background, 0.9, {
				delay:index * 0.3,
				colorTransform:{tint:0xff0000, tintAmount:0.25},
				ease:Expo.easeOut,
				onComplete:function():void {
					
					TweenMax.to(background, 3, {
						delay:2,
						colorTransform:{tint:0xff0000, tintAmount:0},
						ease:Sine.easeOut,
						onComplete:function():void{
							
						}
					});
				}
			});
		}
	}
}
