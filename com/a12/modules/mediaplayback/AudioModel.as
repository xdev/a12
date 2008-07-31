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
		
		private var _metaData:Object;
		
		private var _sound:Sound;
		private var _channel:SoundChannel;
		private	var	_volume:Number;
		private var _timer:Timer;
				
		private var _playing:Boolean;		
		private var _position:Number;
		private var _options:Object;
	
		public function AudioModel(_ref,_file,_options:Object=null)
		{
			this._ref = _ref;
			this._file = _file;
			this._options = _options;
			_metaData = {};
			_playing = false;
			_volume = 1.0;	
			playMedia();
		}
		
		// --------------------------------------------------------------------
		// Interface Methods
		// --------------------------------------------------------------------
		
		public function stopStream():void
		{
			_channel.stop();
			_position = 0;
			_channel = _sound.play(_position);	
			_playing = false;	
			_channel.stop();
			updateView();
		}
		
		public function playStream():void
		{
			_channel.stop();
			_channel = _sound.play(_position);
			_setVolume();
			_playing = true;
			updateView();
		}
		
		public function pauseStream():void
		{
			switch(true){
				case _playing == true:
					_position = _channel.position;
					_channel.stop();
					_playing = false;
				break;
			
				case _playing == false:
					_channel.stop();
					_channel = _sound.play(_position);
					_playing = true;
					_setVolume();
				break;
			}
			updateView();
		}
		
		public function toggleStream():void
		{
			pauseStream();
		}
			
		public function seekStream(time:Number):void
		{
			_channel.stop();
			_channel = _sound.play(time);
			_position = time;
			_setVolume();
			_playing = true;
		}
	
		public function seekStreamPercent(percent:Number):void
		{
			seekStream(percent * _sound.length);
		}
		
		public function toggleAudio():void
		{
			
		}
		
		public function setVolume(value:Number):void
		{
			_volume = value;
			_setVolume();
		}
		
		public function setBuffer(value:Number):void
		{
			
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
			_channel.stop();
			_channel = null;
			_sound = null;
			_playing = false;
			_timer.stop();
			_timer = null;
		}
		
		// --------------------------------------------------------------------
		// Class Methods
		// --------------------------------------------------------------------
		private function _setVolume()
		{
			var transform:SoundTransform = new SoundTransform();
			transform.volume = _volume;
			_channel.soundTransform = transform;
		}
		
		private function streamStatus(obj):void
		{
			trace(obj.code);
		}
			
		private function playMedia():void
		{
			_metaData = {};		
		
			var tObj = {};		
			Utils.createmc(_ref,"audio",20001);
		
			_sound = new Sound();
			var req:URLRequest = new URLRequest(_file);
			//true
			
			_sound.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_sound.addEventListener(Event.COMPLETE, onComplete);
			_sound.addEventListener(Event.ID3, id3Handler);
			
			/*
			new SoundLoaderContext(_bufferTime,true)
			*/
			
			_sound.load(req);
			
			_timer = new Timer(20);
			_timer.addEventListener(TimerEvent.TIMER, updateView);
			_timer.start();
			
			_channel = _sound.play();
			_playing = true;
			
			setChanged();
			notifyObservers(tObj);
		}
	
		private function onComplete(e:Event):void
		{
			var tObj = {};
			tObj.action = 'mediaComplete';
			setChanged();
			notifyObservers(tObj);
		}
	
		private function onLoad(e:Event):void
		{
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
	
		private function updateView(e:TimerEvent=null):void
		{
			var tObj = {};
		
			tObj.action = "updateView";
			tObj.time_current = Utils.convertSeconds(Math.floor(_channel.position/1000));
			tObj.time_duration = Utils.convertSeconds(Math.floor(_sound.length/1000));
			tObj.time_remaining = Utils.convertSeconds(Math.floor(_sound.length/1000) - Math.floor(_channel.position/1000));
			tObj.time_percent = Math.floor(((_channel.position/1000) / Math.floor(_sound.length/1000)) * 100);
			tObj.loaded_percent = Math.floor((_sound.bytesLoaded / _sound.bytesTotal) * 100);
			tObj.playing = _playing;
				
			setChanged();
			notifyObservers(tObj);			
		
		}
	
	}

}