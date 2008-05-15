/* $Id$ */

package com.a12.util
{
	
	import flash.display.*;
	import flash.net.URLRequest;
	import flash.events.*;
	
	public class LoadMovie
	{
		public	var	loader	: Loader;
		private	var	_ref	: Object;
		
		public function LoadMovie(r:Object,asset:String)
		{
			_ref = r;
			
			loader = new Loader();
			var url:URLRequest = new URLRequest(asset);
			loader.load(url);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,handleLoad);
		}
		
		private function handleLoad(e:Event)
		{
			_ref.addChild(loader.content);
		}
		
	}
	
}