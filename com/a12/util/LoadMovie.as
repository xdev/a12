/* $Id$ */

package com.a12.util
{
	
	import flash.display.*;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.utils.*;
	
	import com.a12.util.CustomEvent;
	
	public class LoadMovie extends Sprite
	{
		public var loader:Loader;
		private var _ref:Object;
		
		public function LoadMovie(r:Object,asset:String)
		{
			_ref = r;
			
			loader = new Loader();
			var url:URLRequest = new URLRequest(asset);
			loader.load(url);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,handleLoad);
		}
		
		private function handleLoad(e:Event):void
		{
			_ref.addChild(loader.content);
			dispatchEvent(new CustomEvent(Event.COMPLETE,true,false,{mc:_ref}));
		}
		
	}
	
}