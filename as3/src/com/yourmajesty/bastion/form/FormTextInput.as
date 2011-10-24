package com.yourmajesty.bastion.form {
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Sine;
	import com.tommyhilfiger.styles.TextStyles;
	import com.yourmajesty.bastion.debug.Debug;
	import com.yourmajesty.bastion.utils.FontStyles;
	import com.yourmajesty.castellum.data.Data;
	import com.yourmajesty.castellum.display.ui.text.CTextField;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;

	/**
	 * @author Kasper
	 */
	public class FormTextInput extends FormObject {
		
		protected var background	:Sprite = new Sprite();
		
		public function FormTextInput() {
			super();
		}

		override public function init() : void {
			// make this 'fit' for locale
			super.init();
			
			this.addChild(background);
			
			input = new CTextField(TextStyles.formField);
			input.htmlText = Data.getString("form", this.stringId);
			input.setTextFormat(FontStyles.instance.getStyleAsFormat("formField"));
			input.antiAliasType = AntiAliasType.ADVANCED;
			
			input.x = 2;
			input.y = 5;
			
			this.graphics.beginFill(0x32728f);
			this.graphics.drawRect(0, 0, 1, this.fieldHeight);
			this.graphics.endFill();
			
			this.graphics.beginFill(0x32728f);
			this.graphics.drawRect(1, 0, this.fieldWidth, 1);
			this.graphics.endFill();
			
			background.graphics.beginFill(0xffffff);
			background.graphics.drawRect(1, 1, this.fieldWidth, this.fieldHeight);
			background.graphics.endFill();
			
			this.addChild(input);
			
			input.autoSize = TextFieldAutoSize.NONE;
			input.selectable = true;
			input.type = TextFieldType.INPUT;
			input.tabIndex = this.fieldTabIndex;
			input.addEventListener(FocusEvent.FOCUS_IN, onInputDown, false, 0, true);
			//input.textField.borderColor = 0xdadada;
			//input.textField.backgroundColor = 0xf0f0f0;
			input.width = this.fieldWidth - 5;
			input.height = 26;
			
			input.addEventListener(MouseEvent.MOUSE_DOWN, onInputDown, false, 0, true);
			
			
			this.defaultInput = input.text;
			
			Debug.log(this, "init("+[]+")", true, 0xFF0000);
		}

		private function onInputDown(event : Event) : void {
			input.text = "";
			
			input.removeEventListener(MouseEvent.MOUSE_DOWN, onInputDown);
			input.removeEventListener(FocusEvent.FOCUS_IN, onInputDown);
		}

		override public function get value() : * {
			return input.text;
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
