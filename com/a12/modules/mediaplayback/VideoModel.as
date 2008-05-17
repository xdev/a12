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
		private var stream_ns:NetStream;
		private var connection_nc:NetConnection;
		private var streamInterval:Number;
		private var metaData:Object;		
		private var mode:String;
	
		public function VideoModel(_ref,_file)
		{
			this._ref = _ref;
			this._file = _file;
			metaData = {};
			
			connection_nc = new NetConnection();
			connection_nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            connection_nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			connection_nc.connect(null);			
		}
		
		// --------------------------------------------------------------------
		// Interface Methods
		// --------------------------------------------------------------------
		
		public function stopStream():void
		{
			stream_ns.close();
		}
		
		public function playStream():void
		{
			stream_ns.resume();
			mode = 'pause';
			changeStatus();
		}		
	
		public function pauseStream():void
		{
			stream_ns.pause();
			mode = 'play';
			changeStatus();
		}
		
		public function toggleStream():void
		{
			stream_ns.togglePause();
			changeStatus();
		}	
		
		public function streamStatus(obj):void
		{
			if(obj.code == "NetStream.Play.Stop"){
				onComplete();
			}
		}
	
		public function seekStream(time:Number):void
		{
			stream_ns.seek(time);
		}
	
		public function seekStreamPercent(percent:Number):void
		{
			seekStream(Math.round(percent * metaData.duration) );
		}
		
		public function toggleAudio():void
		{
			
		}
		
		public function setVolume(value:Number):void
		{
			var transform:SoundTransform = new SoundTransform();
			transform.volume = value;
			stream_ns.soundTransform = transform;
		}
		
		public function getRef():MovieClip
		{
			return _ref;
		}
	
		public function getMode():String
		{
			return mode;
		}
	
		public function kill():void
		{
			stream_ns.close();
			stream_ns = null;
			connection_nc = null;
			//soundController = null;
			clearInterval(streamInterval);
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
			if(obj.width && metaData.width == undefined){
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
				metaData[i] = obj[i];			
				if(i == 'duration'){
					metaData.durationObj = Utils.convertSeconds(Math.floor(obj[i]));
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
			stream_ns = new NetStream(connection_nc);
			stream_ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            stream_ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			
			var clientObj = {};
			clientObj.onMetaData = onMetaData;
			clientObj.onCuePoint = cuePointHandler;
			stream_ns.client = clientObj;
			
			stream_ns.play(_file);		
			
			mode = 'play';	
		
			clearInterval(streamInterval);
			streamInterval = setInterval(getStreamInfo,200);
				
			var tObj = {};
			tObj.stream = stream_ns;
			tObj.mode = mode;
		
			//var a = Utils.createmc(_ref,"audio");
		
			//soundController = new Sound(a);
			//a.attachAudio(stream_ns);
						
			var video:Video = new Video();
			video.attachNetStream(stream_ns);
			var v = _ref.addChild(video);
			v.name = 'myvideo';
			
			setChanged();
			notifyObservers(tObj);
			
		}
	
		private function getStreamInfo():void
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
		}
	
		private function onComplete():void
		{
			var tObj = {};
			tObj.action = 'mediaComplete';
			setChanged();
			notifyObservers(tObj);
		}
	
		private function changeStatus():void
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
	
	}

}