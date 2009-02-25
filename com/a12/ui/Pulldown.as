package com.a12.ui
{
	import com.a12.util.CustomEvent;
	import com.a12.util.Utils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import gs.TweenLite;		
	
	public class Pulldown extends UIElement
	{
		protected var _container:MovieClip;
		private var _dMax:int;
		private var _open:Boolean;
		private var _parented:Boolean;
		private var stagePulldown:DisplayObject;
		protected var _dir:int;
				
		public function Pulldown(mc:MovieClip,options:Object)
		{
			//make a default tf
			var tf:TextFormat = new TextFormat();
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
			trace(value);
			
			for(var i:int = 0;i<_options.data.length;i++){
				if(_options.data[i].value == value){
					TextField(Utils.$(_container,'controls.label.displayText')).text = String(_options.data[i].name);
					break;
				}
			}
			
			dispatchEvent(new CustomEvent('onChange',true,false,{obj:this}));
			/*
			if(getValue() != _valueVirgin){
				dispatchEvent(new CustomEvent('onChange',true,false,{obj:this}));
			}else{
				dispatchEvent(new CustomEvent('onReset',true,false,{obj:this}));				
			}
			*/		
			
			
		}
		
		public override function reset():void
		{
			
		}
		
		public function setFocus(mode:Boolean):void
		{
			
		}
		
		/* Class Methods */
		private function buildElement():void
		{
			//controls
			//y:-_options.rowHeight
			var controls:MovieClip = Utils.createmc(_container,"controls",{buttonMode:true,mouseEnabled:true});
			
			var mc:MovieClip;
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
			//Debug.log('handleMouse' + e.type + e.currentTarget);
			//Debug.object(e);
			
			switch(true)
			{
				case _open == false:
					
					if(e.currentTarget == Utils.$(_container,'controls')){
						showOptions();
						//e.stopImmediatePropagation();
					}
				
				break;
				
				case _open == true:
					
					if(e.type == MouseEvent.MOUSE_DOWN){
						
						//straight from CS3 component
						if (! contains(e.target as DisplayObject) && !_container.contains(e.target as DisplayObject)) {
							//Debug.log('WHAT UP');
							hideOptions();
							//e.stopImmediatePropagation();
							return;
							
						}
					
					}
					
					if(e.type == MouseEvent.CLICK){	
						//check if the target is controls
						if(e.currentTarget == Utils.$(_container,'controls')){
							hideOptions();
							//e.stopImmediatePropagation();
							return;
						}
						
						//is it one of the options
						if(e.currentTarget.parent == Utils.$(_container,'options')){
							setValue(e.currentTarget.value);
							hideOptions();
							//e.stopImmediatePropagation();
							return;							
						}
						
						//is it outside this element - this is from the stage handler
						if(!_container.hitTestPoint(mouseX,mouseY)){
							hideOptions();
							//e.stopImmediatePropagation();
						}
					
					}
				
				break;				
				
			}
			
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
				ref.addEventListener(Event.ENTER_FRAME, addCloseListener, false, 0, true);
				
				_container = MovieClip(ref.stage.addChild(_container));
				var p:Point = ref.localToGlobal(new Point());
				_container.x = p.x;
				_container.y = p.y;
				
				//evalutate the position to stage height - open down
				if(ref.stage.stageHeight - (p.y + ((_dMax+1)*_options.rowHeight)) > 0){				
					//animate the height of the mask
					TweenLite.to(Utils.$(_container,"options_mask"),0.3,{height:_dMax*_options.rowHeight});
					//animate the position of the options
					TweenLite.to(Utils.$(_container,"options"),0.3,{y:_options.rowHeight});
					_dir = 1;
				
				}else{
					//open up
					var yPos:int = -_dMax*_options.rowHeight;
					
					//animate the height of the mask
					TweenLite.to(Utils.$(_container,"options_mask"),0.3,{y:yPos,height:_dMax*_options.rowHeight});
					//animate the position of the options
					Utils.$(_container,"options").y = -_options.rowHeight*2;
					TweenLite.to(Utils.$(_container,"options"),0.3,{y:yPos});
					_dir = -1;					
					
				}
				
				//
				
				
				/*
				if(!ref.stage.willTrigger(MouseEvent.CLICK)){
					ref.stage.addEventListener(MouseEvent.CLICK,handleMouse,false,0,true);
					//var controls = Utils.$(_container,'controls');
					//controls.removeEventListener(MouseEvent.CLICK,handleMouse,false);		
				}
				*/
				_parented = false;
								
			}
			
			_open = true;
			
			setFocus(true);
		}
		
		private function addCloseListener(e:Event):void
		{
			ref.removeEventListener(Event.ENTER_FRAME, addCloseListener);
			if (!_open) { return; }
			ref.stage.addEventListener(MouseEvent.MOUSE_DOWN, handleMouse, false, 0, true);
			//Debug.log('added');
		}
		
		protected function hideOptions():void
		{
			if(_options.mode == 'local'){
				//animate the height of the mask
				TweenLite.to(Utils.$(_container,"options_mask"),0.3,{y:_options.rowHeight,height:0});
				//animate the position of the options
				TweenLite.to(Utils.$(_container,"options"),0.3,{y:-(_options.rowHeight * _dMax)});
			}
			
			if(_options.mode == 'stage'){
				
				//suck back// setInterval - repartent YO
				//animate the height of the mask
				TweenLite.to(Utils.$(_container,"options_mask"),0.3,{y:_options.rowHeight,height:0});
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
				//Debug.log('remove stage click');
				ref.stage.removeEventListener(MouseEvent.MOUSE_DOWN,handleMouse,false);
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
			var options:MovieClip = Utils.createmc(_container,"options",{y:_options.rowHeight});
			
			
			
			//create mask
			var mask:MovieClip = Utils.createmc(_container,"options_mask",{y:_options.rowHeight});
			Utils.drawRect(mask,_options.width,_options.rowHeight,1.0);
			
			options.mask = mask;
			
			//
			//make the back yea?
			//loop items and make rows
			_dMax = _options.data.length;
			
			options.y = -(_options.rowHeight * _dMax);
			
			var mc:MovieClip, but:MovieClip;
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