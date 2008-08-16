/*

Class: TextEffects

*/

import com.a12.util.*;

class com.a12.effects.TextEffects
{
	
	private	var	_tf 			: TextField;
	private	var _amount			: Number;
	private	var	_freq			: Number;
	private var _delay			: Number;
	private	var _tempText		: String;
	private	var	_html			: String;
	private	var _charCount		: Number;
	private	var _freqInterval	: Number;
	private	var _delayInterval	: Number;
	public	var	_fxBroadcaster	: Object;
	
	public function TextEffects(tfObj:TextField)
	{
		_tf = tfObj;
		_fxBroadcaster = new EventBroadcaster();
	}
	
	public function _addListener(obj)
	{
		_fxBroadcaster.addListener(obj);	
	}
	
	public function _removeListener(obj)
	{
		_fxBroadcaster.removeListener(obj);	
	}
	
	public function stuffit(amount:Number, freq:Number, delay:Number) : Void
	{
		//trace('--stuffit');
		_amount = amount ? amount : 1;
		_freq = freq ? freq : 10;
		_delay = delay ? delay : 10;
		_tempText = _tf.text;
		_html = _tf.htmlText;
		_charCount = 0;
		_tf.text = "";
		
		//trace(tfObj + '-' + _amount + '-' + _freq + '-' + _delay);
		
		clearInterval(_delayInterval);
		_delayInterval = setInterval(this, "startStuff", _delay);
		
	}
	
	public function startStuff() :Void 
	{
		clearInterval(_delayInterval);
		
		clearInterval(_freqInterval);
		_freqInterval = setInterval(this, "stuffText", _freq);
	}
	
	private function stuffText()
	{
		//trace('--stuffText');
		if (_tf.length < _tempText.length) {
			_tf.text += _tempText.substring(_charCount, _charCount + _amount);
			_charCount += _amount;
		} else {
			
			_fxBroadcaster.broadcastMessage("onComplete",_tf);
			//_tf.htmlText = _html;
			//tfObj.htmlText = _html;
			kill();
		}
	}
	
	public function kill()
	{
		//trace('--kill');
		_fxBroadcaster.broadcastMessage("onClose", _tf);
		clearInterval(_freqInterval);
	}
	
	private function fillHtml()
	{
	
	}
	
	/*
	// DOESN"T WORK!!! Check against original
	public function unstuffit(tfObj:TextField, amount:Number, freq:Number) : Void
	{
		var _amount = amount ? amount : 1;
		var _freq = freq ? freq : 10;
		//var _tempText = tfObj.text;
		var _charCount = 0;
		
		//tfObj.text = "";
		var intID = setInterval(function(){
			//trace("stuffitInt");
			if (tfObj.length > 0) {
				tfObj.text += tfObj.text.substring(0, 0 - _amount);
			} else {
				clearInterval(intID);
			}
		}, delay);
	}
	*/
}