package com.a12.ui
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import flash.geom.Rectangle;
	
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	import com.a12.util.CustomEvent;
	import com.a12.util.Utils;
	import com.a12.ui.UIElement;
	
	public class Scrollbar extends UIElement
	{	
		
		
		public var lastPercent:Number;
		//protected var _options:Object;
		protected var scrollInterval:Number;
		
	
		public function Scrollbar(mc:MovieClip,_options:Object=null)
		{
			//var dObj:Object = {label:'PullDown Test',width:200,rowHeight:20};
			var dObj = 
			{ 
				mode			: 'vertical',
				offsetH			: 0,
				barW			: 20,
				nipW			: 20,
				nipH			: 100			
			};
			//super and merge
			super(mc,_options,dObj);
			
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
			var tObj = processScroll();
			return tObj.percent;
		}
		
		public override function setValue(value:Object):void
		{
			var mc = Utils.$(ref,'nip');
			mc.y = (Number(value)/100) * (_options.barH-_options.nipH);
			processScroll();
		}
		
		public override function reset():void
		{
			setValue(0);
		}
		
		public function setEnabled(value:Boolean):void
		{
			var mc;
			if(value){
				mc = Utils.$(ref,'back');
				mc.mouseEnabled = true;
				mc = Utils.$(ref,'nip');
				mc.mouseEnabled = true;
			}else{
				mc = Utils.$(ref,'back');
				mc.mouseEnabled = false;
				mc = Utils.$(ref,'nip');
				mc.mouseEnabled = false;
			}
		}
		
		public function onKill():void
		{
			clearInterval(scrollInterval);
		}
		//CLASS METHODS
		protected function build():void
		{
			var mc = Utils.createmc(ref,"back");

			mc = Utils.createmc(ref,"nip");
			Utils.createmc(mc,"back");

			if(_options.mode == "vertical"){
				mc.y = _options.offsetH;
			}

			renderBar();
			renderNip();

			mc = Utils.$(ref,'back');
			mc.mouseEnabled = true;
			mc.addEventListener(MouseEvent.ROLL_OVER,handleMouse,false,0,true);
			mc.addEventListener(MouseEvent.ROLL_OUT,handleMouse,false,0,true);
			mc.addEventListener(MouseEvent.CLICK,handleMouse,false,0,true);
		
			mc = Utils.$(ref,'nip');
			mc.mouseEnabled = true;
			mc.buttonMode = true;
			mc.addEventListener(MouseEvent.ROLL_OVER,handleMouse,false,0,true);
			mc.addEventListener(MouseEvent.ROLL_OUT,handleMouse,false,0,true);
			mc.addEventListener(MouseEvent.MOUSE_DOWN,handleMouse,false,0,true);
			//mc.addEventListener(MouseEvent.MOUSE_UP,handleMouse,false,0,true);

		
		}
		
		public function renderBar()
		{
			var mc = Utils.$(ref,'back');
			mc.graphics.clear();
			Utils.drawRect(mc,_options.barW,_options.barH,_options.clr_bar,1.0);
		}

		public function renderNip()
		{
			var mc = Utils.$(Utils.$(ref,'nip'),'back');
			mc.graphics.clear();
			Utils.drawRect(mc,_options.nipW,_options.nipH,_options.clr_nip,1.0);
		}
		
 		public function setHeight(value:Number):void
		{
			var tObj = processScroll();
			//update prop
			_options.barH = value;
			
			//redraw
			renderBar();
			
			//reposition nip if necessary
			var mc = Utils.$(ref,'nip');
			mc.y = (tObj.percent/100) * (_options.barH-_options.nipH);
			
		}
		
		protected function handleMouse(e:MouseEvent):void
		{
			var mc = e.currentTarget;
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
					
					var tObj = getDragLimits();
					mc.startDrag(false,new Rectangle(0,tObj.top,0,tObj.bottom));
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
		}
		
		private function handleMouseStage(e:MouseEvent):void
		{
			if(e.type == MouseEvent.MOUSE_MOVE){
				processScroll();
			}
			if(e.type == MouseEvent.MOUSE_UP){
				var mc = Utils.$(ref,'nip');
				mc.stopDrag();
				//clearInterval(scrollInterval);
				ref.stage.removeEventListener(MouseEvent.MOUSE_MOVE,handleMouseStage,false);
				ref.stage.removeEventListener(MouseEvent.MOUSE_UP,handleMouseStage,false);
			}
		}
		
		public function shiftScroll(delta)
		{
			var mc = Utils.$(ref,'nip');
			if(_options.mode == 'vertical'){
				var tY = mc.y + delta;

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
				var tX = mc.x + delta;

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
		
		public function processScroll()
		{
			var perc:Number;
			var mc = Utils.$(ref,'nip');
			if(_options.mode == "vertical"){
				perc = (((mc.y - _options.offsetH) / (_options.barH-_options.nipH - (_options.offsetH * 2))) * 100);
			}
			if(_options.mode == "horizontal"){
				perc = (((mc.x) / (_options.barW-_options.nipW)) * 100);
			}

			var tObj = {};

			tObj.percent = perc;
			tObj.clip = ref;
			tObj.x = mc.x;
			tObj.y = mc.y;
			
			dispatchEvent(new CustomEvent('onScroll',true,false,tObj));

			lastPercent = perc;

			return tObj;

		}
		
		
		private function getDragLimits():Object
		{
			var tObj = {};

			if(_options.mode == "vertical"){
				tObj.left = 0;
				tObj.right = 0;
				tObj.top = 0;
				tObj.bottom = _options.barH - _options.nipH;
				if(_options.offsetH){
					tObj.top = _options.offsetH;
					tObj.bottom = _options.barH - _options.nipH - _options.offsetH;
				}
			}
			if(_options.mode == "horizontal"){
				tObj.left = 0;
				tObj.right = _options.barW - _options.nipW;
				tObj.top = 0;
				tObj.bottom = 0;
			}

			return tObj;
		}
		
		
		
		
		
	}
	
}