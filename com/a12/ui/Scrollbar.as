import com.a12.util.*;

class com.a12.ui.Scrollbar
{

	public	var	_ref			: MovieClip;
	private	var	options			: Object;
	public	var broadcaster	: EventBroadcaster;
	private	var scrollInterval	: Number;
	public	var	lastPercent		: Number;
	
	public function Scrollbar(mc,_options)
	{
	
		_ref = mc;
		
		options = new Object();
		
		for(var i in _options){
			options[i] = _options[i];
		}
		
		var defaultObj = 
		{ 
			mode			: 'vertical',
			offsetH			: 0,
			barW			: 20,
			nipW			: 20,
			nipH			: 100			
		};
		 
		
		for(var i in defaultObj){
			if(options[i] == undefined){
				options[i] = defaultObj[i];
			}
		}
		
		lastPercent = 0;
		
		broadcaster = new EventBroadcaster();
		
		
		
		Utils.createmc(_ref,"back",0);
		
		Utils.createmc(_ref,"nip",1);
		Utils.createmc(_ref.nip,"back",0);
		
		
		if(options.mode == "vertical"){
			_ref.nip._y = options.offsetH;
		}
		
		
		renderBar();
		
		renderNip();
		
		
		
		_ref.back._scope = this;
		
		_ref.back.onRollOver = function()
		{
			this._scope.broadcaster.broadcastMessage("onBackRollOver");
		}
		
		_ref.back.onRollOut = function()
		{
			this._scope.broadcaster.broadcastMessage("onBackRollOut");
		}
		
		_ref.back.onPress = function()
		{
			if(this._scope.options.mode == 'vertical'){
				this._scope.shiftScroll(this._scope._ref.back._ymouse - this._scope._ref.nip._y);
			}
			if(this._scope.options.mode == 'horizontal'){
				this._scope.shiftScroll(this._scope._ref.back._xmouse - this._scope._ref.nip._x);
			}
		}
		
		_ref.nip._scope = this;
		
		
		_ref.nip.onRollOver = function()
		{
			this._scope.broadcaster.broadcastMessage("onNipRollOver");
		}
		
		_ref.nip.onRollOut = function()
		{
			this._scope.broadcaster.broadcastMessage("onNipRollOut");
		}
		
		
		_ref.nip.onPress = function()
		{
			var tObj = this._scope.getDragLimits();
			this.startDrag(false,tObj.left,tObj.top,tObj.right,tObj.bottom);
			
			this._scope.broadcaster.broadcastMessage("onNipPress");
			clearInterval(this._scope.scrollInterval);
			this._scope.scrollInterval = setInterval(this._scope,"processScroll",30);
		}
		
		//
		
		_ref.nip.onRelease = _ref.nip.onReleaseOutside = function()
		{
			this.stopDrag();
			this._scope.broadcaster.broadcastMessage("onNipRelease");
			clearInterval(this._scope.scrollInterval);
			
			//stop tracking
		}
		
		broadcaster._addListener(this);
	
	}
	
	public function shiftScroll(delta)
	{
		if(options.mode == 'vertical'){
			var tY = _ref.nip._y + delta;
			
			switch(true)
			{
				case (tY <= options.offsetH):
					_ref.nip._y = options.offsetH;
				break;
				
				case (tY >= options.barH - options.nipH - options.offsetH):
					_ref.nip._y = options.barH - options.nipH - options.offsetH;
				break;
				
				default:
					_ref.nip._y += delta;
				break;
			}
			
		}
		if(options.mode == 'horizontal'){
			var tX = _ref.nip._x + delta;
			
			switch(true)
			{
				case (tX <= options.offsetW):
					_ref.nip._x = options.offsetW;
				break;
				
				case (tX >= options.barW - options.nipW - options.offsetW):
					_ref.nip._x = options.barW - options.nipW - options.offsetW;
				break;
				
				default:
					_ref.nip._x += delta;
				break;
			}
			
		}
		
		processScroll();
	}
	
	public function setScroll(perc:Number)
	{	
		_ref.nip._y = Math.floor( (options.barH - options.nipH - (options.offsetH *2)) * perc ) + options.offsetH;
		processScroll();
	}
	
	public function setPercent(perc:Number)
	{
		lastPercent = perc;
		
	}
	
	public function onResize()
	{
		
	}
	
	public function onNipPress()
	{
		Utils.changeColor(_ref.nip,options.clr_hover);
	}
	
	public function onNipRelease()
	{
		Utils.changeColor(_ref.nip,options.clr_nip);
	}
	
	public function renderBar()
	{
		_ref.back.clear();
		Utils.drawRect(_ref.back,options.barW,options.barH,options.clr_bar,100);
	}
	
	public function renderNip()
	{
		_ref.nip.back.clear();
		Utils.drawRect(_ref.nip.back,options.nipW,options.nipH,options.clr_nip,100);
	}
	
	
	public function processScroll()
	{
		if(options.mode == "vertical"){
			var perc = (((_ref.nip._y - options.offsetH) / (options.barH-options.nipH - (options.offsetH * 2))) * 100);
		}
		if(options.mode == "horizontal"){
			var perc = (((_ref.nip._x) / (options.barW-options.nipW)) * 100);
		}
		
		var tObj = {};
		
		tObj.percent = perc;
		tObj.clip = _ref;
		tObj.x = _ref.nip._x;
		tObj.y = _ref.nip._y;
		
		broadcaster.broadcastMessage("onScroll",tObj);
		
		lastPercent = perc;
				
		return tObj;
		
	}
	
	public function setProp(name,value)
	{
		options[name] = value;
	}
	
	private function getDragLimits() : Object
	{
		var tObj = {};
		
		if(options.mode == "vertical"){
			tObj.left = 0;
			tObj.right = 0;
			tObj.top = 0;
			tObj.bottom = options.barH - options.nipH;
			if(options.offsetH){
				tObj.top = options.offsetH;
				tObj.bottom = options.barH - options.nipH - options.offsetH;
			}
			
		
		}
		if(options.mode == "horizontal"){
			tObj.left = 0;
			tObj.right = options.barW - options.nipW;
			tObj.top = 0;
			tObj.bottom = 0;
		}
		
		return tObj;
	}
	
	public function hide()
	{
			
	}
	
	public function show()
	{
		
		
	}
	
	
}