class com.a12.modules.form.Validator
{
			
	public function Validator()
	{
	
	}
	
	public function validateObject(formData)
	{
	
		//iterate through the obj and get field objects , values and validation states
		var errorData = [];
		
		for(var i=0; i<formData.length; i++){
			
			var obj = formData[i];
			
			var tV = validateField(obj);
						
			if(tV.valid == true){
			
			}else{
				//as we find stuff add it to the errorObj
				obj.message = tV.message;
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
	
	public function validateField(obj)
	{			
		trace('in here');
		var mode = obj.mode;
				
		if(mode == 'empty'){
			return vEmpty(obj);
		}
	
		if(mode == 'email'){
			return vEmail(obj);		
		}	
	
	}
	
	private function vEmpty(obj)
	{
		var value = obj.value;
		var tObj = {};
				
		if(value != '' && value != undefined && value != null){
			tObj.valid = true;			
		}else{
			tObj.valid = false;
			tObj.message = 'value not set';
		}
		
		return tObj;
	}
	
	private function vEmail(obj)
	{
	
		var value = obj.value;
		var tObj = {};
		
		if (value.length>=7) {
			if (value.indexOf("@")>0) {
				if ((value.indexOf("@")+2)<value.lastIndexOf(".")) {
					if (value.lastIndexOf(".")<(value.length-2)) {
						tObj.valid = true;
					}else{
						tObj.message = 'invalid domain';
					}
				}
			}
		}
		
		if(tObj.valid == undefined){
			tObj.valid = false;
			if(tObj.message == undefined){
				tObj.message = 'invalid email';
			}
		}
		
		return tObj;
	
	}
	
}