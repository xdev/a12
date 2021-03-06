package com.a12.util
{

	//import AsBroadcaster;
	import com.a12.util.CustomEvent;

	public class EventBroadcaster
	{

		private var _myBroadcaster:Object;
		private var _objA:Array;
	
		public function EventBroadcaster()
		{
			_myBroadcaster = new Object();
			//AsBroadcaster.initialize(_myBroadcaster);
			_objA = new Array();
		}
	
		public function broadcastMessage(message,args):void
		{
			//trace(message + '___' + args);
			_myBroadcaster.broadcastMessage(message,args);
		}
	
		public function _addListener(obj):void
		{
			_myBroadcaster.addListener(obj);
			//trace('addListener' + obj);
			_objA.push(obj);
		}
	
		public function _removeListener(obj):void
		{
			_myBroadcaster.removeListener(obj);
			for(var i=0;i<_objA.length;i++){
				if(_objA[i] == obj){
					_objA.splice(i,1);
				}
			}	
		}
	
		public function removeAll():void
		{
			for(var i in _objA){
				_myBroadcaster.removeListener(_objA[i]);
			}
		}


	}

}