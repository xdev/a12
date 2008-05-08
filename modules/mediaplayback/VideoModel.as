import com.a12.pattern.observer.Observable;
import com.a12.modules.mediaplayback.*;
import com.a12.util.*;

import mx.utils.Delegate;

class com.a12.modules.mediaplayback.VideoModel extends Observable
{
	
	private	var	_ref			: MovieClip;
	private	var	_file			: String;
	private	var	stream_ns		: NetStream;
	private	var	connection_nc	: NetConnection;
	private	var	streamInterval	: Number;
	private	var metaData		: Object;
	private	var soundController	: Sound;
	private	var	mode			: String;
	
	public function VideoModel(ref,file)
	{
		_ref = ref;
		_file = file;
		metaData = {};
		playMedia();
	}
	
	
	
	public function getRef() : MovieClip
	{
		return _ref;
	}
	
	public function getMode() : String
	{
		return mode;
	}
	
	public function kill()
	{
		stream_ns.close();
		delete stream_ns;
		delete connection_nc;
		delete soundController;
		clearInterval(streamInterval);
	}
	
	private function onMetaData(obj)
	{
		//should run only once!
		if(obj.width && metaData.width == undefined){
			var tObj = {};
			tObj.action = 'updateSize';
			tObj.width =  obj.width;
			tObj.height = obj.height;
					
			_ref.video.myvideo._width = obj.width;
			_ref.video.myvideo._height = obj.height;
		
			setChanged();
			notifyObservers(tObj);
		}
		
		for(var i in obj){
			metaData[i] = obj[i];			
			if(i == 'duration'){
				metaData.durationObj = Utils.convertSeconds(Math.floor(obj[i]));
			}
		}
		
		
	}
	
	private function playMedia()
	{
		trace('playMedia-' + _file);
		
		connection_nc = new NetConnection();
		connection_nc.connect(null);
		
		stream_ns = new NetStream(connection_nc);
		stream_ns.play(_file);
		stream_ns.onStatus = Delegate.create(this, streamStatus);
		stream_ns.onMetaData = Delegate.create(this, onMetaData);
		
		mode = 'play';	
		
		clearInterval(streamInterval);
		streamInterval = setInterval(this,"getStreamInfo",500);
				
		var tObj = {};
		tObj.stream = stream_ns;
		tObj.mode = mode;
		
		Utils.createmc(_ref,"audio",20001);
		
		soundController = new Sound(_ref.audio);
		_ref.audio.attachAudio(stream_ns);
		
		_ref.attachMovie("video","video",1);
		_ref.video.myvideo.attachVideo(stream_ns);
						
		setChanged();
		notifyObservers(tObj);
		
		delete tObj;		
		
	}
	
	
	
	private function getStreamInfo()
	{
		//convert time in seconds to 00:00
		var tObj = {};
		
		tObj.action = "updateView";
		
		tObj.time_current = Utils.convertSeconds(Math.floor(stream_ns.time));
		if(metaData.durationObj != undefined){
			tObj.time_duration = metaData.durationObj;
			tObj.time_percent = Math.floor((stream_ns.time / metaData.duration) * 100);
			tObj.time_remaining = Utils.convertSeconds(metaData.duration - Math.floor(stream_ns.time));
			//this is specifically for flv files encoded in 3rd party tools that do not produce the 
			//Netstream.Play.Stop command
			//Need to add another condition that checks the playstate			
			
			if(Math.ceil(stream_ns.time) == Math.ceil(metaData.duration)){
				//onComplete();
			}
		}
		
		tObj.loaded_percent = Math.floor((stream_ns.bytesLoaded / stream_ns.bytesTotal) * 100);		
		
		setChanged();
		notifyObservers(tObj);
		
		delete tObj;
		
	}
	
	private function onComplete()
	{
		var tObj = {};
		tObj.action = 'mediaComplete';
		setChanged();
		notifyObservers(tObj);
		delete tObj;
	}
	
	public function streamStatus(obj)
	{
		//trace('i has status ' + obj.code);
		if(obj.code == "NetStream.Play.Stop"){
			onComplete();
		}
	}
	
	public function seekStream(time:Number)
	{
		stream_ns.seek(time);
	}
	
	public function seekStreamPercent(percent:Number)
	{
		seekStream(Math.round(percent * metaData.duration) );
	}
	
	public function playStream()
	{
		stream_ns.pause(false);
		mode = 'pause';
		changeStatus();
	}
	
	private function changeStatus()
	{
		
		var icon = '';
		switch(true){
			case mode == 'play':
				mode = 'pause';
				icon = 'play';
			break;
			
			case mode == 'pause':
				mode = 'play';
				icon = 'pause';
			break;
		}
		
		var tObj = {};
		tObj.mode = mode;
		tObj.icon = icon;
		
		setChanged();
		notifyObservers(tObj);
		
		
	}
	
	public function toggleStream()
	{
		stream_ns.pause();
		changeStatus();
		
	}
	
	public function pauseStream()
	{
		stream_ns.pause(true);
		mode = 'play';
		changeStatus();
	}
	
	public function stopStream()
	{
		stream_ns.close();
	}
	
}