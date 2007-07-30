import AsBroadcaster;

class com.a12.util.PreLoader
{
	
	private var _mcArray			: Array;
	private	var _callback			: Object;
	private	var _obj				: Object;
	private	var _args				: Array;
	private	var _myBroadcaster		: Object;
	private	var _intID				: Number;
	private	var _percent			: Number;
	
	/*
	 * Updates:
	 * - 5.25.07
	 *		- Self terminates if movieclips no longer exist
	 *		- Added 'onKill' event
	 *		- Added 'onStart' event
	 * - 4.25.07 
	 *		- Added ability to pass either a MovieClip or an array of MovieClips 
	 *		- Added 'preload' method which allows the ability to create the object and execute the preload independently if desired.
	 *		  (e.g. preferred process: 1.create instance, 2.addlisteners/callback handlers, and then 3.initiate preload)
	 *		  otherwise if the images load too fast the process completes before the listeners/callback handlers even get assigned
	 *		
	 * Notes: 
	 * 		- Do not datatype 'mc' as either MovieClip or Array. It should be allowed to be either for backwards compatibility.
	 * 		- Should add a timeout feature that checks for progress periodically... if no progress is being made call a 'timeout'
	 *		  handler and self terminate
	 */
	
	public function PreLoader(mc, callback, obj, args)
	{
		//trace("--Preloader:Preloader");
		
		_myBroadcaster = new Object();
		AsBroadcaster.initialize(_myBroadcaster);
		
		if (mc) {
			preload(mc, callback, obj, args);
		}
		
	}
	
	public function preload(mc, callback, obj, args) : Void
	{
		//trace("--Preloader:preload");
		
		if (mc instanceof Array) {
			//trace("isArray");
			_mcArray = mc;
		} else if (mc instanceof MovieClip) {
			//trace("isMovieClip");
			_mcArray = [mc];
		}
		
		_callback = callback;
		_args = args;
		_obj = obj;
		
		_myBroadcaster.broadcastMessage("onStart");
		
		clearInterval(_intID);
		_intID = setInterval(this, "calculate", 15);
	}
	
	public function _addListener(obj) : Void
	{
		//trace("--Preloader:_addListener");
		_myBroadcaster.addListener(obj);
	}
	
	public function _removeListener(obj) 
	{
		//trace("--Preloader:_removeListener");
		_myBroadcaster.removeListener(obj);
	}
	
	public function addItems(mc) : Void
	{
		trace("--Preloader:addItems");
		
		if (mc instanceof Array) {
			//trace("isArray");
			_mcArray.push(mc);
		} else if (mc instanceof MovieClip) {
			//trace("isMovieClip");
			for (var i in mc) {
				_mcArray.push(mc[i]);
			}
		}
	}
	
	public function kill() : Void
	{
		//trace("--Preloader:kill: id=" + _intID);
		clearInterval(_intID);
		delete this;
	}
	
	private function calculate() : Void
	{	
		//trace('--Preloader:calculate: id=' + _intID);
		var bytesLoaded = 0;
		var bytesTotal = 0;
		var wCheck = true;
		var eCheck = false; // <-- false means that movieclips are undefined
		
		for (var i in _mcArray) {
			bytesLoaded += _mcArray[i].getBytesLoaded();
			bytesTotal += _mcArray[i].getBytesTotal();
			
			// check width <-- sometimes would pass through preload without registering width
			if (_mcArray[i]._width == undefined || _mcArray[i]._width == 0) {
				wCheck = false;
			}
			
			// check if mc items still exists <-- terminates the preload process if all of the movieclips no longer exist
			if (_mcArray[i]._name != undefined) {
				eCheck = true;
			}
		}
		
		var _percent = Math.floor(100 * (bytesLoaded / bytesTotal));
		_myBroadcaster.broadcastMessage("onPercent", _percent);
		
		if(_percent == 100 && wCheck == true) {
			finish();
		} else if (eCheck == false) {
			_myBroadcaster.broadcastMessage("onKill");
			kill();
		}
	
	}
	
	private function finish() : Void
	{
		//trace('--Preloader:finish: id=' + _intID);
		clearInterval(_intID);
		_callback.apply(_obj, _args);
		_myBroadcaster.broadcastMessage("onLoad");
		
		kill();
	}
	
}