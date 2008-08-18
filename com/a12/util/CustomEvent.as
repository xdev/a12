/* $Id */

package com.a12.util
{
	import flash.events.Event;
	
	public class CustomEvent extends Event
	{
		
		public var props:Object;
		
		public function CustomEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, props:Object=null)
		{
			super(type, bubbles, cancelable);
			this.props = props;
		}
		
		public override function clone():Event
		{
			return new CustomEvent(type, bubbles, cancelable, props);
		}
		
		public override function toString():String
		{
			return formatToString("CustomEvent", "type", "bubbles",  "cancelable", "eventphase", "props");
		}
		
	}
	
}