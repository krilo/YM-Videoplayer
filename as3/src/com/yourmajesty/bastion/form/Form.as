package com.yourmajesty.bastion.form {
	import com.yourmajesty.castellum.Castellum;
	import com.yourmajesty.bastion.debug.Debug;
	import com.yourmajesty.bastion.display.Asset;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;

	/**
	 * @author Kasper
	 */
	public class Form extends Asset {
		
		public var xml:XML;
		private var bInit:Boolean = false;
		
		private const ROW_HEIGHT:int = 40;
		private var fields:Array;
		private var campaignXML:XML;
		
		public var token:String;
		public var buttonClass:Class;
		
		public function Form() {
		
		}

		override public function init() : void {
			if(!bInit){
				super.init();
				bInit = true;
				
				fields = new Array();
				
				populateForm();
				
				Castellum.getStage().addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			}
		}

		private function onKeyDown(event : KeyboardEvent) : void {
			if(event.charCode == 13){
				this.onSubmit(null);
			}
		}

		private function populateForm() : void {
			
			var tabIndex:int = 0;
			
			for (var i : int = 0; i < xml.row.length(); i++) {
				
				var row:XML = XML(xml.row[i]);
				var xOffset:Number = 0;
				
				for each (var c : XML in row.children()) {
					var obj:FormObject;
					
					if(c.name() == "textInput"){
						obj = new FormTextInput();
						obj.tabIndex = tabIndex;
						tabIndex++;
					} else if(c.name() == "emailInput"){
						obj = new FormEmailInput();
					} else if(c.name() == "checkbox"){
						obj = new FormCheckbox();
					} else if(c.name() == "submitButton"){
						obj = new FormSubmitButton(buttonClass);
						obj.addEventListener(MouseEvent.MOUSE_DOWN, onSubmit, false, 0, true);
					} else if(c.name() == "cancelButton"){
						obj = new FormCancelButton(buttonClass);
						obj.addEventListener(MouseEvent.MOUSE_DOWN, onCancel, false, 0, true);
					}
					 
					
					Debug.log(this, "populateForm(" + [row.@marginBottom] + ")", true);
					
					
					obj.xml = c;
					addFormObject(obj, xOffset, (i * ROW_HEIGHT) + int(row.@marginBottom));
					
					
					
					xOffset += int(c.@width) + int(c.@marginRight);
					
					
				}			
			}
		}

		private function onCancel(event : MouseEvent) : void {
			//dispatchEvent(Form)
			dispatchEvent(new FormEvent(FormEvent.CANCEL));
		}

		private function onSubmit(event : MouseEvent) : void {
			Validator.validate(fields, success);
			
			Castellum.getStage().removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		public function success():void {
			
			var variables:URLVariables = new URLVariables();
			
			var i : int = 0;
			
			
			for ( i= 0;i < fields.length; i++) {
				if(fields[i] is FormTextInput){
					variables[fields[i].id] = fields[i].value;
				}
			}
			
			var request:URLRequest = new URLRequest( xml.@postURL );
		    request.method = URLRequestMethod.POST;
			request.data = variables;
		
			var loadContext:LoaderContext = new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain);
		
			var loader:URLLoader = new URLLoader();
			loader.addEventListener( Event.COMPLETE, onPostComplete, false, 0, true);
			loader.addEventListener( IOErrorEvent.IO_ERROR, onPostError,  false, 0, true );
	      	loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onPostError,  false, 0, true );
			loader.load( request );
				
				
			
		}

		private function onPostComplete(event : Event) : void {
			
			trace(XML(URLLoader(event.currentTarget).data));
			
			if(XML(URLLoader(event.currentTarget).data) == "ok"){
				dispatchEvent(new FormEvent(FormEvent.COMPLETE));	
			} else {
				dispatchEvent(new FormEvent(FormEvent.ERROR));
			}
		}
		
		private function onPostError(event : Event) : void {
			dispatchEvent(new FormEvent(FormEvent.ERROR));			
		}

		public function addFormObject(obj : FormObject, xPos : Number, yPos : Number) : void {
			fields.push(obj);
			this.addChild(obj);
			
			Debug.log(this, "addFormObject("+[obj, xPos, yPos]+")", true);
			
			obj.x = xPos;
			obj.y = yPos;
		}

		override public function destroy() : void {
			super.destroy();
			
			Castellum.getStage().removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
	}
}

