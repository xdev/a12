import com.a12.util.*;
import AsBroadcaster;

class com.a12.ui.NumericStepper
{
	
	private	var _value			: Number;
	private	var _min			: Number;
	private	var _max			: Number;
	private	var _step			: Number;
	private	var _tf				: TextFormat;
	private	var _ref			: MovieClip;
	private	var _myBroadcaster	: Object;
	
	public function NumericStepper(ref:MovieClip,init:Number,config:Object) 
	{
		//init values
		_ref = ref;
		(config.step == undefined) ? _step = 1 : _step = config.step;
		(config.min == undefined) ? _min = 0 : _min = config.min;
		(config.max == undefined) ? _max = undefined : _max = config.max;
		_tf = config.tf;
		if(init == undefined){
			setValue(1);
		}else{
			setValue(init);
		}
		
		_myBroadcaster = new Object();
		AsBroadcaster.initialize(_myBroadcaster);
		
		drawStepper();
		
	}
	
	public function _addListener(obj){
		_myBroadcaster.addListener(obj);
	}
	
	public function _removeListener(obj){
		_myBroadcaster.removeListener(obj);
	}
	
	public function getValue() : Number 
	{
		return _value;
	}
	
	public function setValue(v:Number) : Void
	{
		_value = v;
	}
	
	private function drawStepper()
	{
	
		//Utils.createmc(_ref,"stepper",0);
		Utils.createmc(_ref,"txt",1);
		Utils.createmc(_ref,"but_up",2,{_x:-20,_y:0,dir:1,t:this});
		Utils.createmc(_ref,"but_down",3,{_x:-20,_y:12,dir:-1,t:this});
		
		Utils.createmc(_ref.but_up,"back",0,{_alpha:60});
		Utils.createmc(_ref.but_down,"back",0,{_alpha:60});
		
		Utils.drawRect(_ref.but_up.back,18,11,0xFFFFFF,100);
		Utils.drawRect(_ref.but_down.back,18,11,0xFFFFFF,100);
		
		_ref.but_up.attachMovie("arrow","icon",1,{_x:9,_y:5,_rotation:180,_alpha:70});
		_ref.but_down.attachMovie("arrow","icon",1,{_x:9,_y:5,_alpha:70});
		
		_ref.but_up.onRollOver = _ref.but_down.onRollOver = function(){
			this.back._alpha = 100;
		}
		
		_ref.but_up.onRollOut = _ref.but_down.onRollOut = function(){
			this.back._alpha = 60;
		}
		
		_ref.but_up.onPress = _ref.but_down.onPress = function(){
			this.t.adjustValue(this.dir);
			this.icon._xscale = 85;
			this.icon._yscale = 85;
		}
		
		_ref.but_up.onRelease = _ref.but_down.onRelease = function(){
			this.icon._xscale = 100;
			this.icon._yscale = 100;
		}
		
		
		Utils.makeTextfield(_ref.txt,"",_tf);
		updateStepper();
		
	}
	
	private function updateStepper(){
		_ref.txt.displayText.text = getValue();
	}
	
	
	private function adjustValue(dir:Number) : Void
	{		
		//need to set up switch to deal with boundary
		var t = getValue();
		
		switch(true){
			case t+(dir * _step) <= _min :
				//lower bound
			break;
			
			case _max != undefined && (t+(dir * _step) >= _max) :
				//upper bound
			break;
			
			default :
				t+= (dir * _step);
				setValue(t);
			break;
			
		
		}		
		
		_myBroadcaster.broadcastMessage("onChange",getValue());
		updateStepper();
	}



}