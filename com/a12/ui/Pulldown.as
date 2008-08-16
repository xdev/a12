package com.a12.ui
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;

	import com.a12.util.*;
	import com.a12.ui.UIElement;
	import com.a12.ui.IUI;
	import com.a12.ui.Scrollbar;

	import com.gs.TweenLite;		
	
	
	public class Pulldown extends UIElement
	{
		
		private var _dMax:int;
		private var _open:Boolean;
				
		public function Pulldown(mc:MovieClip,options:Object)
		{
			//set default object			
			var dObj:Object = {label:'PullDown Test',width:200,rowHeight:20};
			//super and merge
			super(mc,options,dObj);
			//build
			_open = false;
			
			buildElement();
		}
		
		/* Interface */
		
		public override function getValue():Object
		{
			return _value;
		}
		
		public override function setValue(value:Object):void
		{
			
		}
		
		public override function reset():void
		{
			
		}
		
		/* Class Methods */
		private function buildElement()
		{
			//controls
			var controls = Utils.createmc(ref,"controls",{y:-_options.rowHeight,buttonMode:true,mouseEnabled:true});
			var mc;
			//back
			mc = Utils.createmc(controls,"back");
			Utils.drawRect(mc,_options.width,_options.rowHeight,_options.clr_primary,1.0);
			
			//label
			mc = Utils.createmc(controls,"label",{x:2,y:2});
			Utils.makeTextfield(mc,'Test',_options.tf,{width:_options.width-20});
			
			//arrows
			
			//set up mouse handler for controls ehh
			controls.addEventListener(MouseEvent.CLICK,mouseHandler);
			
			//var t = setTimeout(test,1000);
			
			buildOptions();
			
			showOptions();
			
		}
		
		private function mouseHandler(e:Event)
		{
			var mc = DisplayObject(e.target);
			
			if(mc.name == 'controls'){
			
				if(e.type == MouseEvent.CLICK){
					toggleOptions();
				}
				
			}
			
		}
		
		private function toggleOptions()
		{
			_open = !_open;
			if(_open){
				showOptions();
			}else{
				hideOptions();
			}
		}
		
		private function showOptions()
		{
			//animate the height of the mask
			TweenLite.to(Utils.$(ref,"options_mask"),0.3,{height:_dMax*_options.rowHeight});
			//animate the position of the options
			TweenLite.to(Utils.$(ref,"options"),0.3,{y:0});
			
			_open = true;
		}
		
		private function hideOptions()
		{
			//animate the height of the mask
			TweenLite.to(Utils.$(ref,"options_mask"),0.3,{height:0});
			//animate the position of the options
			TweenLite.to(Utils.$(ref,"options"),0.3,{y:-(_options.rowHeight * _dMax)});
			
			_open = false;
		}
		
		private function buildOptions()
		{
			var options = Utils.createmc(ref,"options");
			
			
			
			//create mask
			var mask = Utils.createmc(ref,"options_mask");
			Utils.drawRect(mask,_options.width,_options.rowHeight,1.0);
			
			options.mask = mask;
			
			//
			//make the back yea?
			//loop items and make rows
			_dMax = _options.data.length;
			
			options.y = -(_options.rowHeight * _dMax);
			
			var mc, but;
			for(var i:int=0;i<_dMax;i++){
				but = Utils.createmc(options,"row"+i,{y:i*_options.rowHeight,mouseEnabled:true,buttonMode:true});
				mc = Utils.createmc(but,"back");
				Utils.drawRect(mc,_options.width,_options.rowHeight,_options.clr_primary,1.0);
				
				mc = Utils.createmc(but,"label");
				Utils.makeTextfield(mc,_options.data[i].value,_options.tf,{width:_options.width-10});
				
				
				
				but.addEventListener(MouseEvent.ROLL_OVER,mouseHandler);
				but.addEventListener(MouseEvent.ROLL_OUT,mouseHandler);
				but.addEventListener(MouseEvent.CLICK,mouseHandler);
			}
		}
		
		private function test()
		{
			dispatchEvent(new CustomEvent('onBuild',true,true,{foo:false,bar:true}));
		}
		
		
	}
	
}