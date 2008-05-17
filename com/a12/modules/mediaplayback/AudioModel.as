/* $Id$ */

package com.a12.modules.mediaplayback
{
	
	import flash.display.MovieClip;
	import flash.utils.*;
	import flash.net.*;
	import flash.media.*;
	import flash.events.*;

	import com.a12.pattern.observer.Observable;
	import com.a12.modules.mediaplayback.*;
	import com.a12.util.*;

	public class AudioModel extends Observable implements IMediaModel
	{
	
		private var _ref:MovieClip;
		private var _file:String;
		
		private var streamInterval:Number;
		private var loadInterval:Number;
		private var metaData:Object;
		
		private var soundObj:Sound;
		private var soundChannel:SoundChannel;
		private	var	soundVolume:Number;
		private var positionTimer:Timer;
		private var mode:String;
		private var position:Number;
	
		public function AudioModel(ref,file)
		{
			_ref = ref;
			_file = file;
			soundVolume = 1.0;
			playMedia();
		}
		
		// --------------------------------------------------------------------
		// Interface Methods
		// --------------------------------------------------------------------
		
		public function stopStream():void
		{
			soundChannel.stop();
		}
		
		public function playStream():void
		{
			soundChannel.stop();
			soundChannel = soundObj.play(position);
			_setVolume();
		}
		
		public function pauseStream():void
		{
			var icon = '';
			switch(true){
				case mode == 'play':
					position = soundChannel.position;
					soundChannel.stop();
					icon = 'play';
					mode = 'pause';
				break;
			
				case mode == 'pause':
					mode = 'play';
					icon = 'pause';
					soundChannel.stop();
					soundChannel = soundObj.play(position);
					_setVolume();
				break;
			}
		
			var tObj = {};
			tObj.mode = mode;
			tObj.icon = icon;
		
			setChanged();
			notifyObservers(tObj);
		}
		
		public function toggleStream():void
		{
			pauseStream();
		}
			
		public function seekStream(time:Number):void
		{
			soundChannel.stop();
			soundChannel = soundObj.play(time);
			_setVolume();
		}
	
		public function seekStreamPercent(percent:Number):void
		{
			seekStream(percent * soundObj.length);
		}
		
		public function toggleAudio():void
		{
			
		}
		
		public function setVolume(value:Number):void
		{
			soundVolume = value;
			_setVolume();
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
			soundChannel.stop();
			soundChannel = null;
			soundObj = null;
			//delete soundObj;
			//Utils.createmc(_ref,"audio",20001);
			clearInterval(streamInterval);
		}
		
		// --------------------------------------------------------------------
		// Class Methods
		// --------------------------------------------------------------------
		private function _setVolume()
		{
			var transform:SoundTransform = new SoundTransform();
			transform.volume = soundVolume;
			soundChannel.soundTransform = transform;
		}
		
		private function streamStatus(obj):void
		{
			trace(obj.code);
		}
			
		private function playMedia():void
		{
			mode = 'play';
		
			metaData = {};
				
			//clearInterval(streamInterval);
			//streamInterval = setInterval(getStreamInfo,200);
		
			clearInterval(loadInterval);
			//loadInterval = setInterval(this,"renderLoading",30);
		
		
			var tObj = {};
			tObj.mode = mode;
		
			Utils.createmc(_ref,"audio",20001);
		
			soundObj = new Sound();
			var req:URLRequest = new URLRequest(_file);
			//true
			
			soundObj.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			soundObj.addEventListener(Event.COMPLETE, onComplete);
			soundObj.addEventListener(Event.ID3, id3Handler);
			soundObj.load(req);
			
			positionTimer = new Timer(200);
			positionTimer.addEventListener(TimerEvent.TIMER, getStreamInfo);
			positionTimer.start();
			
			soundChannel = soundObj.play();
			
			setChanged();
			notifyObservers(tObj);
		}
	
		private function onComplete(e:Event):void
		{
			trace('COMPLETE');
			var tObj = {};
			tObj.action = 'mediaComplete';
			setChanged();
			notifyObservers(tObj);
		}
	
		private function onLoad(e:Event):void
		{
			trace('onLoad');
			var tObj = {};
			tObj.action = 'onLoad';
			setChanged();
			notifyObservers(tObj);
		}
		
		private function progressHandler(e:Event):void
		{
			
		}
		
		private function id3Handler(e:Event):void
		{
			
		}
	
		private function getStreamInfo(e:TimerEvent):void
		{
			//convert time in seconds to 00:00
			var tObj = {};
		
			tObj.action = "updateView";
		
			tObj.time_current = Utils.convertSeconds(Math.floor(soundChannel.position/1000));
			tObj.time_duration = Utils.convertSeconds(Math.floor(soundObj.length/1000));
			tObj.time_remaining = Utils.convertSeconds(Math.floor(soundObj.length/1000) - Math.floor(soundChannel.position/1000));
			tObj.time_percent = Math.floor(((soundChannel.position/1000) / Math.floor(soundObj.length/1000)) * 100);
			tObj.loaded_percent = Math.floor((soundObj.bytesLoaded / soundObj.bytesTotal) * 100);
				
			setChanged();
			notifyObservers(tObj);			
		
		}
	
	}

}