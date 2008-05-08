// updated 02.13.2007

/**
 * Added getPropList 
 * Methods to add:
 * - none right now!
 *
 * Added:
 * - now checks constantly to see if movieclip still exists
 * 
 *
 */

import com.a12.util.MotionController;
import com.a12.math.easing.*;

class com.a12.util.Motion
{
	
	public var $mc:MovieClip;
	private var $props:Object;
	private var $duration:Number;
	private var $easeMath:Object;
	private var $easeType:String;
	private var $easeParam:Array;
	private var $delay:Number;
	private var $freq:Number;
	private var $callback:Object;
	
	private var controller:MotionController;
	private var propList:Array;
	private var startTime:Number;
	private var intID:Number;
	private var delayID:Number;
	private var checkStatusID:Number;
	private var thisObj:Motion;
	private var moveFlag:Boolean;
	
	public function Motion(c:MotionController, mc:MovieClip, props:Object, duration:Number, easeMath:String, easeType:String, easeParam:Array, delay:Number, freq:Number, callback:Object)
	{
		
		controller = c;
		thisObj = this;
		$mc = mc;
		$duration = duration;
		
		var equation = easeMath ? easeMath : 'Cubic';		
		$easeMath = com.a12.math.easing[equation];
		$easeType = easeType ? easeType : 'easeOut';
		$easeParam = easeParam ? easeParam : undefined;
		$freq = freq ? freq : (1000/30);
		$delay = delay ? delay : 0;
		
		$callback = callback;
		
		moveFlag = false;
		$props = props;
	
		
		if ($delay == 0) {
			checkConflicts();
		} else {
			checkStatusID = setInterval(thisObj, "checkStatus", $freq);
			delayID = setInterval(thisObj, "checkConflicts", $delay);
		}

		
	}
	
	public function getmc() : MovieClip
	{
		//trace("M:getMC");
		return $mc;
	}
	
	public function getProps() : Object
	{
		//trace("--M:getProps");
		return $props;
	}
	
	public function getPropList() : Array
	{
		return propList;
	}
	
	private function checkConflicts() : Void
	{
		//trace("--M:checkConflicts");
		controller.checkConflicts(thisObj);
	}
	
	private function startMove() : Void
	{
		//trace("--M:startMove");
		propList = new Array();
		for (var i in $props) {
			propList.push([i, $mc[i], $props[i]]);
		}
		//trace("--startMove");
		startTime = getTimer();
		clearInterval(delayID);
		clearInterval(intID);
		intID = setInterval(thisObj, "move", $freq);
	}
	
	public function stopMove() : Void
	{
		//trace("--M:stopMove");
		clearInterval(delayID);
		clearInterval(intID);
		clearInterval(checkStatusID);
		delete this;
	}
	
	public function stopProp(prop) : Void
	{
		//trace("--M:stopProp: " + prop);
		var len = propList.length;
		for (var i=0; i<len; i++) {
			//trace("currentProps: " + propList[i][0]);
			if (propList[i][0] == prop) {
				//trace("item deleted");
				propList.splice(i,1);
			}
		}
	}
	
	public function isMoving()
	{
		//trace("--M:isMoving");
		//trace('Move Flag' + this + ' - ' + moveFlag);
		if (moveFlag == true) {
			return true;
		} else {
			return false;
		}
	}
	
	private function checkStatus() : Void {
		//trace("M:checkStatus");
		// stop move operation if movieclip is removed
		if ($mc.valueOf() == undefined || $mc.valueOf() == "") {
			//trace("--move: *** movieclip no longer exists");
			moveFlag = false;
			stopMove();
			update();
		}
	}
	
	private function move() : Void {
		//trace("--move:" + $mc.valueOf());
		var done = 0;
		
		// Ease interface
		// t-elapsed time; b-start value; c-change value; d-duration
		
		for (var i in propList) {
			var prop:String = propList[i][0];
			var ease:Object = $easeMath[$easeType];
			var t:Number = getTimer() - startTime;
			var b:Number = propList[i][1];
			var c:Number = propList[i][2] - propList[i][1];
			var d:Number = $duration;
			var args = [t, b, c, d];
			
			// add easeParams
			if ($easeParam != undefined) {
				var len = $easeParam.length;
				for (var j=0;j<len;j++) {
					args.push($easeParam[j]);
				}
			}
			
			moveFlag = true;
			if (t <= d) {
				$mc[prop] = Math.floor(ease.apply(this, args));
				if(controller.debug == true){
					trace('updating '  + prop + '=' + $mc[prop]);
				}
				//updateAfterEvent();
			} else {
				$mc[prop] = propList[i][2];
				if(controller.debug == true){
					trace('done ' + prop + '=' + $mc[prop]);
				}
				done = 1;
			}
		}
		if (done == 1) {
			moveFlag = false;
			stopMove(); 
			update();
			
		}
	}
	
	private function update() : Void
	{
		controller.update(thisObj);
		if ($callback != undefined){						
			$callback.method.apply($callback.obj, $callback.args);
		}
	}
	
}