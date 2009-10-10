package com.a12.ui
{
	import com.a12.util.CustomEvent;
	import com.a12.util.Utils;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	
	public class Scrollbar extends UIElement
	{	
		
		
		public var lastPercent:Number;
		//protected var _options:Object;
		protected var scrollInterval:Number;
		protected var state:Boolean;
	
		public function Scrollbar(mc:MovieClip,_options:Object=null)
		{
			//var dObj:Object = {label:'PullDown Test',width:200,rowHeight:20};
			var dObj:Object = 
			{ 
				mode			: 'vertical',
				offsetH			: 0,
				barW			: 20,
				nipW			: 20,
				nipH			: 100			
			};
			//super and merge
			super(mc,_options,dObj);
			
			state = true;
			/*
			_options = new Object();
			var i;
			for(i in __options){
				_options[i] = __options[i];
			}*/

			/*
			i = null;

			for(i in defaultObj){
				if(_options[i] == undefined){
					_options[i] = defaultObj[i];
				}
			}
			*/

			lastPercent = 0;
			
			build();

		}
		
		
		//API METHODS
		public override function getValue():Object
		{
			var tObj:Object = processScroll();
			return tObj.percent;
		}
		
		public override function setValue(value:Object):void
		{
			if(_options.mode == 'vertical'){
				Utils.$(ref,'nip').y = (Number(value)/100) * (_options.barH-_options.nipH);
			}
			if(_options.mode == 'horizontal'){
				Utils.$(ref,'nip').x = (Number(value)/100) * (_options.barW-_options.nipW);
			}
			processScroll();
		}
		
		public override function reset():void
		{
			setValue(0);
		}
		
		public function setEnabled(value:Boolean):void
		{
			var mc:MovieClip;
			if(value){
				mc = MovieClip(Utils.$(ref,'back'));
				mc.mouseEnabled = true;
				mc = MovieClip(Utils.$(ref,'nip'));
				mc.mouseEnabled = true;
				state = true;
			}else{
				mc = MovieClip(Utils.$(ref,'back'));
				mc.mouseEnabled = false;
				mc = MovieClip(Utils.$(ref,'nip'));
				mc.mouseEnabled = false;
				state = false;
			}
		}
		
		public function getState():Boolean
		{
			return state;
		}
		
		public function onKill():void
		{
			clearInterval(scrollInterval);
		}
		//CLASS METHODS
		protected function build():void
		{
			var mc:MovieClip = Utils.createmc(ref,"back");

			mc = Utils.createmc(ref,"nip");
			//Utils.createmc(mc,"back");

			if(_options.mode == "vertical"){
				mc.y = _options.offsetH;
			}

			renderBar();
			renderNip();

			mc = MovieClip(Utils.$(ref,'back'));
			mc.mouseEnabled = true;
			mc.addEventListener(MouseEvent.ROLL_OVER,handleMouse,false,0,true);
			mc.addEventListener(MouseEvent.ROLL_OUT,handleMouse,false,0,true);
			mc.addEventListener(MouseEvent.CLICK,handleMouse,false,0,true);
		
			mc = MovieClip(Utils.$(ref,'nip'));
			mc.mouseEnabled = true;
			mc.buttonMode = true;
			mc.addEventListener(MouseEvent.ROLL_OVER,handleMouse,false,0,true);
			mc.addEventListener(MouseEvent.ROLL_OUT,handleMouse,false,0,true);
			mc.addEventListener(MouseEvent.MOUSE_DOWN,handleMouse,false,0,true);
			//mc.addEventListener(MouseEvent.MOUSE_UP,handleMouse,false,0,true);

		
		}
		
		public function renderBar():void
		{
			var mc:MovieClip = MovieClip(Utils.$(ref,'back'));
			mc.graphics.clear();
			Utils.drawRect(mc,_options.barW,_options.barH,_options.clr_bar,1.0);
		}

		public function renderNip():void
		{
			var mc:MovieClip = MovieClip(Utils.$(ref,'nip'));
			mc.graphics.clear();
			Utils.drawRect(mc,_options.nipW,_options.nipH,_options.clr_nip,1.0);
		}
		
		public function setWidth(value:Number):void
		{
			var tObj:Object = processScroll(false);
			
			if(_options.mode == 'horizontal'){
				//update prop
				_options.barW = value;
				//redraw
				renderBar();
				//reposition nip if necessary
				Utils.$(ref,'nip').x = (tObj.percent/100) * (_options.barW-_options.nipW);
			}
		}
		
 		public function setHeight(value:Number):void
		{
			var tObj:Object = processScroll(false);
			
			if(_options.mode == 'vertical'){
				//update prop
				_options.barH = value;
				//redraw
				renderBar();
				//reposition nip if necessary
				Utils.$(ref,'nip').y = (tObj.percent/100) * (_options.barH-_options.nipH);
			}
		}
		
		protected function handleMouse(e:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(e.currentTarget);
			//broadcast out event - for subclassing?
			if(mc.name == 'back'){
				if(e.type == MouseEvent.CLICK){
					if(_options.mode == 'vertical'){
						shiftScroll(Utils.$(ref,'back').mouseY - Utils.$(ref,'nip').y);
					}
					if(_options.mode == 'horizontal'){
						shiftScroll(Utils.$(ref,'back').mouseX - Utils.$(ref,'nip').x);
					}
				}
			}
			if(mc.name == 'nip'){
				if(e.type == MouseEvent.MOUSE_DOWN){
					
					var tObj:Object = getDragLimits();
					mc.startDrag(false,new Rectangle(tObj.left,tObj.top,tObj.right,tObj.bottom));
					//this.startDrag(false,tObj.left,tObj.top,tObj.right,tObj.bottom);

					//this._scope.broadcaster.broadcastMessage("onNipPress");
					//clearInterval(scrollInterval);
					//scrollInterval = setInterval(processScroll,30);
					ref.stage.addEventListener(MouseEvent.MOUSE_MOVE,handleMouseStage,false,0,true);
					ref.stage.addEventListener(MouseEvent.MOUSE_UP,handleMouseStage,false,0,true);
					
					
					
				}
				/*
				if(e.type == MouseEvent.MOUSE_UP){
					mc.stopDrag();
					//this._scope.broadcaster.broadcastMessage("onNipRelease");
					clearInterval(scrollInterval);
				}
				*/				
			}
			//not the best idea
			//e.stopPropagation();
		}
		
		private function handleMouseStage(e:MouseEvent):void
		{
			if(e.type == MouseEvent.MOUSE_MOVE){
				processScroll();
			}
			if(e.type == MouseEvent.MOUSE_UP){
				MovieClip(Utils.$(ref,'nip')).stopDrag();
				//clearInterval(scrollInterval);
				ref.stage.removeEventListener(MouseEvent.MOUSE_MOVE,handleMouseStage,false);
				ref.stage.removeEventListener(MouseEvent.MOUSE_UP,handleMouseStage,false);
			}
			e.stopPropagation();
		}
		
		public function shiftScroll(delta:int):void
		{
			var mc:MovieClip = MovieClip(Utils.$(ref,'nip'));
			if(_options.mode == 'vertical'){
				var tY:int = mc.y + delta;

				switch(true)
				{
					case (tY <= _options.offsetH):
						mc.y = _options.offsetH;
					break;

					case (tY >= _options.barH - _options.nipH - _options.offsetH):
						mc.y = _options.barH - _options.nipH - _options.offsetH;
					break;

					default:
						mc.y += delta;
					break;
				}

			}
			if(_options.mode == 'horizontal'){
				var tX:int = mc.x + delta;

				switch(true)
				{
					case (tX <= _options.offsetW):
						mc.x = _options.offsetW;
					break;

					case (tX >= _options.barW - _options.nipW - _options.offsetW):
						mc.x = _options.barW - _options.nipW - _options.offsetW;
					break;

					default:
						mc.x += delta;
					break;
				}

			}

			processScroll();
		}
		
		public function processScroll(dispatch:Boolean=true):Object
		{
			var perc:Number;
			var mc:MovieClip = MovieClip(Utils.$(ref,'nip'));
			if(_options.mode == 'vertical'){
				perc = (((mc.y - _options.offsetH) / (_options.barH-_options.nipH - (_options.offsetH * 2))) * 100);
			}
			if(_options.mode == 'horizontal'){
				perc = (((mc.x) / (_options.barW-_options.nipW)) * 100);
			}
			if(isNaN(perc)){
				perc = 0;
			}

			var tObj:Object = {};

			tObj.percent = perc;
			tObj.clip = ref;
			tObj.x = mc.x;
			tObj.y = mc.y;
			if(dispatch){
				dispatchEvent(new CustomEvent('onScroll',true,false,tObj));
			}

			lastPercent = perc;

			return tObj;

		}
		
		
		private function getDragLimits():Object
		{
			var tObj:Object = {};

			if(_options.mode == 'vertical'){
				tObj.left = 0;
				tObj.right = 0;
				tObj.top = 0;
				tObj.bottom = _options.barH - _options.nipH;
				if(_options.offsetH){
					tObj.top = _options.offsetH;
					tObj.bottom = _options.barH - _options.nipH - _options.offsetH;
				}
			}
			if(_options.mode == 'horizontal'){
				tObj.left = 0;
				tObj.right = _options.barW - _options.nipW;
				tObj.top = 0;
				tObj.bottom = 0;
			}

			return tObj;
		}
		
		
		
		
		
	}
	
}