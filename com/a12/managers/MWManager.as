/* $Id$ */

package com.a12.managers
{

	import com.a12.util.*;
	import flash.xml.*;
	import flash.net.*;
	import flash.events.*;

	public class MWManager
	{

		private	var	_callback			: Object;
		private	var	debugMode			: Boolean;
		private	var	gateway				: String;
		private	var	loader				: URLLoader;
	
		public function MWManager(g:String)
		{
			gateway = g;
			debugMode = true;
		}
	
		public function setDebug(deb:Boolean)
		{
			debugMode = deb;
		}
	
		private function debug(t:Object)
		{
			if(debugMode == true){
				trace(t);
			}
		}
	
		public function transfer(data:Object,obj:Object,result:Object,args:Array=null)
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
						
		
			var requestXML = new XMLDocument();
			requestXML.ignoreWhite = true;
			requestXML.parseXML(myXML);
				
			debug(requestXML);
		
			loader = new URLLoader();
			var request:URLRequest = new URLRequest(gateway);
			request.requestHeaders = 
								[
									new URLRequestHeader("Content-Type","application/xml"),
									new URLRequestHeader("Accept","application/xml")
								];
			request.method = URLRequestMethod.POST;
			request.data = requestXML;
			loader.load(request);
			loader.addEventListener(Event.COMPLETE,process);
			
		}
	
		private function process(e:Event)
		{
			applyCallback(loader.data);	
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
				args = [xml];
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

}