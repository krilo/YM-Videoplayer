package com.yourmajesty.bastion.form {

	/**
	 * @author Kasper
	 */
	public class Validator {
		public static function validate(validateArray:Array, onValidate:Function):void {
			
			// validate!
			var invalidateArray:Array = new Array();
			
			var i:Number;
			var pw:String;
			
			for (i=0; i<validateArray.length; i++){
				
				var formObject:FormObject = FormObject(validateArray[i]);
				
				if(!formObject.optional){
				
					if(formObject is FormEmailInput){
						if(!validateEmail(formObject.value)){				
							invalidateArray.push(formObject);
						} 
					} else if(formObject is FormCheckbox){
						if(formObject.value == false && formObject.optional == false){
							invalidateArray.push(formObject);
						}
					
					} else if(formObject is FormTextInput){
						if(formObject.value == formObject.defaultInput || formObject.value.length < 2){
							if(!formObject.optional){
								invalidateArray.push(formObject);
							}
						} else {
							
						}
					}

				}			
						
			}
			
			for (i=0; i<invalidateArray.length; i++){
				FormObject(invalidateArray[i]).invalidate(i);
			}
			
			if(invalidateArray.length == 0){
				onValidate();
			}
		}
		
		public static function validateEmail(email:String):Boolean {
		    var emailExpression:RegExp = /^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+.)+[A-Z]{2,4}$/i; // this is the pattern here 
		    return emailExpression.test(email);
		}
	}
}
