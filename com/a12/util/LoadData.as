package com.a12.util
{
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoaderDataFormat;
	import flash.events.HTTPStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import com.a12.util.CustomEvent;
	
	public class LoadData extends Sprite
	{
		private var request:URLRequest;
		private var loader:URLLoader;
		
		public function LoadData(url:String,method:String='post',dataFormat:String='text',data:Object=null)
		{
			request = new URLRequest(url);
			if(data){
				var requestVars:URLVariables = new URLVariables();
				for(var i:* in data){
					requestVars[i] = data[i];
				}
				request.data = requestVars;
			}
			
			request.method = method;
			
			loader = new URLLoader();
			loader.dataFormat = dataFormat;
			loader.addEventListener(Event.COMPLETE, handleLoad, false, 0, true);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			
		}
		
		public function load():void
		{
			try {
				loader.load(request);
			} catch (e:Error){
				trace(e);
			}
		}
		
		private function handleLoad(e:Event):void
		{
			dispatchEvent(new CustomEvent(Event.COMPLETE,true,false,{data:e.target.data}));
			loader = null;
			request = null;
		}
		
		private function httpStatusHandler(e:HTTPStatusEvent):void
		{
			
		}
		private function securityErrorHandler(e:SecurityErrorEvent):void
		{
			
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void
		{
			
		}
		
	}
	
}