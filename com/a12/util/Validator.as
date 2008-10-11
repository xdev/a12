package com.a12.util
{

	public class Validator
	{
			
		public function Validator()
		{
	
		}
	
		public function validateObject(formData:Array):Array
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
			
			return errorData;	
		}
	
		public function validateField(obj:Object):Object
		{			
			var mode = obj.mode;
				
			if(mode == 'empty'){
				return vEmpty(obj);
			}
	
			if(mode == 'email'){
				return vEmail(obj);		
			}
			
			if(mode == 'numeric'){
				return vNumber(obj);		
			}
			
			return vEmpty(obj);
	
		}
		
		private function vNumber(obj:Object):Object
		{
			
			//check boundary range? 
			var value = obj.value;
			var tObj = {};
			
			if(!isNaN(value)){
				tObj.valid = true;
			}else{
				tObj.valid = false;
				tObj.message = 'not a number';
			}
			
			return tObj;
			
		}
	
		private function vEmpty(obj:Object):Object
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
	
		private function vEmail(obj:Object):Object
		{
			var value = obj.value;
			var tObj = {};
			
			var pattern:RegExp = /([0-9a-zA-Z]+[-._+&])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}/;
			if(pattern.test(value)){
				tObj.valid = true;
			}else{
				tObj.valid = false;
				tObj.message = 'invalid email';
			}
							
			return tObj;
	
		}
	
	}

}