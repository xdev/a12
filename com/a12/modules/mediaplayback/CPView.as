/* $Id$ */

package com.a12.modules.mediaplayback
{
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import com.a12.pattern.observer.*;
	import com.a12.pattern.mvc.*;
	import com.a12.modules.mediaplayback.*;

	import com.a12.util.CustomEvent;
	import com.a12.util.Utils;
	import com.a12.util.LoadMovie;
	
	import com.gs.TweenLite;

	public class CPView extends AbstractView
	{

		public var ref:MovieClip;
		public var height:Number;
		public var width:Number;
		
		protected var _controller:CPController;
		protected var _model:Object;
		
		protected var _originalSize:Object;
		public var _controls:MovieClip;
		
		protected var _timer:Timer;
		protected var _timeMode:Boolean;
		protected var _soundLevel:Number;
		protected var _soundLevelA:Array;
		protected var _scrubberWidth:Number;
		
		protected var _options:Object;

		public function CPView(m:Observable,c:Controller,options:Object)
		{
			
			super(m,c);
			
			_options = options;
			
			width = 640;
			height = 360;
			
			_originalSize = {};
			_originalSize.width = width;
			_originalSize.height = height;
			
			
			_timeMode = true;
			_soundLevelA = [0.0,0.3,0.6,1.0];
			_soundLevel = 3;
			_scrubberWidth = 8;
			
			_model = getModel();
			_controller = CPController(getController());
			
			ref = _model.getRef();			
			
			if(_model as AudioModel){
				renderUI();
			}
					
		}
		
		public function setScale(value:Number):void
		{
			//find height and width based upon scale
			var tW,tH;
			
			if(value<100){
				tW = ((value/100) * _originalSize.width);
				tH = ((value/100) * _originalSize.height);				
			}else{
				tW = _originalSize.width;
				tH = _originalSize.height;
			}		
			
			height = tH;
			width = tW;
			layoutUI();
			//updateSize({width:tW,height:tH});
		}
		
		public function setWidth(value:Number):void
		{
			width = value;
			layoutUI();
		}

		public function getDimensions(mode:Boolean):Object
		{
			if(mode == false){
				return {height:height,width:width};
			}else{
				return {height:_originalSize.height,width:_originalSize.width};
			}
		}
	
	
		public override function defaultController(m:Observable):Controller
		{
			return new CPController(m);
		}
		
		public override function update(o:Observable, infoObj:Object):void
		{	
			var mc;
			if(infoObj.stream != undefined){
			
			
			}
			
			if(infoObj.action == 'updateSize'){
				
				//
				if(_model as VideoModel){
					//create cover to register clicks!
					
					//optionally
						mc = Utils.createmc(ref,'cover',{buttonMode:true,mouseEnabled:true});
						Utils.drawRect(mc,infoObj.width,infoObj.height,0xFF0000,0.0);
						mc.addEventListener(MouseEvent.CLICK,mouseHandler);
					
					var i = new mediaplayback_icons();
					i.gotoAndStop('video_overlay_play');
					mc = ref.addChild(i);					
					mc.alpha = 0.0;
					mc.name = 'video_overlay_play';
					mc.buttonMode = true;
					mc.x = infoObj.width/2;
					mc.y = infoObj.height/2;
					//mc.addEventListener(MouseEvent.ROLL_OVER,mouseHandler);
					//mc.addEventListener(MouseEvent.ROLL_OUT,mouseHandler);
					
				}
				
				_originalSize = {};
				_originalSize.width = infoObj.width;
				_originalSize.height = infoObj.height;				
				updateSize(infoObj);
			}
			
			if(infoObj.action == 'updateView'){
				updateView(infoObj);
			}
			if(infoObj.action == 'mediaComplete'){
				trace('local stop, needs to not stop if playback has never begun');
				_controller.stop();			
			}
			
			dispatchEvent(new CustomEvent(infoObj.action,true,false,infoObj));
			
		}
		
		protected function updateSize(infoObj:Object):void
		{
			width = infoObj.width;
			height = infoObj.height;			
			renderUI();
		}	
		
		private function toggleTime():void
		{
			_timeMode = !_timeMode;
		}
		
		private function toggleAudio():void
		{
			if(_soundLevel < _soundLevelA.length){
				_soundLevel++;
			}
			if(_soundLevel == _soundLevelA.length){
				_soundLevel = 0;
			}
			
			//set the audio icon position
			var mc = Utils.$(_controls,'audio');
			mc.gotoAndStop('audio'+_soundLevel);
			//controller setVolume
			_controller.setVolume(_soundLevelA[_soundLevel]);
		}
		
		protected function updateView(infoObj:Object):void
		{
			//check the mode for display
			var txt:String = '';
			
			switch(_timeMode)
			{
				case true:
					txt = '-' + Utils.padZero(infoObj.time_remaining.minutes) + ':' + Utils.padZero(Math.ceil(infoObj.time_remaining.seconds));
				break;
				
				case false:
					txt = Utils.padZero(infoObj.time_current.minutes) + ':' + Utils.padZero(infoObj.time_current.seconds);
				break;
				/*
				case 'progress':
					txt = Utils.padZero(infoObj.time_current.minutes) + ':' + Utils.padZero(infoObj.time_current.seconds) + '/';
					txt += Utils.padZero(infoObj.time_duration.minutes) + ':' + Utils.padZero(infoObj.time_duration.seconds);
				break;
				*/
			}
			
			var l = Utils.$(_controls,'label');
			var tf = Utils.$(l,'displayText');
			tf.text = txt;
					
			var factor:Number = (width-95) / 100;
			
			var mc;
				
			//if dragging false
			if(infoObj.time_percent != undefined){
				mc = Utils.$(Utils.$(_controls,'timeline'),'scrubber');
				if(mc.dragging == false){
					mc.x = infoObj.time_percent * ((width-95)-_scrubberWidth) / 100;
				}
			}
			
			mc = Utils.$(_controls,'video_play');
			if(infoObj.playing){
				mc.gotoAndStop('video_pause');
				mc = Utils.$(ref,'video_overlay_play');
				if(mc != null){
					mc.alpha = 0.0;
					mc.removeEventListener(MouseEvent.CLICK,mouseHandler);
					mc.buttonMode = false;
					mc.mouseEnabled = false;
				}
			}else{
				
				//fade in the video bizzzle
				//Move.changeProps(MovieClip(Utils.$(ref,'video_overlay_play')),{alpha:0.75},500,'Cubic','easeOut');
				
				mc.gotoAndStop('video_play');
				mc = Utils.$(ref,'video_overlay_play');
				if(mc != null){
					mc.alpha = 0.75;
					mc.addEventListener(MouseEvent.CLICK,mouseHandler);
					mc.buttonMode = true;
					mc.mouseEnabled = true;
					mc.mouseChildren = false;
				}
				
			}
			
			if(infoObj.loaded_percent >= 0){
				mc = Utils.$(Utils.$(_controls,'timeline'),'strip_load');
				mc.scaleX = infoObj.loaded_percent / 100;
			}
			
			if(infoObj.time_percent >= 0){
				mc = Utils.$(Utils.$(_controls,'timeline'),'strip_progress');
				mc.scaleX = infoObj.time_percent / 100;
			}
			
			
			mc = Utils.$(ref,'still');
			if(mc){
			
				if(infoObj.playing){
					TweenLite.to(MovieClip(mc),0.2,{alpha:0.0});
				}
			
				if(!infoObj.playing && infoObj.time_percent === 0){
					TweenLite.to(MovieClip(mc),0.5,{alpha:1.0});
				}
			
			}
			
		}
		
		private function trackScrubber(e:Event):void
		{
			var mc = Utils.$(Utils.$(_controls,'timeline'),'scrubber');
			_controller.findSeek(mc.x / (width-95));
		}
		
		// Consider moving this into the Controller
		protected function mouseHandler(e:MouseEvent):void
		{
			var mc = e.currentTarget;
			
			if(e.type == MouseEvent.ROLL_OVER){
				
			}
			if(e.type == MouseEvent.ROLL_OUT){
				
			}
			if(e.type == MouseEvent.CLICK){
				if(mc.name == 'video_play'){
					_controller.toggle();
				}
				if(mc.name == 'video_start'){
					_controller.stop();
				}
				if(mc.name == 'label'){
					toggleTime();
				}
				if(mc.name == 'strip_back'){
					var playing = _controller.getPlaying();					
					_controller.findSeek(mc.mouseX / (width-95));
					if(!playing){
						_controller.pause();
					}
				}
				if(mc.name == 'audio'){
					toggleAudio();
				}
				if(mc.name == 'cover'){
					_controller.toggle();
				}
				if(mc.name == 'video_overlay_play'){
					_controller.play();
				}
			}
			if(e.type == MouseEvent.MOUSE_DOWN){
				var rect = new Rectangle();
				rect.top = -4;
				rect.bottom = -4;
				rect.left = 0;
				rect.right = (width-95)-_scrubberWidth;
				mc.startDrag(false,rect);
				mc.dragging = true;
				
				mc.playing = _controller.getPlaying();
				_controller.pause();
				
				//set up special stage tracker
				ref.stage.addEventListener(MouseEvent.MOUSE_UP,mouseHandler);
				
				//_timer.start();
				mc.addEventListener(Event.ENTER_FRAME, trackScrubber);
			}
			if(e.type == MouseEvent.MOUSE_UP){
				
				mc = Utils.$(Utils.$(_controls,'timeline'),'scrubber');
				//mc = Utils.findChild(_controls,['timeline','strip','scrubber']);
				
				mc.dragging = false;
				mc.stopDrag();
				_controller.findSeek(mc.x / (width-95));
				
				if(mc.playing == true){			
					_controller.play();
				}else{
					_controller.pause();
				}
				
				mc.playing = null;
				
				ref.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseHandler);
				
				//_timer.stop();
				mc.removeEventListener(Event.ENTER_FRAME, trackScrubber);
			}
			/*
			if(e.type == MouseEvent.MOUSE_MOVE){
				if(mc.dragging == true){
					_controller.findSeek(mc.x / (width-95));		
				}
			}
			*/
		}
		
		private function layoutUI():void
		{
			if(_controls != null){
				var mc;
				mc = Utils.$(_controls,"back");
				mc.graphics.clear();
				Utils.drawRect(mc,width,20,0x404040,1.0);
			
				var t = Utils.$(_controls,"timeline");
				mc = Utils.$(t,"strip_back");
				mc.graphics.clear();
				Utils.drawRect(mc,width-95,8,0xCCCCCC,1.0);
			
				mc = Utils.$(t,"strip_hit");
				mc.graphics.clear();
				Utils.drawRect(mc,width-95,12,0xFF0000,0.0);
			
				mc = Utils.$(t,"strip_load");
				mc.graphics.clear();
				Utils.drawRect(mc,width-95,8,0xFFFFFF,1.0);
			
				mc = Utils.$(t,"strip_progress");
				mc.graphics.clear();
				Utils.drawRect(mc,width-95,8,0x808080,1.0);
			
				//move the label
				mc = Utils.$(_controls,"label");
				mc.x = width - 50;
			
				//move the audio
				mc = Utils.$(_controls,"audio");
				mc.x = width - 10;
			}
		}
	
		protected function renderUI():void
		{
			//make video screen clickable yo
			var v = Utils.$(ref,'myvideo');
			//ref.stage.addEventListener(MouseEvent.CLICK,mouseHandler);			
			_controls = Utils.createmc(ref,"controls",{y:height-20});
		
			var b = Utils.createmc(_controls,"back",{alpha:0.75,mouseEnabled:true});
			Utils.drawRect(b,width,20,0x404040,1.0);
			b.addEventListener(MouseEvent.CLICK,mouseHandler);
			
			var i,mc;
			
			//VCR stop (back to beginning)
			i = new mediaplayback_icons();
			i.gotoAndStop('video_start');
			mc = _controls.addChild(i);
			mc.name = 'video_start';
			mc.buttonMode = true;
			mc.x = 10;
			mc.y = 10;
			mc.addEventListener(MouseEvent.ROLL_OVER,mouseHandler);
			mc.addEventListener(MouseEvent.ROLL_OUT,mouseHandler);
			mc.addEventListener(MouseEvent.CLICK,mouseHandler);
			
			//play/pause
			i = new mediaplayback_icons();
			i.gotoAndStop('video_play');
			mc = _controls.addChild(i);
			mc.name = 'video_play';
			mc.buttonMode = true;
			mc.x = 30;
			mc.y = 10;
			mc.addEventListener(MouseEvent.ROLL_OVER,mouseHandler);
			mc.addEventListener(MouseEvent.ROLL_OUT,mouseHandler);
			mc.addEventListener(MouseEvent.CLICK,mouseHandler);
			
			//timeline
			var t = Utils.createmc(_controls,"timeline",{x:40,y:10});
			mc = Utils.createmc(t,"strip_back",{y:-4,_scope:this,mouseEnabled:true});
			mc.buttonMode = true;
			Utils.drawRect(mc,width-95,8,0xCCCCCC,1.0);
		
			var h = Utils.createmc(t,"strip_hit",{y:-6});
			Utils.drawRect(h,width-95,12,0xFF0000,0.0);
			
			mc.hitArea = h;
			mc.addEventListener(MouseEvent.CLICK,mouseHandler);
			
			h = Utils.createmc(t,"strip_load",{y:-4,scaleX:0.0});
			Utils.drawRect(h,width-95,8,0xFFFFFF,1.0);
			
			h = Utils.createmc(t,"strip_progress",{y:-4,scaleX:0.0});
			Utils.drawRect(h,width-95,8,0x808080,1.0);		
			
			//scrubber
			i = Utils.createmc(t,"scrubber",{y:-4,dragging:false,mouseEnabled:true});
			Utils.drawRect(i,_scrubberWidth,_scrubberWidth,0x000000,1.0);
			i.buttonMode = true;
			i.addEventListener(MouseEvent.MOUSE_DOWN,mouseHandler);
			
			//_timer = new Timer(20);
			//_timer.addEventListener(TimerEvent.TIMER, trackScrubber);			
			//i.addEventListener(MouseEvent.MOUSE_MOVE,mouseHandler);
			
			//progress label
			var tf = new TextFormat();
			tf.font = "Akzidenz Grotesk";
			tf.size = 10;
			tf.color = 0xFFFFFF;
		
			var l = Utils.createmc(_controls,"label",{x:width-50,y:2.5,mouseEnabled:true});
			t = Utils.makeTextfield(l,"00:00",tf,{width:35});//autoSize:TextFieldAutoSize.RIGHT
			l.addEventListener(MouseEvent.CLICK,mouseHandler);
			l.buttonMode = true;
			
			//audio controls
			i = new mediaplayback_icons();
			i.gotoAndStop('audio3');
			mc = _controls.addChild(i);
			mc.name = 'audio';
			mc.buttonMode = true;
			mc.x = width-10;
			mc.y = 10;
			mc.addEventListener(MouseEvent.ROLL_OVER,mouseHandler);
			mc.addEventListener(MouseEvent.ROLL_OUT,mouseHandler);
			mc.addEventListener(MouseEvent.CLICK,mouseHandler);
			
			//create still frame
			if(_options.still != undefined){
				
				mc = Utils.createmc(ref,'still',{alpha:0.0});
				var movie = new LoadMovie(mc,_options.still);
				movie.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,revealStill);
				
				_controller.stop();
				
				//sort depth
				ref.setChildIndex(mc,ref.numChildren-3);
			}
		
		}
		
		private function revealStill(e:Event=null):void
		{
			var mc = Utils.$(ref,'still');
			TweenLite.to(MovieClip(mc),0.5,{alpha:1.0});
			//psudeo event
			dispatchEvent(new CustomEvent('updateSize',true,false));
		}
		
		public function kill()
		{
			
		}	

	}

}