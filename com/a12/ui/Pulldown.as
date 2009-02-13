package com.a12.ui
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.FocusEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.text.TextField;

	import com.a12.util.Utils;
	import com.a12.util.CustomEvent;
	import com.a12.ui.UIElement;
	import com.a12.ui.IUI;
	import com.a12.ui.Scrollbar;

	import gs.TweenLite;		
	
	public class Pulldown extends UIElement
	{
		protected var _container:MovieClip;
		private var _dMax:int;
		private var _open:Boolean;
		private var _parented:Boolean;
		private var stagePulldown:DisplayObject; 
				
		public function Pulldown(mc:MovieClip,options:Object)
		{
			//make a default tf
			var tf = new TextFormat();
			tf.font = 'Arial';
			tf.size = 12;
			
			//set default object			
			var dObj:Object = {
				mode:'stage',
				labelDefault:'',
				width:200,
				rowHeight:20,
				clr_primary:0x333333,
				tf:tf,
				data:[],
				textOffset:{x:0,y:0}
			};
			
			//super and merge
			super(mc,options,dObj);
			//build
			_open = false;
			_parented = true;
			//this is what will story
			_container = Utils.createmc(ref,'container');
			
			ref.addEventListener(Event.REMOVED_FROM_STAGE,handleRemoved,false,10,true);
			
			buildElement();
		}
		
		/* Interface */
		
		public override function getValue():Object
		{
			return _value;
		}
		
		public override function setValue(value:Object):void
		{
			_value = value;
			
			//find value
			for(var i:int = 0;i<_options.data.length;i++){
				if(_options.data[i].value == value){
					TextField(Utils.$(_container,'controls.label.displayText')).text = String(_options.data[i].name);
					break;
				}
			}
			
		}
		
		public override function reset():void
		{
			
		}
		
		private function handleFocus(e:FocusEvent):void
		{
			/*
			if(e.type == FocusEvent.FOCUS_IN){
				setFocus(true);
			}
			if(e.type == FocusEvent.FOCUS_OUT){
				setFocus(false);
			}
			*/
		}
		
		public function setFocus(mode:Boolean):void
		{
			
		}
		
		/* Class Methods */
		private function buildElement():void
		{
			//controls
			//y:-_options.rowHeight
			var controls = Utils.createmc(_container,"controls",{buttonMode:true,mouseEnabled:true});
			
			var mc;
			//back
			mc = Utils.createmc(controls,"back");
			Utils.drawRect(mc,_options.width,_options.rowHeight,_options.clr_primary,1.0);
			
			//label
			mc = Utils.createmc(controls,"label");
			Utils.makeTextfield(mc,_options.labelDefault,_options.tf,{x:_options.textOffset.x,y:_options.textOffset.y,width:_options.width-20});
			
			//arrows
			
			//set up mouse handler for controls ehh
			
			
			//var t = setTimeout(test,1000);
			
			/*
			tf.addEventListener(FocusEvent.FOCUS_IN,handleFocus,false,0,true);
			tf.addEventListener(FocusEvent.FOCUS_OUT,handleFocus,false,0,true);
			*/
			
			buildOptions();
			
			controls.addEventListener(MouseEvent.CLICK,handleMouse,false,0,true);
			
			//showOptions();
			
		}
		
		private function handleRemoved(e:Event):void
		{
			if(_options.mode == 'stage' && !_parented){
				ref.stage.removeChild(_container);
			}
		}
		
		protected function handleMouse(e:MouseEvent):void
		{
			var mc = e.currentTarget;
			
			if(e.type == MouseEvent.MOUSE_DOWN){
				trace('pulldown:mouse down');
				if(e.currentTarget == ref.stage){
					ref.stage.removeEventListener(MouseEvent.MOUSE_DOWN,handleMouse,false);
					hideOptions();
					e.stopImmediatePropagation();
					e.preventDefault();
					var controls = Utils.$(_container,'controls');
					if(!controls.willTrigger(MouseEvent.CLICK)){
						trace('add back');
						controls.addEventListener(MouseEvent.CLICK,handleMouse,false,0,true);
					}
					
					return;
				}
			}
			
			if(mc.name == 'controls'){
			
				if(e.type == MouseEvent.CLICK){
					trace('was a click');
					toggleOptions();
				}
				
			}else{
				
				//regular item
				if(e.type == MouseEvent.CLICK){
					setValue(mc.value);
					hideOptions();					
				}				
				
			}
			
		}
		
		protected function toggleOptions():void
		{
			_open = !_open;
			if(_open){
				showOptions();
			}else{
				hideOptions();
			}
		}
		
		protected function showOptions():void
		{
			if(_options.mode == 'local'){
				//animate the height of the mask
				TweenLite.to(Utils.$(_container,"options_mask"),0.3,{height:_dMax*_options.rowHeight});
				//animate the position of the options
				TweenLite.to(Utils.$(_container,"options"),0.3,{y:_options.rowHeight});
			}
			
			if(_options.mode == 'stage'){
				_container = MovieClip(ref.stage.addChild(_container));
				var p:Point = ref.localToGlobal(new Point());
				_container.x = p.x;
				_container.y = p.y;
				
				//animate the height of the mask
				TweenLite.to(Utils.$(_container,"options_mask"),0.3,{height:_dMax*_options.rowHeight});
				//animate the position of the options
				TweenLite.to(Utils.$(_container,"options"),0.3,{y:_options.rowHeight});
				
				if(!ref.stage.willTrigger(MouseEvent.MOUSE_DOWN)){
					ref.stage.addEventListener(MouseEvent.MOUSE_DOWN,handleMouse,false,0,true);
					var controls = Utils.$(_container,'controls');
					controls.removeEventListener(MouseEvent.CLICK,handleMouse,false);		
				}
				_parented = false;
								
			}
			
			_open = true;
			
			setFocus(true);
		}
		
		protected function hideOptions():void
		{
			if(_options.mode == 'local'){
				//animate the height of the mask
				TweenLite.to(Utils.$(_container,"options_mask"),0.3,{height:0});
				//animate the position of the options
				TweenLite.to(Utils.$(_container,"options"),0.3,{y:-(_options.rowHeight * _dMax)});
			}
			
			if(_options.mode == 'stage'){
				
				//suck back// setInterval - repartent YO
				//animate the height of the mask
				TweenLite.to(Utils.$(_container,"options_mask"),0.3,{height:0});
				//animate the position of the options
				TweenLite.to(Utils.$(_container,"options"),0.3,{y:-(_options.rowHeight * _dMax)});
				
				Utils.delay(this,reparent,400);
				
				/*
				var opt = Utils.$(_container.stage,'options');
				
				if(opt){
					var nopt = _container.addChild(opt);
					//nopt.mask = Utils.$(_container,'options_mask');
				}
				*/
			}
			
			_open = false;
			
			setFocus(false);
		}
		
		private function reparent():void
		{
			_container = MovieClip(ref.addChild(_container));
			_container.x = 0;
			_container.y = 0;
			_parented = true;
		}
		
		private function buildOptions():void
		{
			var options = Utils.createmc(_container,"options",{y:_options.rowHeight});
			
			
			
			//create mask
			var mask = Utils.createmc(_container,"options_mask",{y:_options.rowHeight});
			Utils.drawRect(mask,_options.width,_options.rowHeight,1.0);
			
			options.mask = mask;
			
			//
			//make the back yea?
			//loop items and make rows
			_dMax = _options.data.length;
			
			options.y = -(_options.rowHeight * _dMax);
			
			var mc, but;
			for(var i:int=0;i<_dMax;i++){
				but = Utils.createmc(options,"row"+i,{y:i*_options.rowHeight,mouseEnabled:true,buttonMode:true,id:i,value:_options.data[i].value});
				
				mc = Utils.createmc(but,"back");
				Utils.drawRect(mc,_options.width,_options.rowHeight,_options.clr_primary,1.0);
				
				mc = Utils.createmc(but,"label");
				Utils.makeTextfield(mc,_options.data[i].name,_options.tf,{x:_options.textOffset.x,y:_options.textOffset.y,width:_options.width-10});
				
				but.addEventListener(MouseEvent.ROLL_OVER,handleMouse,false,0,true);
				but.addEventListener(MouseEvent.ROLL_OUT,handleMouse,false,0,true);
				but.addEventListener(MouseEvent.CLICK,handleMouse,false,0,true);
			}
		}
		
	}
	
}