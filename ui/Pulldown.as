
/** 
 * UI Element PullDown - based on Muzak which was based on Dove code from Tank circa winter 2004
 * To do:
 	add accessibility
 		text search (more than 1 character)
 		
 	when keying through, scroll items up if they are out of the viewable area
 	
 	when showing pulldown, auto scroll to value if set
 	
 	when closed, remove key listener
 	
 	background animation - linked to window mask
 	
 	lose focus (stroke) when clicking out
 		
 * Updated 02.22.07
 */
 
import com.a12.util.*;

import com.a12.ui.Scrollbar;

class com.a12.ui.Pulldown implements com.a12.ui.UIElement
{

	private var _ref			: MovieClip;
	private var dataA			: Array;
	private var configObj		: Object;
	private var	defaultObj		: Object;	
	private	var optionsLength	: Number;
	private var selection		: Number;
	private var selectionTemp	: Number;
	private	var	maskHeight		: Number;
	private	var	backHeight		: Number;
	private	var defaultValue	: Object;
	
	public	var Move			: MotionController;
	public	var mouseMode		: String;
	public	var broadcaster		: EventBroadcaster;
	
	private	var	scrollObj		: Scrollbar;
	private	var scrollListener	: Object;
	
	private	var mouseListener	: Object;
	
	
	public function Pulldown(clip:MovieClip,xml:XMLNode,config:Object,tabindex:Number){
		_ref = clip;
		selectionTemp = undefined;
		mouseMode = undefined;
		
		mouseListener = new Object();
		
		mouseListener.onMouseDown = function()
		{
		
		
		}
		
		broadcaster = new EventBroadcaster();
		
		dataA = [];
		
		if(xml.hasChildNodes()){
			for(var i=0;i<xml.childNodes.length;i++){
				//check if we have CDATA node or normal text node
				if(xml.childNodes[i].hasChildNodes()){
					var t = xml.childNodes[i].firstChild.nodeValue;
				}else{
					var t = xml.childNodes[i].nodeValue;			
				}
				
				if(xml.childNodes[i].attributes.selected == "selected"){
					//set the index to this one---boooya
					setIndex(i);
				}
				var val = xml.childNodes[i].attributes.value
				if(val == undefined){
					val = t;
				}
				
				dataA.push([val,t]);
			}
		}else{
			if(config.dataA != undefined){
				dataA = config.dataA;
			}
		}
				
		optionsLength = dataA.length;
		
		configObj = new Object();
		
		for(var i in config){
			configObj[i] = config[i];
		}
		
		var defaultObj = 
		
		{ 
			displaySize			: 10,
			clr_primary			: 0xCCCCCC,
			clr_focus			: 0x333333,
			clr_textnormal		: 0x333333,
			clr_textroll		: 0x000000,
			unitSize			: 20,
			_width				: 200,
			tx					: 5,
			ty					: 0,
			textxoff			: 3
		};
		 
		
		for(var i in defaultObj){
			if(configObj[i] == undefined){
				configObj[i] = defaultObj[i];
			}
		}
		
		if(config.Move == undefined){
			Move = MotionController.getInstance();				
		}else{
			Move = config.Move;
		}
		
		Utils.createmc(_ref,"control",10);
		Utils.createmc(_ref.control,"label", 1);

		//Utils.makeTextfield(_ref.control.label,configObj.tip, 5, configObj.textxoff, "left", configObj.pull_tf, true);
		Utils.makeTextfield(_ref.control.label,configObj.tip,configObj.tf_main,{_x:configObj.tx,_y:configObj.ty});
		
		if(getIndex()){
			//do the preset selection if any
			_ref.control.label.displayText.text = getLabel();
		}
		
		//Utils.changeColor(_ref.control.label,configObj.textnormal);
		Utils.createmc(_ref.control,"back", 0,{_alpha:100});//configObj.topAlpha
		Utils.drawRect(_ref.control.back,configObj._width, configObj.unitSize, configObj.clr_primary, 100);
		// 
		_ref.control.attachMovie("arrows", "arrows", 2, {_x:configObj._width-configObj.unitSize, _y:0});
		Utils.changeColor(_ref.control.arrows,configObj.clr_focus);
		//
		
		
		//_ref.tabEnabled = true;
		//_ref.tabChildren = false;
		//_ref.focusEnabled = true;
		//_ref.tabIndex = tabindex;
		
		
		
		_ref.control._scope = this;
		_ref.control.onPress = function() {
			trace('onPress ' + this._parent);
			//trace(this._parent);
			Selection.setFocus(this._parent);
			//trace("Focus is " + Selection.getFocus());
			this._scope.displayPulldown();
		};
		
		
		
				
		
		
		_ref._scope = this;
		
		_ref.onSetFocus = function(oldFocus){
			this._scope._onSetFocus();			
		}
		
		_ref.onKillFocus = function(newFocus){
			this._scope._onKillFocus();			
		}
										
		buildOptions();
		
	}
	
	private function _onKillFocus()
	{
		Utils.changeColor(_ref.control.back,configObj.clr_primary);
		Utils.changeColor(_ref.control.arrows,configObj.clr_focus);
		Key.removeListener(this);
		hidePulldown();
		Mouse.removeListener(this);
		broadcaster.broadcastMessage("onKillFocus",_ref);
	}
	
	private function _onSetFocus()
	{
		Utils.changeColor(_ref.control.back,configObj.clr_focus);
		Utils.changeColor(_ref.control.arrows,configObj.clr_primary);
		Key.addListener(this);	
		broadcaster.broadcastMessage("onSetFocus",_ref);
	}
	
	private function onKeyDown()
	{
		switch(Key.getCode()){
				
			case Key.UP:
				shiftValue(-1);
			break;
			
			case Key.DOWN:
				shiftValue(1);
			break;
			
			case Key.SPACE:
				setAndClose();
			break;
			
			case Key.ENTER:
				setAndClose();
			break;
			
			default:
			
				//perform text searching
			
			break;
		}
	}
	
	public function onMouseDown()
	{
		
		//trace('onMouseDown' + Selection.getFocus() + '  '  + mouseMode);
				
		if(mouseMode == 'simple'){
			if((_ref._xmouse > configObj._width + 10) || (_ref._xmouse < -10) || (_ref._ymouse < 0) || (_ref._ymouse > configObj.unitSize)){
			  
			   _onKillFocus();
			   
			}
		
		}
		
		if(mouseMode == 'advanced'){
			var hide = false;
			
			switch(true)
			{			
				case (_ref._xmouse > configObj._width + 10) || (_ref._xmouse < -10) :
					hide = true;
				break;
				
				case _ref._ymouse < 0 :
					hide = true;
				break;
				
				case optionsLength > configObj.displaySize :
					if(_ref._ymouse > (configObj.displaySize + 1)*configObj.unitSize){
						hide = true;
					}
				break;
				
				case optionsLength <= configObj.displaySize :
					if(_ref._ymouse > (optionsLength + 1)*configObj.unitSize){
						hide = true;
					}
				break;
				
			
			
			}
			
			
			if(hide == true){
				
				_onKillFocus();
				
			}
			
		
		
		}
	
	}
	
	private function onMouseMove()
	{
		
		if(mouseMode == 'wheel'){
			enableStrip(true);
			mouseMode = 'advanced';
		}
	
	}
	
	public function onMouseWheel(delta)
	{
		if(delta > 0){
			delta = 1;
		}else{
			delta = -1;
		}
		
		if(optionsLength > configObj.displaySize){
			
			mouseMode = 'wheel';
			enableStrip(false);
			
			var tY = _ref.options.strip._y + delta;
			var tH = (optionsLength * configObj.unitSize) - (configObj.displaySize * configObj.unitSize);
			
			switch(true)
			{
			
				case (Math.abs(tY) >= tH):
					_ref.options.strip._y = -tH;
				break
				
				case (tY >= 0):
					_ref.options.strip._y = 0;
				break;
				
				default:
					_ref.options.strip._y += delta * configObj.unitSize;
				break;
			
			}
			
			var perc = Math.abs(_ref.options.strip._y / (tH));
			scrollObj.setScroll(perc);	
						
			
		
		}
	}
	
	public function update(data:Array) :  Void
	{
		dataA = data;
		optionsLength = dataA.length;
		buildOptions();		
	}
	
	public function setAndClose() : Void
	{
		var t = getIndex();
		if(t != undefined){
			onChange(_ref.options.strip["option"+t]);
			hidePulldown();
		}
	}
	
	public function shiftValue(dir:Number) : Void
	{
		
		var t = getTempIndex();
		if(t != undefined){
			//
		}else{
		
			var t = getIndex();
			if(t == undefined && dir == 1){
				t = -1;
			}
			if(t == undefined && dir == -1){
				t = 1;
			}
		}
		
		
		
		switch(true){
		
			case t == 0 && dir == -1:
			
			break;
			
			case t == (dataA.length - 1) && dir == 1:
			
			break;
			
			case t == -1 && dir == -1:
			
			break;
			
			default:
				t+=dir;
				setIndex(t);
			break;		
		}
		if(t != undefined){
			//update the view
			spotlightItem(_ref.options.strip["option"+getIndex()]);
			_ref.control.label.displayText.text = getLabel();
		}
	}
	
	public function _addListener(obj:Object) : Void
	{
		broadcaster._addListener(obj);
	}
	
	public function _removeListener(obj:Object) : Void
	{
		broadcaster._removeListener(obj);
	}
	
	private function onChange(clip:MovieClip) : Void
	{
	
		setIndex(clip.index);
		broadcaster.broadcastMessage("onChange",this);
		_ref.control.label.displayText.text = getLabel();
		trace("getValue - " + getValue());
	
	}
	
	private function getDiff() : Number
	{
		return ((optionsLength-configObj.displaySize))*-configObj.unitSize;
	}
	
	public function setIndex(ind:Number) : Void
	{
		selection = ind;
	}
	
	private function setTempIndex(ind:Number) : Void
	{
		selectionTemp = ind;
	}
	
	private function getTempIndex() : Number
	{
		return selectionTemp;	
	}
	
	public function getIndex() : Number
	{
		return selection;	
	}
	
	public function reset()
	{
		if(defaultValue != undefined){
			setValue(defaultValue);
		}else{
			selectionTemp = undefined;
			selection = undefined;
			_ref.control.label.displayText.text = '';
			
		}
	}
	
	public function getValue()
	{
		if(getIndex() != undefined){
			return dataA[getIndex()][0];
		}else{
			return '';
		}
	}
	
	public function setMaskHeight(h:Number) : Void
	{
		maskHeight = h;
	}
	
	public function getMaskHeight() : Number
	{
		return maskHeight;
	}
	
	public function getBackHeight() : Number
	{
		return backHeight;
	}
	
	public function setBackHeight(h:Number) : Void
	{
		backHeight = h;
	}
	
	public function setValue(val) : Void
	{
		for(var i=0;i<dataA.length;i++){
			if(dataA[i][0] == val){
				setIndex(i);
				_ref.control.label.displayText.text = getLabel();
			}
		}
		defaultValue = val;
	}
	
	public function getWidth() : Number
	{
		return configObj._width;
	}
	
	public function getRef() : MovieClip
	{
		return _ref;
	}
	
	public function getLabel() : String
	{
		return dataA[getIndex()][1];
	}
	
	
	
	private function spotlightItem(but:MovieClip) : Void
	{
		for(var i in _ref.options.strip){
			var clip = _ref.options.strip[i];
			if(but == clip){
				Utils.changeColor(clip.back,configObj.clr_focus);
				setTempIndex(clip.index);
			}else{
				Utils.changeColor(clip.back,configObj.clr_primary);
			}
		}
	}
	
	private function buildOptions() : Void
	{
		Utils.createmc(_ref,"options",1,{_y:configObj.unitSize+1,_visible:false});
		var strip = Utils.createmc(_ref.options,"strip",1);
		
		//create each option
		for(var i =0;i<optionsLength;i++){
			
			Utils.createmc(strip,"option"+i, i, {_y:(configObj.unitSize*i)});
			var cB = strip["option"+i];
			Utils.createmc(cB,"label", 1);
			Utils.createmc(cB,"back", 0);
			Utils.drawRect(cB.back,configObj._width, configObj.unitSize, configObj.clr_primary, 100);
			cB.index = i;
			
			cB.value = dataA[i][0];
			Utils.makeTextfield(cB.label,dataA[i][1],configObj.tf_main,{_x:configObj.tx,_y:configObj.ty});
			cB._scope = this;
			cB.onPress = function() {
				this._scope.onChange(this);
				this._scope.hidePulldown();
			};
			
			cB.onRollOver = function() {
				this._scope.spotlightItem(this);
				
			};
			
			cB.onRollOut = cB.onReleaseOutside=function () { 
				//this.back._alpha = 0;
				//Utils.changeColor(this.label,this.t.configObj.textnormal);
			};
		
		}
		
		
		
		if(optionsLength > configObj.displaySize){
		
			
			setMaskHeight(configObj.displaySize*configObj.unitSize + 6);
			setBackHeight(configObj.displaySize*configObj.unitSize); 
			
			createScroller();
			
			Utils.createmc(_ref.options,"stripMask", 2);
			Utils.drawRect(_ref.options.stripMask,configObj._width, getMaskHeight()-6, 0xFF0000, 10);
			_ref.options.strip.setMask(_ref.options.stripMask);
			
					
			
		}else{
			
			
			//nothing really
			setMaskHeight(optionsLength*configObj.unitSize+6);
			setBackHeight(optionsLength*configObj.unitSize); 
			
		}
			
		//do the masks
		Utils.createmc(_ref,"optionsMask", 22, {_x:-4,_y:configObj.unitSize+1});
		
		if (configObj.rule) {
			//maskSize += 1;
		}
		Utils.drawRect(_ref.optionsMask,configObj._width+8, getMaskHeight(), 0xFF0000, 20);
		_ref.options.setMask(_ref.optionsMask);
		
		
		Utils.createmc(_ref.options,"back", -4);
		Utils.drawRect(_ref.options.back, configObj._width, getBackHeight(), configObj.clr_primary, 100);
		
		
		
		//_ref.back._yscale = 0;
	
	}
	
	private function enableStrip(mode:Boolean)
	{
		for(var i in _ref.options.strip){
			var clip = _ref.options.strip[i];
			clip.enabled = mode;
		}
	}
	
	
	
	private function createScroller() : Void
	{
		var clip = Utils.createmc(_ref.options,"scroller",500,{_x:configObj._width - 24});
		scrollObj = new Scrollbar(clip,
			{
				mode: 'vertical',
				barW: 24,
				barH: configObj.displaySize*configObj.unitSize,
				nipW: 24,
				nipH: 50,
				offsetH: 0,
				shiftAmount: 30,
				clr_bar: configObj.clr_bar,
				clr_nip: configObj.clr_focus,
				clr_hover: configObj.clr_focus
			}
		);
		
		clip.back._alpha = 100;
		
		
		
		delete scrollListener;
		scrollListener = new Object();
		scrollListener._scope = this;
		scrollListener.onScroll = function(tObj)
		{
			this._scope._ref.options.strip._y = Math.floor(this._scope.getDiff() * tObj.percent/100);
		}
		
		scrollObj.broadcaster._addListener(scrollListener);
	}
		
	public function hidePulldown() : Void
	{
	
		//
		var t =  (-optionsLength + 2)*configObj.unitSize-(configObj.unitSize+1);
		var t2 = t;
		//_root.Move.changeProps(options,{_y:t},500,"Cubic","easeOut");
		if(optionsLength > configObj.displaySize){
			var t2 = -configObj.displaySize * configObj.unitSize;
		}
		
		//Move.changeProps(_ref.window,{_y:t2},500,"Cubic","easeOut");
		_ref.options._y = t2;
		for(var i in _ref.options.strip){
			_ref.options.strip[i].enabled = false;
		}
		
		
		
		
		//scale mask down
		//Move.changeProps(_ref.optionsMask,{_height:0},500,"Cubic","easeOut");
		_ref.optionsMask._height = 0;
		
		//Move.changeProps(_ref.back,{_y:t2},500,"Cubic","easeOut");
		//Move.changeProps(_ref.back,{_height:0},500,"Cubic","easeOut");
		//_ref.back._height = 0;
		
		
		Mouse.removeListener(this);
		mouseMode = 'simple';
		Mouse.addListener(this);
		
		_ref.control.onPress = function() {
			trace('onPress ' + this._parent);
			Selection.setFocus(this._parent);
			this._scope.displayPulldown();
		};
		
		
		
		
		
	}
	
	public function displayPulldown() : Void
	{
		
		//scale mask up
		selectionTemp = undefined;
		
		broadcaster.broadcastMessage("onDisplay",_ref);
		
		var t = (-optionsLength+2)*configObj.unitSize-(configObj.unitSize+1);
		
		if(optionsLength > configObj.displaySize){
			t = -configObj.displaySize * configObj.unitSize;
		}
		
		_ref.options._y = t;
		_ref.options._visible = true;
		
		
		_ref.options._alpha = 0;
		Move.stopMove(_ref.options);
		Move.changeProps(_ref.options,{_alpha:100},250);
		
		
		
		_ref.options.strip._y = 0;
		
		//Move.changeProps(_ref.window,{_y:configObj.unitSize+1},500,"Cubic","easeOut");
		_ref.options._y = configObj.unitSize+1;
		
		
		for(var i in _ref.options.strip){
			var clip = _ref.options.strip[i];
			clip.enabled = true;
			//options[i].back._alpha = 0;
			Utils.changeColor(clip.back,configObj.clr_primary);
			if(clip == _ref.options.strip["option"+getIndex()]){
				Utils.changeColor(clip.back,configObj.clr_focus);
			}
		}
		
		
		
		//if we have a scroller... animated it
		//Move.changeProps(_ref.optionsMask,{_height:getMaskHeight()},500,"Cubic","easeOut");
		_ref.optionsMask._height = getMaskHeight();
		
		//_ref.back._visible = 1;
		
		//Move.changeProps(_ref.back,{_height:getBackHeight()},500,"Cubic","easeOut");
		//_ref.back._height = getBackHeight();
		
		Mouse.removeListener(this);
		mouseMode = 'advanced';
		Mouse.addListener(this);
		
		_ref.control.onPress = function() {
			this._scope.hidePulldown();
		};
		
		_ref.options.scroller.slider._y = 0;
		
				
	}
	


}
