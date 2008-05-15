﻿/* $Id$ */package com.a12.util{	import flash.display.*;	import flash.geom.ColorTransform;	import flash.text.*;		public class Utils	{			/*		Function: createmc			Creates an empty MovieClip and applies an object of properties			Usage1 - Utils.createmc(mc, name, depth, objProps);		Usage2 - somevariable = Utils.createmc(mc, name, depth, objProps);		Usage3 - somemc[somevariable] = Utils.createmc(somemc, somevariable, depth, objProps);			Parameters:				mc - parent MovieClip			name - string of new MovieClip			depth - depth			objProps - object of properties to be applied				Returns: 					MovieClip reference				*/			public static function createmc(mc:Object, name:String, objProps:Object = null) : MovieClip		{			var sp = new MovieClip();			sp.name = name;						var tObj = {mouseEnabled:false};						for(var i in tObj){				sp[i] = tObj[i];			}									for(var j in objProps){				sp[j] = objProps[j];			}					mc.addChild(sp);			return sp;		}				public static function $(c1,c2:String) : DisplayObject		{			return DisplayObject(c1.getChildByName(c2));		}				/*		Function: changeProps		Basic animation function, can handle any number of properties but only applies basic ease out		Parameters:			mc - movieclip			objProps - object of properties and their target values			easing - a number controlling the ease out rate (4) is common		*/		/*		public static function changeProps(mc:MovieClip, objProps:Object, easing:Number) : void		{			// need to subcontract easing formulas			// need to change to time based rather than frame based			mc.onEnterFrame = function() {				var done = true;				for (var prop in objProps) {					this[prop] = (this[prop] - ((this[prop] - objProps[prop]) / easing));					if ((Math.abs(this[prop] - objProps[prop]) > 1)) { // ***this test needs to be improved						done = false;					}				}				if (done == true) {					for (var prop in objProps) {						this[prop] = objProps[prop];					}									delete this.onEnterFrame;				}			}		}		*/		/*		Function: changeColor		Changes color of movieclip to hex value		Parameters:			mc - movieclip			rgb - hex value of new color		Returns: 			color		*/				public static function changeColor(mc:MovieClip, rgb:Number) : void		{			var colorTransform:ColorTransform = mc.transform.colorTransform;			colorTransform.color = rgb;			mc.transform.colorTransform = colorTransform;					}				/*			Function: drawRect			Basic rectangle drawing, with fill and stroke			Parameters:				mc - MovieClip			w - width			h - height			rgb - fill color			alpha - fill alpha			lineStyle - array				*/		public static function drawRect(mc:MovieClip, w:Number, h:Number, rgb:Number, alpha:Number = 100, lineStyle:Array = null, x:Number = 0, y:Number = 0)		{					mc.graphics.moveTo(x, y);			mc.graphics.beginFill(rgb, alpha);			if(lineStyle != null){				mc.graphics.lineStyle(lineStyle[0], lineStyle[1], lineStyle[2]);			}			mc.graphics.drawRect(x,y,w,h);			mc.graphics.endFill();				}				public static function makeTextfield(mc:Object, display:String, format:TextFormat, props:Object = null ) : TextField		{			var tf = new TextField();			tf.text = display;						tf.name = 'displayText';			//loop through props .. but in an order ehh?						tf.selectable = false;			tf.width = 20;			tf.height = 10;			tf.embedFonts = true;			tf.autoSize = TextFieldAutoSize.LEFT;			tf.mouseEnabled = false;						tf.setTextFormat(format);			tf.defaultTextFormat = format;			mc.addChild(tf);						return tf;		}				/*		Function: convertSeconds		Creates an object with minutes and seconds properties from a number of seconds		Parameters:			time - number of seconds		Returns: 			object with minutes and seconds properties		*/		public static function convertSeconds(time:Number) : Object		{			var tObj = {};			if((time / 60) > 1){				tObj.minutes = Math.floor(time/60);				tObj.seconds = time%60;						}else{				tObj.minutes = 0;				tObj.seconds = time;			}			return tObj;		}				/*		Function: padZero		Adds a 0 to a number less than 10 and returns as a string. If number is greater than 10 it returns that number as a string		Parameters:			num - number		Returns: 			string of the number		*/		public static function padZero(num:Number) : String		{			if(num < 10){				return '0' + num;			}else{				return String(num);			}		}			/* 			Function: getPositionByOffset			Finds location in array starting from index based on offset			Parameters:				ind - index			len - length of array			offset - distance (+/-)			Returns: 					number			*/			public static function getPositionByOffset(ind:Number,len:Number,offset:Number) : Number		{			var t = ind+offset;					switch(true)			{				case (t < 0) && (offset<1):					t = (len)-Math.abs(t);				break;						case (t > (len-1)) && (offset>-1):					t = t-len;				break;					}					return t;		}			/* 			Function: toRadians			Converts degrees to radians			Parameters:				deg - degrees			Returns: 					radians			*/			public static function toRadians(deg:Number) : Number		{			return deg * Math.PI/180;		}		}	}