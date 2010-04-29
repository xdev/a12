package com.a12.util
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	public class Utils
	{
		//http://www.adobe.com/devnet/flashmediaserver/articles/dynstream_advanced_pt3.html
		public function getFlashPlayerMajorVersion():Number
		{
			var fpVersionStr:String = Capabilities.version;
			return Number(fpVersionStr.split(" ")[1].split(",", 1));
		}
		
		//http://agitatedobserver.com/snippet-easy-globaltolocal-in-as3/
		public static function localToLocal(from:MovieClip, to:MovieClip):Point
		{
			return to.globalToLocal(from.localToGlobal(new Point()));
		}
		
		public static function align(itemsA:Array, mode:String, bounds:Object, process:Boolean=true):Array
		{
			//assume item max is inside bounds for now
			
			//per item, optional bounding box override
			var x:Number, y:Number, mc:MovieClip;
			var width:Number, height:Number;
			var imax:int = itemsA.length;
			var item:Object;
			for(var i:int=0;i<imax;i++){
				item = itemsA[i];
				mc = item.obj;
				
				item.x = mc.x;
				item.y = mc.y;
				x = item.x;
				y = item.y;
				
				width = mc.width;
				if(item.width != undefined){
					width = item.width;
				}
				height = mc.height;
				if(item.height != undefined){
					height = item.height;
				}
				
				switch(mode){
				
					case 'HL':
						x = 0;
					break;
					
					case 'HC':
						x = bounds.width/2 - width/2;
					break;
					
					case 'HR':
						x = bounds.width - width;
					break;
					
					case 'VT':
					
					break;
					
					case 'VC':
					
					break;
					
					case 'VB':
					
					break;
					
				}
				
				if(process){
					mc.x = x;
					mc.y = y;
				}
				
				//update itemsA
				item.x = x;
				item.y = y;
				
			}
			
			return itemsA;
			
		}
	
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
			
			if(Utils.$(mc,name)){
				mc.removeChild(Utils.$(mc,name));
			}
			
			var sp:MovieClip = new MovieClip();
			var tObj:Object = { name:name, mouseEnabled:false, focusRect:false, tabEnabled:false };
			
			for(var i:Object in tObj){
				sp[i] = tObj[i];
			}
			
			for(var j:Object in objProps){
				sp[j] = objProps[j];
			}
		
			mc.addChild(sp);
			return sp;
		}
		
		public static function addProps(mc:MovieClip, props:Object):void
		{
			for(var j:Object in props){
				mc[j] = props[j];
			}
		}
		
		public static function $(parent:Object, children:String, delimeter:String='.'):*
		{
			var obj:Object = null;
			var tA:Array = children.split(delimeter);
			var found:Boolean = false;
			var i:int = 0;
			var a1:Object = parent;
			var a2:Object = tA[i];
			
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
			obj = DisplayObject(obj);
			
			if(obj is Sprite){
				obj = Sprite(obj);
			}
			if(obj is MovieClip){
				obj = MovieClip(obj);
			}
			
			return obj;
		}
		
		//http://www.kirupa.com/forum/showthread.php?p=1897368
		public static function clone(source:Object):* 
		{
			var copier:ByteArray = new ByteArray();
			copier.writeObject(source);
			copier.position = 0;
			return(copier.readObject());
		}
		
		public static function handleMovieClipPlayback(event:Event):void
		{
			var mc:MovieClip = event.target as MovieClip;
			var i:int;
			for(i=0;i<mc.currentLabels.length;i++){
				if(mc.currentLabels[i].frame == mc.currentFrame){
					if(mc.currentLabel == 'stop' || mc.currentLabel == 'pause'){
						mc.stop();
						mc.removeEventListener(Event.ENTER_FRAME, Utils.handleMovieClipPlayback, false);
					}
					break;
				}
			}
		}
		
		public static function playClip(mc:MovieClip):void
		{
			mc.play();
			mc.addEventListener(Event.ENTER_FRAME, Utils.handleMovieClipPlayback, false, 0, true);
		}
		
		
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
			intID = setInterval(function():void {
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
		public static function drawRect(mc:MovieClip, w:Number, h:Number, rgb:Number, alpha:Number = 1.0, lineStyle:Array = null, x:Number = 0, y:Number = 0):void
		{
		
			mc.graphics.moveTo(x, y);
			mc.graphics.beginFill(rgb, alpha);
			if(lineStyle != null){
				mc.graphics.lineStyle(lineStyle[0], lineStyle[1], lineStyle[2]);
			}
			mc.graphics.drawRect(x,y,w,h);
			mc.graphics.endFill();
		
		}
		
		public static function drawShearedRect(mc:MovieClip, w:Number, h:Number, shear:Number, rgb:Number, alpha:Number = 1.0, lineStyle:Array = null, x:Number = 0, y:Number = 0):void
		{
			//we could calculate this in degrees instead of pixels slope y=mx+b
			mc.graphics.moveTo(x, y);
			mc.graphics.beginFill(rgb, alpha);
			if(lineStyle != null){
				mc.graphics.lineStyle(lineStyle[0], lineStyle[1], lineStyle[2]);
			}
			mc.graphics.moveTo(x+shear, y);
			mc.graphics.lineTo(x+shear+w, y);
			mc.graphics.lineTo(x+w, y+h);
			mc.graphics.lineTo(x, y+h);
			mc.graphics.lineTo(x+shear, y);
			//mc.graphics.drawRect(x,y,w,h);
			mc.graphics.endFill();
		
		}
		
		public static function drawPunchedRect(mc:MovieClip, w:Number, h:Number, stroke:Number, rgb:Number, alpha:Number = 1.0, x:Number = 0, y:Number = 0):void
		{
			mc.graphics.moveTo(x, y);
			mc.graphics.beginFill(rgb, alpha);
			
			mc.graphics.drawRect(x, y, w, stroke);
			mc.graphics.drawRect(w-stroke, y+stroke, stroke, h-(stroke*2));
			mc.graphics.drawRect(x, h-stroke, w, stroke);
			mc.graphics.drawRect(x, stroke, stroke, h-(stroke*2));
			
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
			var x:int, y:int, fillType:String, alphas:Array, colors:Array, ratios:Array, matrix:Matrix, rot:int;
			
			(props.x == undefined) ? x = 0 : x = props.x;
			(props.y == undefined) ? y = 0 : y = props.y;
			(props.fillType == undefined) ? fillType = "linear" : fillType = props.fillType;
			(props.alphas == undefined) ? alphas = [1.0,1.0] : alphas = props.alphas;
			(props.ratios == undefined) ? ratios = [0,255] : ratios = props.ratios;
			(props.rot == undefined) ? rot = 0 : rot = props.rot;
			
			colors = props.colors;
			matrix = new Matrix();
			matrix.createGradientBox(w, h, (Math.PI/180)*rot, 0, 0);
			
			mc.graphics.moveTo(x, y);
			mc.graphics.beginGradientFill(fillType, colors, alphas, ratios, matrix);
			mc.graphics.drawRect(x, y, w, h);
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
		public static function drawCircle(mc:MovieClip, rgb:Number, alpha:Number = 1.0, radius:Number = 10, lineStyle:Array = null, x:Number = 0, y:Number = 0):void
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
		public static function drawRoundRect(mc:MovieClip, w:Number, h:Number, rgb:Number, alpha:Number = 1.0, radius:Number = 10, lineStyle:Array = null, x:Number = 0, y:Number = 0):void
		{
			mc.graphics.moveTo(x, y);
			mc.graphics.beginFill(rgb, alpha);
			if(lineStyle != null){
				mc.graphics.lineStyle(lineStyle[0], lineStyle[1], lineStyle[2]);
			}
			mc.graphics.drawRoundRect(x, y, w, h, radius, radius);
			mc.graphics.endFill();
		
		}
		
		public static function createTextField(display:String, format:TextFormat, props:Object = null):TextField
		{
			var tf:TextField = new TextField();
			var tObj:Object = {
				name:'displayText',
				mouseEnabled:false,
				mouseWheelEnabled:false,
				selectable:false,
				width:20,
				height:10,
				embedFonts:true,
				wordWrap:true,
				multiline:true,
				autoSize:TextFieldAutoSize.LEFT,
				condenseWhite:false
			};
			
			for(var i:Object in tObj){
				tf[i] = tObj[i];
			}
			
			for(var j:Object in props){
				tf[j] = props[j];
			}
			
			if(tf.selectable == true){
				tf.mouseEnabled = true;
			}
			
			tf.text = display;
			tf.htmlText = display;
			
			if(!tf.styleSheet){
				if(!format){
					format = new TextFormat();
				}
				tf.defaultTextFormat = format;
				tf.setTextFormat(format);
			}
			
			return tf;
		}
		
		public static function makeTextfield(mc:Object, display:String, format:TextFormat, props:Object = null):TextField
		{
			var tf:TextField = Utils.createTextField(display, format, props);
			mc.addChild(tf);
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
		
		
		public static function getRandomInt(min:int, max:int):int
		{
		  return Math.floor(Math.random() * (max - min + 1)) + min;
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
			var tObj:Object = {};

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
		
		public static function getScale(objWidth:Number, objHeight:Number, contWidth:Number, contHeight:Number, scaleMode:String='scale', max:Number=undefined):Object
		{
			//need to handle way to toggle on off Math functions (ceil,floor)
			
			var scale:Number = 100;
			var scaleObj:Object = {};
			
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
	
		public static function getPositionByOffset(ind:Number, len:Number, offset:Number):Number
		{
			var t:int = ind+offset;
			
			switch(true)
			{
				case (t < 0) && (offset<1):
					return (len)-Math.abs(t);
				break;
				
				case (t > (len-1)) && (offset>-1):
					return t-len;
				break;
				
				default:
					return t;
				break;
				
			}
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