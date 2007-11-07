import com.a12.pattern.observer.Observable;

import com.a12.modules.mediaplayback.*;

import com.a12.util.*;

class com.a12.modules.mediaplayback.AudioModel extends Observable
{
	
	private	var	_ref			: MovieClip;
	private	var	_file			: String;
	private	var	stream_ns		: NetStream;
	private	var	connection_nc	: NetConnection;
	private	var	streamInterval	: Number;
	private	var	loadInterval	: Number;
	private	var metaData		: Object;
	private	var soundController	: Sound;
	private	var	mode			: String;
	private	var	position		: Number;
	
	public function AudioModel(ref,file)
	{
		_ref = ref;
		_file = file;
		playMedia();

	}
	
	
	public function getRef() : MovieClip
	{
		return _ref;
	}
	
	public function kill()
	{
		soundController.stop();
		delete soundController;
		Utils.createmc(_ref,"audio",20001);
		clearInterval(streamInterval);
	}
	
	
	private function playMedia()
	{
		
		
		mode = 'play';
		
		metaData = {};
		
		
		
		clearInterval(streamInterval);
		streamInterval = setInterval(this,"getStreamInfo",200);
		
		clearInterval(loadInterval);
		//loadInterval = setInterval(this,"renderLoading",30);
		
		
		var tObj = {};
		tObj.mode = mode;
		
		Utils.createmc(_ref,"audio",20001);
		
		
		soundController = new Sound();
		soundController.loadSound(_file,true);
		var _scope = this;		
		soundController.onSoundComplete = function()
		{
			_scope.onComplete();
		};
		
		setChanged();
		notifyObservers(tObj);
	}
	
	private function onComplete()
	{
		trace('COMPLETE' + newline + newline);
		var tObj = {};
		tObj.action = 'mediaComplete';
		setChanged();
		notifyObservers(tObj);
		delete tObj;
	}
	
	private function getStreamInfo()
	{
		//convert time in seconds to 00:00
		var tObj = {};
		
		tObj.action = "updateView";
		
		tObj.time_current = Utils.convertSeconds(Math.floor(soundController.position/1000));
		
			tObj.time_duration = Utils.convertSeconds(Math.floor(soundController.duration/1000));
			tObj.time_percent = Math.floor(((soundController.position/1000) / Math.floor(soundController.duration/1000)) * 100);
		
		
		tObj.loaded_percent = Math.floor((soundController.getBytesLoaded() / soundController.getBytesTotal()) * 100);

		
		setChanged();
		notifyObservers(tObj);
		
		delete tObj;
		
		
	}
	
	
	public function streamStatus(obj)
	{
		trace(obj.code);
	}
	
	public function seekStream(time:Number)
	{
		soundController.start(time);
	}
	
	public function seekStreamPercent(percent:Number)
	{
		seekStream(Math.round(percent * (soundController.duration/1000)) );
	}
	
	public function playStream()
	{
		soundController.start(0);
	}
	
	public function pauseStream()
	{
		var icon = '';
		switch(true){
			case mode == 'play':
				position = soundController.position;
				soundController.stop();
				icon = 'play';
				mode = 'pause';
			break;
			
			case mode == 'pause':
				mode = 'play';
				icon = 'pause';
				soundController.start(Math.floor(position/1000));
			break;
		}
		
		var tObj = {};
		tObj.mode = mode;
		tObj.icon = icon;
		
		setChanged();
		notifyObservers(tObj);
	}
	
	public function stopStream()
	{
		soundController.stop();
	}
	
	
	
}