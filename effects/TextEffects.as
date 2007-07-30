/*

Class: TextEffects

*/

import com.a12.util.*;

class com.a12.effects.TextEffects
{
	
	private	var	_tf 		: TextField;
	private	var amount		: Number;
	private	var	delay		: Number;
	private	var tempText	: String;
	private	var	html		: String;
	private	var charCount	: Number;	
	public	var	myBroadcaster	: Object;
	
	private	var myInterval	: Number;
	
	public function TextEffects(tfObj:TextField)
	{
		_tf = tfObj;
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
	
	public function stuffit(_amount:Number, _delay:Number) : Void
	{
		
		amount = _amount ? _amount : 1;
		delay = _delay ? _delay : 10;
		tempText = _tf.text;
		html = _tf.htmlText;
		charCount = 0;
		_tf.text = "";
		//trace(tfObj + '-' + amount + '-' + delay);

		clearInterval(myInterval);
		myInterval = setInterval(this,"doStuff",delay);
	}
	
	public function kill()
	{
		//trace('done');
		myBroadcaster.broadcastMessage("onClose",_tf);
		clearInterval(myInterval);
	}
	
	private function fillHtml()
	{
	
	}
	
	private function doStuff()
	{
		if (_tf.length < tempText.length) {
			_tf.text += tempText.substring(charCount, charCount + amount);
			charCount += amount;
		} else {
			
			myBroadcaster.broadcastMessage("onComplete",_tf);
			//_tf.htmlText = html;
			//tfObj.htmlText = html;
			kill();
		}
	}
	
	/*
	// DOESN"T WORK!!! Check against original
	public function unstuffit(tfObj:TextField, amount:Number, delay:Number) : Void
	{
		var amount = amount ? amount : 1;
		var delay = delay ? delay : 10;
		//var tempText = tfObj.text;
		var charCount = 0;
		
		//tfObj.text = "";
		var intID = setInterval(function(){
			//trace("stuffitInt");
			if (tfObj.length > 0) {
				tfObj.text += tfObj.text.substring(0, 0 - amount);
			} else {
				clearInterval(intID);
			}
		}, delay);
	}
	*/
}