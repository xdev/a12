/* $Id$ */

package com.a12.modules.mediaplayback
{
	
	import flash.display.MovieClip;
	import flash.text.*;
	import flash.utils.*;
	
	import com.a12.pattern.observer.*;
	import com.a12.pattern.mvc.*;

	import com.a12.modules.mediaplayback.*;

	import com.a12.util.*;

	public class CPView extends AbstractView
	{

		public var _ref				: MovieClip;
		public	var	height			: Number;
		public	var width			: Number;
		public	var stripW			: Number;
		
		private	var originalSize	: Object;
		private	var	_controls		: MovieClip;

		public function CPView(m:Observable,c:Controller)
		{
			
			super(m,c);
			width = 320;
			height = 240;
		
			stripW = 120;
		
			var obj = getModel();
			_ref = obj.getRef();		
		
		}
		
		public function setScale(s:Number) : void
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

			_ref.frame._xscale = s;
			_ref.frame._yscale = s;

			updateSize({width:tW,height:tH});
		}

		public function getDimensions(mode:Boolean) : Object
		{
			if(mode == false){
				return {height:height,width:width};
			}else{
				return {height:originalSize.height,width:originalSize.width};
			}
		}
	
	
		public override function defaultController(m:Observable) : Controller
		{
			return new CPController(m);
		}
		
		public override function update(o:Observable, infoObj:Object) : void
		{
			if(infoObj.stream != undefined){
			
			
			}
			if(infoObj.mode != undefined){
				_ref.controls.icon_playpause.gotoAndStop("icon_" + infoObj.icon);
			}
			
			if(infoObj.action == 'updateSize'){
				originalSize = {};
				originalSize.height = infoObj.height;
				originalSize.width = infoObj.width;
				updateSize(infoObj);
				//broadcaster.broadcastMessage("onUpdateSize");
			}
			
			if(infoObj.action == 'updateView'){
				updateView(infoObj);
			}
			if(infoObj.action == 'mediaComplete'){
				_ref.controls.icon_playpause.gotoAndStop("icon_play");
			}

		}
		
		private function updateSize(infoObj)
		{
			width = infoObj.width;
			height = infoObj.height;
			renderUI();
		}	
	
		private function updateView(infoObj)
		{
		
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
		
		}
	
		private function renderUI()
		{
			trace('CPView renderUI')
		
			_ref.video._scope = this;
		
		
		
			_ref.video.onPress = function()
			{
				CPController(this._scope.getController()).toggle();
			}
		
			_controls = Utils.createmc(_ref,"controls",{y:240});
		
			var b = Utils.createmc(_controls,"back",{alpha:.9});
			Utils.drawRect(b,320,20,0xFFFFFF,100);
		
			//attach play/pause button
			//_controls.attachMovie("icons","icon_playpause",1,{_x:10,_y:10,_scope:this,mode:'pause'});
			/*
			_ref.controls.icon_playpause.gotoAndStop("icon_pause");
		
			_ref.controls.icon_playpause.onPress = function()
			{
			
				CPController(this._scope.getController()).toggle();
			}
			*/
		
		
		
			//attach timeline
		
			var t = Utils.createmc(_controls,"timeline",{x:30,y:10});
			var s = Utils.createmc(t,"strip",{y:-2.5,_scope:this});
			Utils.drawRect(s,200,5,0xCCCCCC,100);
		
			var h = Utils.createmc(t,"strip_hit",{y:-5});
			Utils.drawRect(h,200,10,0xCCCCCC,0);
		
			s.hitArea = h;
			/*
			s.onPress = function()
			{
				CPController(this._scope.getController()).findSeek(this._xmouse / 200);
			}
			*/
			
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
			//attach scrubber
			var tf = new TextFormat();
			tf.font = "standard 07_55";
			tf.size = 8;
			tf.color = 0x000000;
		
			var l = Utils.createmc(t,"label",{x:204,y:-8});
			Utils.makeTextfield(l,"00:00/00:00",tf,{selectable: false});
	
			//attach audio buttons
			var icons = new icons();
			var ic = _controls.addChild(icons);
			ic.name = "icon_audio";
			ic.x = 305;
			ic.y = 10;
			//_ref.controls.attachMovie("icons","icon_audio",10,{_x:305,_y:10,_scope:this});
			ic.gotoAndStop("icon_audio");
			/*
			_ref.controls.icon_audio.onPress = function()
			{
				CPController(this._scope.getController()).toggleSound();
			}
			*/
		
		}	

	}

}