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

	public class AudioModel extends Observable
	{
	
		private	var	_ref			: MovieClip;
		private	var	_file			: String;
		private	var	stream_ns		: NetStream;
		private	var	connection_nc	: NetConnection;
		private	var	streamInterval	: Number;
		private	var	loadInterval	: Number;
		private	var metaData		: Object;
		private	var soundController	: Sound;
		private	var soundChannel	: SoundChannel;
		private	var positionTimer	: Timer;
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
			soundChannel.stop();
			//delete soundController;
			Utils.createmc(_ref,"audio",20001);
			clearInterval(streamInterval);
		}
	
		public function getMode() : String
		{
			return mode;
		}
	
	
		private function playMedia()
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
		
			soundController = new Sound();
			var req:URLRequest = new URLRequest(_file);
			//true
			//soundController.play();
			soundController.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			soundController.addEventListener(Event.COMPLETE, onComplete);
			soundController.addEventListener(Event.ID3, id3Handler);
			soundController.load(req);
			
			positionTimer = new Timer(50);
			positionTimer.addEventListener(TimerEvent.TIMER, getStreamInfo);
			positionTimer.start();
			
			soundChannel = soundController.play();
			/*
			soundController.loadSound(_file,true);
			soundController.onSoundComplete = Delegate.create(this, onComplete);
			soundController.onLoad = Delegate.create(this, onLoad);
			*/
		
			setChanged();
			notifyObservers(tObj);
		}
	
		private function onComplete(e:Event) : void
		{
			trace('COMPLETE');
			var tObj = {};
			tObj.action = 'mediaComplete';
			setChanged();
			notifyObservers(tObj);
		}
	
		private function onLoad(e:Event) : void
		{
			trace('onLoad');
			var tObj = {};
			tObj.action = 'onLoad';
			setChanged();
			notifyObservers(tObj);
		}
		
		private function progressHandler(e:Event)
		{
			
		}
		
		private function id3Handler(e:Event)
		{
			
		}
	
		private function getStreamInfo(e:TimerEvent)
		{
			//convert time in seconds to 00:00
			var tObj = {};
		
			tObj.action = "updateView";
		
//			tObj.time_current = Utils.convertSeconds(Math.floor(shoundChannel.position/1000));
//			tObj.time_duration = Utils.convertSeconds(Math.floor(soundController.length/1000));
//			tObj.time_percent = Math.floor(((shoundChannel.position/1000) / Math.floor(soundController.duration/1000)) * 100);
			tObj.loaded_percent = Math.floor((soundController.bytesLoaded / soundController.bytesTotal) * 100);
				
			setChanged();
			notifyObservers(tObj);
		
			tObj = null;
		
		}
	
	
		public function streamStatus(obj)
		{
			trace(obj.code);
		}
	
		public function seekStream(time:Number)
		{
			soundController.play(time);
		}
	
		public function seekStreamPercent(percent:Number)
		{
			seekStream(Math.round(percent * (soundController.length/1000)) );
		}
	
		public function playStream()
		{
			soundController.play(0);
		}
	
		public function pauseStream()
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
					soundController.play(Math.floor(position/1000));
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
			soundChannel.stop();
		}
	
	
	
	}

}