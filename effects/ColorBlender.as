/*

Class: ColorBlender

*/

import com.a12.util.Utils;

class com.a12.effects.ColorBlender
{

	public var myBroadcaster:Object;
	private var fadeInterval:Number;
	private var clr_begin:Object;
	private var clr_end:Object;
	private var stepMax:Number;
	private var stepRemains:Number;
	private var hex:Object;

	public function ColorBlender()
	{
		myBroadcaster = new EventBroadcaster();
	}
	
	public function _addListener(obj)
	{
		myBroadcaster.addListener(obj);	
	}
	
	public function _removeListener(obj)
	{
		myBroadcaster.removeListener(obj);	
	}
	
	public function blend(clr1:Object,clr2:Object,duration:Number) : Void
	{
		
		clr_begin = Utils.hexToRgb(clr1);
		clr_end = Utils.hexToRgb(clr2);
		if(hex != undefined){
			clr_begin = Utils.hexToRgb(hex);
		}
		stepRemains = stepMax = Math.ceil(duration/33);
		clr_end.hex = clr2;
		clearInterval(fadeInterval);
		fadeInterval = setInterval(this,"doBlend",33);
	}
	
	private function doBlend() : Void
	{
		if(stepRemains){
			var percent = 1 - stepRemains/stepMax;
			//blend away
			hex = (clr_begin.r+(clr_end.r-clr_begin.r)*percent) << 16 | (clr_begin.g+(clr_end.g-clr_begin.g)*percent) << 8 | (clr_begin.b+(clr_end.b-clr_begin.b)*percent);
			myBroadcaster.broadcastMessage("onHEX",hex);
			stepRemains--;
		}else{
			delete hex;
			myBroadcaster.broadcastMessage("onHEX",clr_end.hex);
			myBroadcaster.broadcastMessage("onComplete");
			clearInterval(fadeInterval);
		}
	}
	

}