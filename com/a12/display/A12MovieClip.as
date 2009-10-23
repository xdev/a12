package com.a12.display
{
	import flash.display.MovieClip;
	
	dynamic public class A12MovieClip extends flash.display.MovieClip
	{
		
		public function A12MovieClip()
		{
			super();
		}
		
		public function setProps(obj:Object):void
		{
			for(var i:* in obj){
				this[i] = obj[i];
			}
		}
		
	}
	
}