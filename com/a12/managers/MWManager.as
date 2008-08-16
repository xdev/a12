import com.a12.util.*;

class com.a12.managers.MWManager
{

	private	var	Main				: Object;
	private	var	_callback			: Object;
	public	var broadcaster 		: EventBroadcaster;
	private	var	debugMode			: Boolean;
	
	public function MWManager(m)
	{
		Main = m;
		debugMode = true;
	}
	
	public function setDebug(deb:Boolean)
	{
		debugMode = deb;
	}
	
	private function debug(t)
	{
		if(debugMode == true){
			trace(t);
		}
	}
	
	public function transfer(data,obj,result,args)
	{
	
		var myXML = '<Request Type="' + data.action + '">';
								
		if(data.params != undefined){
			myXML += '<Params>';
			for(var i in data.params){
				var param = data.params[i];
				myXML += '<Param Name="' + param.name + '">' + param.value + '</Param>';				
			}	
			myXML += '</Params>';
		}
				
		if(data.payload != undefined){
			myXML += '<Payload>' + data.payload + '</Payload>';
		}
		
		myXML += '</Request>';
		
		_callback = { 
						obj 	: obj,
						result	: result,
						args	: args
					};
						
		
		var requestXML = new XML();
		requestXML.ignoreWhite = true;
		requestXML.parseXML(myXML);
		
		requestXML.contentType="application/xml";
		
		debug(requestXML);
		
		
		var responseXML = new XML();
		//find somewhere else to store this
		
		responseXML.ignoreWhite = true;
		responseXML._scope = this;
		responseXML.onLoad = function(success){
			if(success){
				this._scope.process(this);
			}		
		}
		
		responseXML.contentType="application/xml";		
		requestXML.sendAndLoad(Main.middlewear,responseXML);
			
	}
	
	private function process(xml)
	{
		applyCallback(xml);	
	}
	
	private function applyCallback(xml)
	{
		debug(xml);
		var args = _callback.args;
		var result = _callback.result;
		var obj = _callback.obj;
		
		if(args){
			//merge xml with args
			args.unshift(xml);
		}else{
			var args = [xml];
		}
		//send it on somewhere
		result.apply(obj,args);
	}
	
	public function parseParams(rawxml:String) : Array
	{
		var txml = new XML();
		txml.ignoreWhite = true;
		txml.parseXML(rawxml);
		
		var tA = [];
		
		for(var i=0;i<txml.firstChild.childNodes.length;i++){
			var node = txml.firstChild.childNodes[i];
			tA.push({name:node.attributes.Name,value:node.firstChild.nodeValue});			
		}
		return tA;
	}

}