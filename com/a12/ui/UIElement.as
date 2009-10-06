package com.a12.ui
{
	import flash.display.MovieClip;
	
	public class UIElement extends MovieClip implements IUI
	{
		
		/*
		define common variables
		*/
		public var ref:MovieClip;
		public var _options:Object;
		public var _value:Object;
		
		public function UIElement(mc:MovieClip,iObj:Object,dObj:Object=null)
		{
			ref = mc;
			_options = {};
			_value = null;
			
			for(var i:Object in dObj){
				_options[i] = dObj[i];
			}			
			
			for(var j:Object in iObj){
				_options[j] = iObj[j];
			}			
		}
		
		/* Interface */
		public function getRef():MovieClip
		{
			return ref;
		}		
		
		public function getValue():Object
		{
			return _value;
		}
		
		public function setValue(value:Object):void
		{
			_value = value;
		}
		
		public function reset():void
		{
			_value = null;
		}
		
		/* Class */
		
		/*
		
		Set up accessibility Event Listeners
		
		*/
		
	}
	
}