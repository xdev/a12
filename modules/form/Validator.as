class com.a12.modules.form.Validator
{
			
	private function Validator()
	{
	
	}
	
	public static function validateObject(formData)
	{
	
		//iterate through the obj and get field objects , values and validation states
		var errorData = [];
		
		for(var i in formData){
			
			var obj = formData[i];
			
			if(_validateField(obj)){
			
			}else{
				//as we find stuff add it to the errorObj
				errorData.push(obj);
			}	
		
		
		}
				
		//return the errorObj
		if(errorData.length > 0){
			return errorData;
		}else{
			return false;
		}
	
	}
	
	public static function _validateField(obj)
	{	
	
		
		var mode = obj.mode;
		var value = obj.value;
		
		trace(mode + '--' + value + '--' + obj.name);
		
		
		if(mode == 'equal'){
			if(obj.value == obj.value2){
				return true;
			}else{
				return false;
			}		
		}
		
		if(mode == 'empty'){
			if(value != ''){
				if(value != 'please enter your ' + obj.name){
					return true;
				}
			}else{
				return false;
			}
		}
	
		if(mode == 'email'){
			if (value.length>=7) {
				if (value.indexOf("@")>0) {
					if ((value.indexOf("@")+2)<value.lastIndexOf(".")) {
						if (value.lastIndexOf(".")<(value.length-2)) {
							return true;
						}
					}
				}
			}
			
			return false;
		
		}
	
	
	}

}