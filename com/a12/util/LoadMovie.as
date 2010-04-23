package com.a12.util
{
	
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.net.URLRequest;	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import com.a12.util.CustomEvent;
	
	public class LoadMovie extends Sprite
	{
		public var loader:Loader;
		private var _ref:Object;
		
		public function LoadMovie(r:Object,asset:String,context:LoaderContext=null)
		{
			_ref = r;
			
			loader = new Loader();
			var url:URLRequest = new URLRequest(asset);
			
			loader.load(url,context);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,handleLoad);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,handleError);
		}
		
		private function handleError(e:IOErrorEvent):void
		{
			
		}
		
		private function handleLoad(e:Event):void
		{
			_ref.addChild(loader);
			dispatchEvent(new CustomEvent(Event.COMPLETE,true,false,{mc:_ref,loader:loader}));
			loader = null;
		}
		
	}
	
}