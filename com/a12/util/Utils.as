package com.a12.util
{

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.StyleSheet;
	import flash.text.TextFieldAutoSize;
	
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	public class Utils
	{
	
		/*

		Function: createmc
	
		Creates an empty MovieClip and applies an object of properties
	
		Usage1 - Utils.createmc(mc, name, depth, objProps);
		Usage2 - somevariable = Utils.createmc(mc, name, depth, objProps);
		Usage3 - somemc[somevariable] = Utils.createmc(somemc, somevariable, depth, objProps);
	
		Parameters:
	
			mc - parent MovieClip
			name - string of new MovieClip
			depth - depth
			objProps - object of properties to be applied
		
		Returns: 
		
			MovieClip reference	
	
		*/
	
		public static function createmc(mc:Object, name:String, objProps:Object = null):MovieClip
		{
			/*
			if(objProps != undefined){
				if(objProps.overwrite != undefined && objProps.overwrite != false){
				 != false){
				
			}
			*/
			
			if(Utils.$(mc,name)){
				mc.removeChild(Utils.$(mc,name));
			}
			
			var sp = new MovieClip();
			sp.name = name;
			
			var tObj = {mouseEnabled:false};
			
			for(var i in tObj){
				sp[i] = tObj[i];
			}			
			
			for(var j in objProps){
				sp[j] = objProps[j];
			}
		
			mc.addChild(sp);
			return sp;
		}
		
		public static function $(parent:Object,children:String,delimeter:String='.'):DisplayObject
		{
			var obj = null;
			var tA:Array = children.split(delimeter);			
			var found = false;
			var i = 0;
			var a1=parent;
			var a2=tA[i];
			
			while(!found){
				obj = DisplayObject(a1.getChildByName(a2));
				if(i<tA.length-1){
					i++;
					a1 = obj;
					a2 = tA[i];					
				}else{
					found = true;
				}
			}
			
			return obj;
		}
		
		/*

		Function: changeProps

		Basic animation function, can handle any number of properties but only applies basic ease out

		Parameters:

			mc - movieclip
			objProps - object of properties and their target values
			easing - a number controlling the ease out rate (4) is common

		*/
		/*
		public static function changeProps(mc:MovieClip, objProps:Object, easing:Number) : void
		{

			// need to subcontract easing formulas
			// need to change to time based rather than frame based

			mc.onEnterFrame = function() {
				var done = true;
				for (var prop in objProps) {
					this[prop] = (this[prop] - ((this[prop] - objProps[prop]) / easing));
					if ((Math.abs(this[prop] - objProps[prop]) > 1)) { // ***this test needs to be improved
						done = false;
					}
				}
				if (done == true) {
					for (var prop in objProps) {
						this[prop] = objProps[prop];
					}				
					delete this.onEnterFrame;
				}
			}
		}
		*/
		
		/*

		Function: delay

		Wrapper for setTimeout, a one time setInterval

		Parameters:

			obj - object
			method - method
			t - delay in milliseconds
			args - array of arguments to pass on

		*/

		public static function delay(obj:Object, method:Object, t:Number, args:Array=null):Number
		{
			var intID:Number;
			// var intID = setInterval(execDelay, t, [this, obj, t, args]); // ALT DESIGN - IN PROGRESS - SEE execDelay
			intID = setInterval(function() {
				method.apply(obj, args);
				clearInterval(intID);
			}, t);
			
			return intID;
		}
	
		
		/*

		Function: changeColor

		Changes color of movieclip to hex value

		Parameters:

			mc - movieclip
			rgb - hex value of new color

		Returns: 

			color

		*/
		
		public static function changeColor(mc:MovieClip, rgb:Number):void
		{
			var colorTransform:ColorTransform = mc.transform.colorTransform;
			colorTransform.color = rgb;
			mc.transform.colorTransform = colorTransform;			
		}
		
		/*
	
		Function: drawRect
	
		Basic rectangle drawing, with fill and stroke
	
		Parameters:
	
			mc - MovieClip
			w - width
			h - height
			rgb - fill color
			alpha - fill alpha
			lineStyle - array
	
	
		*/
		public static function drawRect(mc:MovieClip, w:Number, h:Number, rgb:Number, alpha:Number = 100, lineStyle:Array = null, x:Number = 0, y:Number = 0):void
		{
		
			mc.graphics.moveTo(x, y);
			mc.graphics.beginFill(rgb, alpha);
			if(lineStyle != null){
				mc.graphics.lineStyle(lineStyle[0], lineStyle[1], lineStyle[2]);
			}
			mc.graphics.drawRect(x,y,w,h);
			mc.graphics.endFill();
		
		}
		
		public static function drawPunchedRect(mc:MovieClip, w:Number, h:Number, stroke:Number, rgb:Number, alpha:Number = 100, x:Number = 0, y:Number = 0):void
		{
			mc.graphics.moveTo(x, y);
			mc.graphics.beginFill(rgb, alpha);
			
			mc.graphics.drawRect(x,y,w,stroke);
			mc.graphics.drawRect(w-stroke,y+stroke,stroke,h-(stroke*2));
			mc.graphics.drawRect(x,h-stroke,w,stroke);
			mc.graphics.drawRect(x,stroke,stroke,h-(stroke*2));
			
			mc.graphics.endFill();
		}
		
		/*

		Function: drawGradient

		Basic gradient drawing in a filled rectangle

		Parameters:

			mc:MovieClip - movieclip
			w:Number - width
			h:Number - height
			props:Object - object containing all necessary and optional gradient properties

		*/

		public static function drawGradient(mc:MovieClip, w:Number, h:Number, props:Object ):void
		{
			var x,y,fillType,alphas,colors,ratios,matrix,rot;
			
			(props.x == undefined) ? x = 0 : x = props.x;
			(props.y == undefined) ? y = 0 : y = props.y;
			(props.fillType == undefined) ? fillType = "linear" : fillType = props.fillType;
			(props.alphas == undefined) ? alphas = [1.0,1.0] : alphas = props.alphas;
			(props.ratios == undefined) ? ratios = [0,255] : ratios = props.ratios;
			(props.rot == undefined) ? rot = 0 : rot = props.rot;
			
			colors = props.colors;
			matrix = new Matrix();
			matrix.createGradientBox(w,h,(Math.PI/180)*rot,0,0);
			
			mc.graphics.moveTo(x, y);
			mc.graphics.beginGradientFill(fillType, colors, alphas, ratios, matrix);
			mc.graphics.drawRect(x,y,w,h);
			mc.graphics.endFill();
		}
		
		/*
	
		Function: drawCircle
	
		Basic rectangle drawing, with fill and stroke
	
		Parameters:
	
			mc - MovieClip			
			rgb - fill color
			alpha - fill alpha
			radius - 
			lineStyle - array
	
	
		*/
		public static function drawCircle(mc:MovieClip, rgb:Number, alpha:Number = 100, radius:Number = 10, lineStyle:Array = null, x:Number = 0, y:Number = 0):void
		{
		
			//mc.graphics.moveTo(x, y);
			mc.graphics.beginFill(rgb, alpha);
			if(lineStyle != null){
				mc.graphics.lineStyle(lineStyle[0], lineStyle[1], lineStyle[2]);
			}
			mc.graphics.drawCircle(x,y,radius);
			mc.graphics.endFill();
		
		}
		
		/*
	
		Function: drawRoundRect
	
		Basic rectangle drawing, with fill and stroke
	
		Parameters:
	
			mc - MovieClip
			w - width
			h - height
			rgb - fill color
			alpha - fill alpha
			radius - 
			lineStyle - array
	
	
		*/
		public static function drawRoundRect(mc:MovieClip, w:Number, h:Number, rgb:Number, alpha:Number = 100, radius:Number = 10, lineStyle:Array = null, x:Number = 0, y:Number = 0):void
		{
		
			mc.graphics.moveTo(x, y);
			mc.graphics.beginFill(rgb, alpha);
			if(lineStyle != null){
				mc.graphics.lineStyle(lineStyle[0], lineStyle[1], lineStyle[2]);
			}
			mc.graphics.drawRoundRect(x,y,w,h,radius,radius);
			mc.graphics.endFill();
		
		}
		
		public static function makeTextfield(mc:Object, display:String, format:TextFormat, props:Object = null):TextField
		{
			var tf = new TextField();
			mc.addChild(tf);
			
			var tObj = {
				name:'displayText',
				mouseEnabled:false,
				selectable:false,								
				width:20,
				height:10,
				embedFonts:true,
				wordWrap:true,
				multiline:true,
				autoSize:TextFieldAutoSize.LEFT								
				};
			
			for(var i in tObj){
				tf[i] = tObj[i];
			}			
			
			for(var j in props){
				tf[j] = props[j];
			}
			
			if(tf.selectable == true){
				tf.mouseEnabled = true;
			}
			
			tf.text = display;
			tf.htmlText = display;
			
			if(tf.styleSheet == undefined){
				tf.defaultTextFormat = format;
				tf.setTextFormat(format);
			}
			
			return tf;
		}
		
		/*

		Function: shuffle

		Used as a array sorting function for randomization, could use improvement

		Parameters:

			a - a
			b - b

		Returns: 

			randomized array

		*/

		public static function shuffle(a:Object, b:Object):Object
		{
			return Math.floor(Math.random()*2);
		}
		
		/*

		Function: convertSeconds

		Creates an object with minutes and seconds properties from a number of seconds

		Parameters:

			time - number of seconds

		Returns: 

			object with minutes and seconds properties

		*/

		public static function convertSeconds(time:Number):Object
		{
			var tObj = {};

			if((time / 60) > 1){
				tObj.minutes = Math.floor(time/60);
				tObj.seconds = time%60;			
			}else{
				tObj.minutes = 0;
				tObj.seconds = time;
			}

			return tObj;

		}
		
		/*

		Function: padZero

		Adds a 0 to a number less than 10 and returns as a string. If number is greater than 10 it returns that number as a string

		Parameters:

			num - number

		Returns: 

			string of the number

		*/

		public static function padZero(num:Number):String
		{
			if(num < 10){
				return '0' + num;
			}else{
				return String(num);
			}

		}
		
		public static function getScale(objWidth:Number,objHeight:Number,contWidth:Number,contHeight:Number,scaleMode:String='scale',max:Number=undefined):Object
		{
			//need to handle way to toggle on off Math functions (ceil,floor)
			
			var scale = 100;
			var scaleObj = {};
			
			//scale from 0 to n, non-proportionally
			if(scaleMode == 'fill'){
				scaleObj.x = Math.ceil(100 *(contWidth)/objWidth);
				scaleObj.y = Math.ceil(100 *(contHeight)/objHeight);
			}
			
			//scale from 0 to n, proportionally
			if(scaleMode == 'scale'){
				
				switch(true){
					case objWidth > contWidth:
						scale = Math.ceil(100 *(contWidth)/objWidth);
						if((scale/100) * objHeight > contHeight){
							scale = Math.ceil(100 *(contHeight)/objHeight);
						}
					break;
					case objHeight > contHeight:
						scale = Math.ceil(100 *(contHeight)/objHeight);
						if((scale/100) * objWidth > contWidth){
							scale = Math.ceil(100 *(contWidth)/objWidth);
						}
					break;
					case objWidth < contWidth:
						scale = Math.ceil(100 *(contWidth)/objWidth);
						if((scale/100) * objHeight > contHeight){
							scale = Math.ceil(100 *(contHeight)/objHeight);
						} 
					break;
					case objHeight < contHeight:
						scale = Math.ceil(100 *(contHeight)/objHeight);
						if((scale/100) * objWidth > contWidth){
							scale = Math.ceil(100 *(contWidth)/objWidth);
						}
					break;
				}
				
				if(max){
					if(scale > max){
						scale = max;
					}
				}
				
				scaleObj.x = scale;
				scaleObj.y = scale;
			}
			
			return scaleObj;
		}
	
		/* 
	
		Function: getPositionByOffset
	
		Finds location in array starting from index based on offset
	
		Parameters:
	
			ind - index
			len - length of array
			offset - distance (+/-)
	
		Returns: 
		
			number
	
		*/
	
		public static function getPositionByOffset(ind:Number,len:Number,offset:Number):Number
		{
			var t = ind+offset;
		
			switch(true)
			{
				case (t < 0) && (offset<1):
					t = (len)-Math.abs(t);
				break;
		
				case (t > (len-1)) && (offset>-1):
					t = t-len;
				break;
		
			}
		
			return t;
		}
	
		/* 
	
		Function: toRadians
	
		Converts degrees to radians
	
		Parameters:
	
			deg - degrees
	
		Returns: 
		
			radians
	
		*/
	
		public static function toRadians(deg:Number):Number
		{
			return deg * Math.PI/180;
		}
	
	}
	
}