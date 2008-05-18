/* $Id$ */

package com.a12.modules.mediaplayback
{

	import flash.display.MovieClip;
	import flash.utils.*;
	import flash.events.*;
    import flash.media.*;
    import flash.net.NetConnection;
    import flash.net.NetStream;
	import com.a12.pattern.observer.Observable;
	import com.a12.modules.mediaplayback.*;
	import com.a12.util.*;

	public class VideoModel extends Observable implements IMediaModel
	{
	
		private var _ref:MovieClip;
		private var _file:String;
		private var _stream:NetStream;
		private var _connection:NetConnection;
		private var _timer:Timer;
		private var _metaData:Object;		
		private var _playing:Boolean;
	
		public function VideoModel(_ref,_file)
		{
			this._ref = _ref;
			this._file = _file;
			_metaData = {};
			_playing = false;
			
			_connection = new NetConnection();
			_connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            _connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_connection.connect(null);			
		}
		
		// --------------------------------------------------------------------
		// Interface Methods
		// --------------------------------------------------------------------
		
		public function stopStream():void
		{
			pauseStream();
			seekStream(0);
			_playing = false;
		}
		
		public function playStream():void
		{
			_stream.resume();
			_playing = true;
		}		
	
		public function pauseStream():void
		{
			_stream.pause();
			_playing = false;
		}
		
		public function toggleStream():void
		{
			_playing = !_playing;
			_stream.togglePause();
		}	
		
		public function streamStatus(obj):void
		{
			if(obj.code == "NetStream.Play.Stop"){
				onComplete();
			}
		}
	
		public function seekStream(time:Number):void
		{
			_stream.seek(time);
			_playing = true;
		}
	
		public function seekStreamPercent(percent:Number):void
		{
			seekStream(percent * _metaData.duration);
		}
		
		public function toggleAudio():void
		{
			
		}
		
		public function setVolume(value:Number):void
		{
			var transform:SoundTransform = new SoundTransform();
			transform.volume = value;
			_stream.soundTransform = transform;
		}
		
		public function getRef():MovieClip
		{
			return _ref;
		}
	
		public function getPlaying():Boolean
		{
			return _playing;
		}
	
		public function kill():void
		{
			_stream.close();
			_stream = null;
			_connection = null;
			_playing = false;
			_timer.stop();
			_timer = null;
		}
		
		// --------------------------------------------------------------------
		// Class Methods
		// --------------------------------------------------------------------
		
		private function cuePointHandler(obj:Object):void
		{
			
		}
		
		private function onMetaData(obj:Object):void
		{
			//should run only once!
			if(obj.width && _metaData.width == undefined){
				var tObj = {};
				tObj.action = 'updateSize';
				tObj.width =  obj.width;
				tObj.height = obj.height;
					
				Utils.$(_ref,'myvideo').width = obj.width;
				Utils.$(_ref,'myvideo').height = obj.height;
		
				setChanged();
				notifyObservers(tObj);
			}
		
			for(var i in obj){
				_metaData[i] = obj[i];			
				if(i == 'duration'){
					_metaData.durationObj = Utils.convertSeconds(Math.floor(obj[i]));
				}
			}
		}
		
		private function netStatusHandler(event:NetStatusEvent):void
		{
			switch (event.info.code) {
				case "NetConnection.Connect.Success":
					playMedia();
					break;
				case "NetStream.Play.StreamNotFound":
					//trace("Unable to locate video: " + videoURL);
					break;
			}
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
            trace("securityErrorHandler: " + event);
        }

        private function asyncErrorHandler(event:AsyncErrorEvent):void {
            // ignore AsyncErrorEvent events.
        }

		private function connectStream():void
		{
			
		}
	
		private function playMedia():void
		{
			_stream = new NetStream(_connection);
			_stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            _stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			
			var clientObj = {};
			clientObj.onMetaData = onMetaData;
			clientObj.onCuePoint = cuePointHandler;
			_stream.client = clientObj;
			
			_stream.play(_file);		
			
			_playing = true;	
					
			_timer = new Timer(200);
			_timer.addEventListener(TimerEvent.TIMER, updateView);
			_timer.start();
				
			var tObj = {};
			tObj.stream = _stream;			
			tObj.playing = _playing;
									
			var video:Video = new Video();
			video.attachNetStream(_stream);
			var v = _ref.addChild(video);
			v.name = 'myvideo';
			
			setChanged();
			notifyObservers(tObj);
			
		}
	
		private function updateView(e:TimerEvent=null):void
		{
			//convert time in seconds to 00:00
			var tObj = {};
		
			tObj.action = "updateView";
			tObj.time_current = Utils.convertSeconds(Math.floor(_stream.time));
			if(_metaData.durationObj != undefined){
				tObj.time_duration = _metaData.durationObj;
				tObj.time_percent = Math.floor((_stream.time / _metaData.duration) * 100);
				tObj.time_remaining = Utils.convertSeconds(_metaData.duration - Math.floor(_stream.time));
				//this is specifically for flv files encoded in 3rd party tools that do not produce the 
				//Netstream.Play.Stop command
				//Need to add another condition that checks the playstate			
			
				if(Math.ceil(_stream.time) == Math.ceil(_metaData.duration)){
					//onComplete();
				}
			}
		
			tObj.loaded_percent = Math.floor((_stream.bytesLoaded / _stream.bytesTotal) * 100);		
			tObj.playing = _playing;
			
			setChanged();
			notifyObservers(tObj);
		}
	
		private function onComplete():void
		{
			var tObj = {};
			tObj.action = 'mediaComplete';
			setChanged();
			notifyObservers(tObj);
		}
	
	}

}