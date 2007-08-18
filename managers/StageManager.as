/*

Class: StageManager
Manages a set of MovieClips and associated relative properties and sets these on stage resize event.
Also, sets Stage to "noscale", and aligns "TL".

*/

import AsBroadcaster;

class com.a12.managers.StageManager
{
	
	private var _className : String = "StageManager";
	private	var	_objArray : Array;
	private var _methodArray : Array;
	private var _methodCount : Number;
	private var _stageObj : Object;
	private var _stageBroadcaster : Object;
	private var _stageListener : Object;
	
	/*
	
	Constructor: StageManager	
	
	*/
	
	public function StageManager()
	{
		trace("--" + _className + ":StageManager");
		
		_objArray = new Array();
		_methodArray = new Array();
		
		// set stage mode
		Stage.scaleMode = "noscale";
		Stage.align = "TL";
		
		// stage broadcaster
		_stageBroadcaster = {};
		AsBroadcaster.initialize(_stageBroadcaster);
		_stageObj = {b:_stageBroadcaster};
		_stageObj.onResize = function() {
			this.b.broadcastMessage("onResize");
		}
		Stage.addListener(_stageObj);
		
		// stage listener
		_stageListener = {};
		_stageListener._scope = this;
		_stageListener.onResize = function() {
			this._scope.updateStage();
		}
		
		this.enableSM();
	}
	
	/*
	
	Method: enableSM
	Enables stage management
	
	*/
	
	public function enableSM() : Void
	{
		trace("--" + _className + ":enableSM");
		_stageBroadcaster.addListener(_stageListener);
	}
	
	/*
	
	Method: disableSM
	Disables stage management
	
	*/
	
	public function disableSM() : Void
	{
		trace("--" + _className + ":enableSM");
		_stageBroadcaster.removeListener(_stageListener);
	}
	
	/*
	
	Method: addItem
	Adds MovieClip object and associated dynamic properties to managed object array
	
	Parameters:
		
		mc - movieclip to be added
		props - properties to be set on stage resize 
			note: props should be a property (e.g. '_x') and function reference pair (e.g. 'calcX', or 'function(){Stage.width/2}').
		rmc - the relative MovieClip; defines the MovieClip from which x, y coords will be set ('_parent' by default).
		
	*/
	
	public function addItem(mc:MovieClip, props:Object, rmc:MovieClip) : Void
	{
		trace("--" + _className + ":addItem");
		
		// remove item if already exists
		removeItem(mc);
		
		// add object
		_objArray.push([mc, props, rmc]);
		
		// updateStage
		updateStage();
	}
	
	/*
	
	Method: removeItem
	Removes MovieClip from managed object array
	
	Parameters:
		
		obj - movieclip to be removed
	
	*/
	
	public function removeItem(mc) : Void
	{
		trace("--" + _className + ":removeItem");
		
		// remove object
		var len = _objArray.length;
		for (var i=0; i<len; i++) {
			if (mc == _objArray[i][0]) {
				_objArray.splice(i, 1);
				break;
			}
		}
	}	
	
	/*
	
	Method: addMethod
	Adds method to managed method array
	
	Parameters:
		
		mc - movieclip to be added
		props - properties to be set on stage resize 
			note: props should be a property (e.g. '_x') and function reference pair (e.g. 'calcX', or 'function(){Stage.width/2}').
		rmc - the relative MovieClip; defines the MovieClip from which x, y coords will be set ('_parent' by default).
		
	*/
	
	public function addMethod(method:Object, obj:Object, args:Array) : Number
	{
		trace("--" + _className + ":addMethod");
		
		if (!_methodCount) _methodCount = 0;
		
		_methodCount++;
		
		// add method
		_methodArray.push([_methodCount, method, obj, args]);
		
		// updateStage
		updateStage();
		
		return _methodCount;
	}
	
	/*
	
	Method: removeMethod
	Removes method from managed method array
	
	Parameters:
		
		id - method id to be removed
	
	*/
	
	public function removeMethod(id) : Void
	{
		trace("--" + _className + ":removeMethod");
		
		// remove method
		var len = _methodArray.length;
		for (var i=0; i<len; i++) {
			if (id == _methodArray[i][0]) {
				_methodArray.splice(i, 1);
				break;
			}
		}
	}
	
	/*
	
	Method: removeAll
	Removes all MovieClips from managed object array.
	Removes all methods from managed method array
	
	*/
	
	public function removeAll() : Void
	{
		trace("--" + _className + ":removeAll");
		
		// remove all mc objects
		var len = _objArray.length;
		for (var i=0; i<len; i++) {
			_objArray.pop();
		}
		
		// remove all methods
		var len = _methodArray.length;
		for (var i=0; i<len; i++) {
			_methodArray.pop();
		}
	}
	
	/*
	
	Method: updateStage
	Cycles through managed objects and sets all associated props
	
	*/
	
	public function updateStage():Void
	{
		trace("--" + _className + ":updateStage");
		
		// manage movieclips
		var len = _objArray.length;
		for (var i=0;i<len;i++) {
			
			var mc = _objArray[i][0];
			var props = _objArray[i][1];
			var rmc = _objArray[i][2];
			
			for (var j in props) {
				
				if (rmc != undefined) {
					
					if (j == "_x" || j == "_y") {
						// calc value
						var v:Number = props[j].apply();
						
						// convert coordinates
						var pt1:Object = {x:0, y:0};
						rmc.localToGlobal(pt1);
						var pt2:Object = {x:0, y:0};
						mc._parent.localToGlobal(pt2);
						
						// set prop
						if (j == "_x") {
							mc[j] = pt1.x - pt2.x + v;
						} else if (j == "_y") {
							mc[j] = pt1.y - pt2.y + v;
						}
					
					} else {
						
						// set prop
						mc[j] = props[j].apply();
					
					}
					
				} else {
					
					// set prop
					mc[j] = props[j].apply();
				
				}
				
			}
		}
		
		// execute methods
		var len = _methodArray.length;
		for (var i=0;i<len;i++) {
			var id:Number = _methodArray[i][0];
			var method:Object = _methodArray[i][1];
			var obj:Object = _methodArray[i][2];
			var args:Array = _methodArray[i][3];
			method.apply(obj, args);
		}
		
	}
	
	/*
	
	Method: kill
	Deletes objects, listeners, and destroys class
	
	*/
	
	public function kill() : Void
	{
		trace("--" + _className + ":kill");
		
		disableSM();
		Stage.removeListener(_stageObj);
		removeAll();
		delete this;
		
	}
	
}


