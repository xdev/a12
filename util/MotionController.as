import com.a12.util.Motion;
import com.a12.math.easing.*;

class com.a12.util.MotionController
{
	
	/**
	 * Private constructor function prevents multiple instances of Class.
	 * Create class instance through "init" method.
	 */
	
	private static var _instance	: MotionController = null;
	private var objList				: Array = [];
	private var result				: Function = update;
	private	var	frequency			: Number;
	
	private function MotionController() {
	}
	
	public function setFrequency(freq) : Void
	{
		frequency = freq;
	}
	
	public static function getInstance() : MotionController
	{
		if (MotionController._instance == null) {
			MotionController._instance = new MotionController();
		}
		// import ease classes
		Back; Bounce; Circ; Cubic; Elastic; Expo; Linear; Quad; Quart; Quint; Sine;
		return MotionController._instance;
	}
	
	public function changeProps(mc:MovieClip, props:Object, duration:Number, easeMath:String, easeType:String, easeParam:Array, delay:Number, freq:Number, callback:Object) : Motion 
	{
		//trace("--changeProps");
		if(freq == undefined && frequency != undefined){
			freq = frequency;
		}
		
		var motionObj = new Motion(this, mc, props, duration, easeMath, easeType, easeParam, delay, freq, callback);
		
		objList.push(motionObj);
		return(motionObj);
	}
	
	public function checkConflicts(motionObj)
	{
		//trace("--checkConflicts");
		
		// check to see if object already exists in objList
		//var len:Number = objList.length;
		for(var i in objList) {
			if (objList[i] != motionObj && objList[i].getmc() == motionObj.getmc()) {
				//trace("matching mc exists");
				// check prop list on existing motionObj against props on checkConflicts motionObj
				var objProps = objList[i].getProps();
				
				var conflictFlag = false;
				for (var j in objProps) {
					for (var k in motionObj.getProps()) {
						if (j == k) { // check for isMoving causes major bugs
							//trace(motionObj.getmc() + " - conflict:" + j);
							conflictFlag = true;
							objList[i].stopProp(j);
							//if no props exist, remove obj altogether
							var tA = objList[i].getPropList();
							if(tA.length == 0){
								objList[i].stopMove();
								objList.splice(i, 1);
							}
						}
					}
				}
			}
		}
		//motionObj.stopMove(motionObj.getmc());
		motionObj.startMove();
	}
	
	public function stopMove(mc:MovieClip) : Void
	{
		var len:Number = objList.length;
		for (var i=0; i<len; i++) {
			if (objList[i].getmc() == mc) {
				//trace("--stopMove: " + mc);
				objList[i].stopMove();
				objList.splice(i, 1);
			}
		}
	}
	
	public function update(motionObj) : Void
	{
		//trace("--receiveUpdate");
		
		var listref = objList;
		var len:Number = listref.length;
		for(var i=0; i<len; i++) {
			if (listref[i] == motionObj) {
				//trace("item removed");
				listref.splice(i, 1);
			}
		}
		//trace('list' + objList);
	}
	
	public function getStatus(mc:MovieClip) : Boolean
	{
		var statusFlag = 0;
		var len:Number = objList.length;
		for (var i=0; i<len; i++) {
			if (objList[i].getmc() == mc) {
				statusFlag = 1;
			}
		}
		if (statusFlag == 1) {
			return(true);
		} else {
			return(false);
		}
	}
	
}