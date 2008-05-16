/* $Id$ */

package com.a12.modules.mediaplayback
{
	
	import flash.display.*;
	import flash.text.*;
	import flash.utils.*;
	import flash.events.*;
	
	import com.a12.pattern.observer.*;
	import com.a12.pattern.mvc.*;

	import com.a12.modules.mediaplayback.*;

	import com.a12.util.*;

	public class CPView extends AbstractView
	{

		public var _ref:MovieClip;
		public var height:Number;
		public var width:Number;
		public var stripW:Number;
		
		private var originalSize:Object;
		private var _controls:MovieClip;

		public function CPView(m:Observable,c:Controller)
		{
			
			super(m,c);
			width = 320;
			height = 240;
		
			stripW = 120;
		
			var obj = getModel();
			_ref = obj.getRef();		
		
		}
		
		public function setScale(s:Number):void
		{
			//find height and width based upon scale
			var tW,tH;
			
			if(s<100){
				tW = Math.floor((s/100) * originalSize.width);
				tH = Math.floor((s/100) * originalSize.height);
			}else{
				tW = originalSize.width;
				tH = originalSize.height;
			}		

			updateSize({width:tW,height:tH});
		}

		public function getDimensions(mode:Boolean):Object
		{
			if(mode == false){
				return {height:height,width:width};
			}else{
				return {height:originalSize.height,width:originalSize.width};
			}
		}
	
	
		public override function defaultController(m:Observable):Controller
		{
			return new CPController(m);
		}
		
		public override function update(o:Observable, infoObj:Object):void
		{	
			
			if(infoObj.stream != undefined){
			
			
			}
			if(infoObj.mode != undefined){
				//_ref.controls.icon_playpause.gotoAndStop("icon_" + infoObj.icon);
			}
			
			if(infoObj.action == 'updateSize'){
				originalSize = {};
				originalSize.height = infoObj.height;
				originalSize.width = infoObj.width;
				updateSize(infoObj);
				//broadcaster.broadcastMessage("onUpdateSize");
			}
			
			if(infoObj.action == 'updateView'){
				//updateView(infoObj);
			}
			if(infoObj.action == 'mediaComplete'){
				//_ref.controls.icon_playpause.gotoAndStop("icon_play");
			}
			
		}
		
		private function updateSize(infoObj):void
		{
			width = infoObj.width;
			height = infoObj.height;			
			renderUI();
		}	
	
		private function updateView(infoObj):void
		{
			/*
			var label = '';
		
			label += Utils.padZero(infoObj.time_current.minutes) + ':' + Utils.padZero(infoObj.time_current.seconds);
		
			if(infoObj.time_duration != undefined){
				label += '/' + Utils.padZero(infoObj.time_duration.minutes) + ':' + Utils.padZero(infoObj.time_duration.seconds);
			}
		
			_ref.controls.timeline.label.displayText.text = label;
		
		
			var factor = (width-stripW) / 100;
		
			//trace('updateView  - factor='+factor + ' perc=' + infoObj.time_percent);
		
		
			//if dragging false
			if(infoObj.time_percent != undefined){
				if(_ref.controls.timeline.scrubber.dragging == false){
					_ref.controls.timeline.scrubber._x = infoObj.time_percent * factor;
				}
			}
		
			Utils.createmc(_ref.controls.timeline,"loader",{_y:-2.5});
			Utils.drawRect(_ref.controls.timeline.loader,infoObj.loaded_percent * factor,5,0x73CDE7,100);
			*/
		}
		
		private function mouseHandler(e:MouseEvent):void
		{
			trace('woooo');
			CPController(getController()).toggle();
		}
	
		private function renderUI():void
		{
			_ref.addEventListener(MouseEvent.CLICK,mouseHandler);			
			
			_controls = Utils.createmc(_ref,"controls",{y:height});
		
			var b = Utils.createmc(_controls,"back",{alpha:0.75});
			Utils.drawRect(b,width,20,0x404040,100);
			
			var i,mc;
			
			i = new icons();
			i.gotoAndStop('video_start');
			mc = _controls.addChild(i);
			mc.name = 'video_start';
			mc.x = 10;
			mc.y = 10;
			mc.addEventListener(MouseEvent.ROLL_OVER,mouseHandler);
			mc.addEventListener(MouseEvent.ROLL_OUT,mouseHandler);
			mc.addEventListener(MouseEvent.CLICK,mouseHandler);
			
			i = new icons();
			i.gotoAndStop('video_play');
			mc = _controls.addChild(i);
			mc.name = 'video_play';
			mc.x = 30;
			mc.y = 10;
			mc.addEventListener(MouseEvent.ROLL_OVER,mouseHandler);
			mc.addEventListener(MouseEvent.ROLL_OUT,mouseHandler);
			mc.addEventListener(MouseEvent.CLICK,mouseHandler);
			//CPController(this._scope.getController()).toggle();
			
			//timeline
			var t = Utils.createmc(_controls,"timeline",{x:40,y:10});
			var s = Utils.createmc(t,"strip",{y:-2.5,_scope:this});
			Utils.drawRect(s,width-95,5,0xCCCCCC,100);
		
			var h = Utils.createmc(t,"strip_hit",{y:-5});
			Utils.drawRect(h,width-95,10,0xCCCCCC,0);
		
			s.hitArea = h;
			/*
			s.onPress = function()
			{
				CPController(this._scope.getController()).findSeek(this._xmouse / 200);
			}
			*/
			
			//scrubber			
			/*
			_ref.controls.timeline.attachMovie("icons","scrubber",10,{_scope:this,dragging:false});
			_ref.controls.timeline.scrubber.gotoAndStop("icon_scrub");
		
		
			_ref.controls.timeline.scrubber.onPress = function(){
				this.startDrag(false,0,0,200,0);
				this.dragging = true;
				//deactivate the scrubber from receiving time updates
			}
		
			_ref.controls.timeline.scrubber.onRelease = function()
			{	
				this.dragging = false;
				this.stopDrag();
				CPController(this._scope.getController()).findSeek(this._x / 200);			
			
				//reactivate the scrubber for time updates
			}
			*/
			
			var tf = new TextFormat();
			tf.font = "Akzidenz Grotesk";
			tf.size = 10;
			tf.color = 0xFFFFFF;
		
			var l = Utils.createmc(_controls,"label",{x:width-50,y:2});
			Utils.makeTextfield(l,"00:00",tf,{selectable: false});
	
			//attach audio buttons
			i = new icons();
			i.gotoAndStop('audio3');
			mc = _controls.addChild(i);
			mc.name = 'audio';
			mc.x = width-10;
			mc.y = 10;
			mc.addEventListener(MouseEvent.ROLL_OVER,mouseHandler);
			mc.addEventListener(MouseEvent.ROLL_OUT,mouseHandler);
			mc.addEventListener(MouseEvent.CLICK,mouseHandler);
			
			
			/*
			_ref.controls.icon_audio.onPress = function()
			{
				CPController(this._scope.getController()).toggleSound();
			}
			*/
		
		}	

	}

}