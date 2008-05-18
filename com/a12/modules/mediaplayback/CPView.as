/* $Id$ */

package com.a12.modules.mediaplayback
{
	
	import flash.display.*;
	import flash.text.*;
	import flash.utils.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	
	import com.a12.pattern.observer.*;
	import com.a12.pattern.mvc.*;

	import com.a12.modules.mediaplayback.*;

	import com.a12.util.*;

	public class CPView extends AbstractView
	{

		public var ref:MovieClip;
		public var height:Number;
		public var width:Number;
		
		private var _originalSize:Object;
		private var _controls:MovieClip;
		
		private var _timeMode:Boolean;
		private var _soundLevel:Number;
		private var _soundLevelA:Array;
		private var _scrubberWidth:Number;

		public function CPView(m:Observable,c:Controller)
		{
			
			super(m,c);
			width = 320;
			height = 240;
			
			_timeMode = true;
			_soundLevelA = [0.0,0.3,0.6,1.0];
			_soundLevel = 3;
			_scrubberWidth = 8;
			
			var obj = getModel();
			ref = obj.getRef();
			
			if(obj as AudioModel){
				renderUI();
			}
					
		}
		
		public function setScale(s:Number):void
		{
			//find height and width based upon scale
			var tW,tH;
			
			if(s<100){
				tW = Math.floor((s/100) * _originalSize.width);
				tH = Math.floor((s/100) * _originalSize.height);
			}else{
				tW = _originalSize.width;
				tH = _originalSize.height;
			}		

			updateSize({width:tW,height:tH});
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
				_originalSize = {};
				_originalSize.height = infoObj.height;
				_originalSize.width = infoObj.width;
				updateSize(infoObj);
				//broadcaster.broadcastMessage("onUpdateSize");
			}
			
			if(infoObj.action == 'updateView'){
				updateView(infoObj);
			}
			if(infoObj.action == 'mediaComplete'){
				mc = Utils.$(_controls,'video_play');
				mc.gotoAndStop('video_play');
			}
			
		}
		
		private function updateSize(infoObj:Object):void
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
			CPController(getController()).setVolume(_soundLevelA[_soundLevel]);
		}
		
		private function updateView(infoObj:Object):void
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
				mc = Utils.$(Utils.$(Utils.$(_controls,'timeline'),'strip'),'scrubber');
				if(mc.dragging == false){
					mc.x = infoObj.time_percent * ((width-95)-_scrubberWidth) / 100;
				}
			}
			
			mc = Utils.$(_controls,'video_play');
			if(infoObj.playing){
				mc.gotoAndStop('video_pause');
			}else{
				mc.gotoAndStop('video_play');
			}
						
			//Utils.createmc(_ref.controls.timeline,"loader",{_y:-2.5});
			//Utils.drawRect(_ref.controls.timeline.loader,infoObj.loaded_percent * factor,5,0x73CDE7,100);
			
		}
		
		// Consider moving this into the Controller
		private function mouseHandler(e:MouseEvent):void
		{
			var mc = DisplayObject(e.target);
			
			if(e.type == MouseEvent.ROLL_OVER){
				
			}
			if(e.type == MouseEvent.ROLL_OUT){
				
			}
			if(e.type == MouseEvent.CLICK){
				if(mc.name == 'video_play'){
					CPController(getController()).toggle();
				}
				if(mc.name == 'video_start'){
					CPController(getController()).stop();
				}
				if(mc.name == 'label'){
					toggleTime();
				}
				if(mc.name == 'strip'){
					var playing = CPController(getController()).getPlaying();
					CPController(getController()).findSeek(mc.mouseX / (width-95));
					if(!playing){
						CPController(getController()).pause();
					}
				}
				if(mc.name == 'audio'){
					toggleAudio();//CPController(getController()).toggleSound();
				}
			}
			if(e.type == MouseEvent.MOUSE_DOWN){
				var rect = new Rectangle();
				rect.top = 0;
				rect.bottom = 0;
				rect.left = 0;
				rect.right = (width-95)-_scrubberWidth;
				mc.startDrag(false,rect);
				mc.dragging = true;
				
				mc.playing = CPController(getController()).getPlaying();
				CPController(getController()).pause();
				
				//set up special stage tracker
				ref.stage.addEventListener(MouseEvent.MOUSE_UP,mouseHandler);
			}
			if(e.type == MouseEvent.MOUSE_UP){
				
				mc = Utils.$(Utils.$(Utils.$(_controls,'timeline'),'strip'),'scrubber');
				//mc = Utils.findChild(_controls,['timeline','strip','scrubber']);
				
				mc.dragging = false;
				mc.stopDrag();
				CPController(getController()).findSeek(mc.x / (width-95));
				
				if(mc.playing == true){			
					CPController(getController()).play();
				}else{
					CPController(getController()).pause();
				}
				
				mc.playing = null;
				
				ref.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseHandler);
			}
			if(e.type == MouseEvent.MOUSE_MOVE){
				if(mc.dragging == true){
					CPController(getController()).findSeek(mc.x / (width-95));		
				}
			}
		}
	
		private function renderUI():void
		{
			//make video screen clickable yo
			//_ref.addEventListener(MouseEvent.CLICK,mouseHandler);			
			_controls = Utils.createmc(ref,"controls",{y:height});
		
			var b = Utils.createmc(_controls,"back",{alpha:0.75});
			Utils.drawRect(b,width,20,0x404040,100);
			
			var i,mc;
			
			//VCR stop (back to beginning)
			i = new icons();
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
			i = new icons();
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
			mc = Utils.createmc(t,"strip",{y:-4,_scope:this,mouseEnabled:true});
			mc.buttonMode = true;
			Utils.drawRect(mc,width-95,8,0xFFFFFF,100);
		
			var h = Utils.createmc(t,"strip_hit",{y:-6});
			Utils.drawRect(h,width-95,12,0xFF0000,0);
		
			mc.hitArea = h;
			mc.addEventListener(MouseEvent.CLICK,mouseHandler);
			
			//scrubber
			i = Utils.createmc(mc,"scrubber",{dragging:false,mouseEnabled:true});
			Utils.drawRect(i,_scrubberWidth,_scrubberWidth,0x000000,100);
			i.buttonMode = true;
			i.addEventListener(MouseEvent.MOUSE_DOWN,mouseHandler);
			//i.addEventListener(MouseEvent.MOUSE_UP,mouseHandler);
			i.addEventListener(MouseEvent.MOUSE_MOVE,mouseHandler);
			//i.addEventListener(MouseEvent.MOUSE_OUT,mouseHandler);
			
			//progress label
			var tf = new TextFormat();
			tf.font = "Akzidenz Grotesk";
			tf.size = 10;
			tf.color = 0xFFFFFF;
		
			var l = Utils.createmc(_controls,"label",{x:width-40,y:2.5,mouseEnabled:true});
			t = Utils.makeTextfield(l,"00:00",tf,{autoSize:'right'});//
			l.addEventListener(MouseEvent.CLICK,mouseHandler);
			l.buttonMode = true;
			
			//audio controls
			i = new icons();
			i.gotoAndStop('audio3');
			mc = _controls.addChild(i);
			mc.name = 'audio';
			mc.buttonMode = true;
			mc.x = width-10;
			mc.y = 10;
			mc.addEventListener(MouseEvent.ROLL_OVER,mouseHandler);
			mc.addEventListener(MouseEvent.ROLL_OUT,mouseHandler);
			mc.addEventListener(MouseEvent.CLICK,mouseHandler);
		
		}	

	}

}