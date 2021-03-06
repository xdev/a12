package com.a12.util
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	public class XMLLoader
	{
		private	var	loader:URLLoader;
		private	var	result:Function;
		private	var	obj:Object;
		private	var	args:Array;
		
		public function XMLLoader(xmlsrc:String,r:Function,o:Object)
		{
			result = r;
			obj = o;
			
			loader = new URLLoader();
			var url:URLRequest = new URLRequest(xmlsrc);
			loader.load(url);
			loader.addEventListener(Event.COMPLETE,handleLoad);			
		}
		
		private function handleLoad(e:Event):void
		{
			result.apply(obj, [new XML(loader.data)]);
		}			
	}	
}