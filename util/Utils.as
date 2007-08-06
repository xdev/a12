/*

Class: Utils

Collection of functions to perform general operations
(text, drawing, creation, array, misc conversions etc.)

*/

class com.a12.util.Utils
{
	
	/*
	
	Constructor: Utils
	
	Private constructor function prevents object from being created directly.
	
	*/
	private function Utils()
	{
	
	}
	
	/*
	
	Function: createmc
	
	Creates an empty movieclip and applies an object of properties
	
	Usage1 - Utils.createmc(mc, name, depth, objProps);
	Usage2 - somevariable = Utils.createmc(mc, name, depth, objProps);
	Usage3 - somemc[somevariable] = Utils.createmc(somemc, somevariable, depth, objProps);
	
	Parameters:
	
		mc - parent movieclip
		name - string of new movieclip
		depth - depth
		objProps - object of properties to be applied
		
	Returns: 
		
		movieclip reference	
	
	*/
	
	public static function createmc(mc:MovieClip, name:String, depth:Number, objProps:Object) : MovieClip
	{
		mc.createEmptyMovieClip(name, depth);
		var $mc = mc[name];
		for (var i in objProps) {
			$mc[i] = objProps[i];
		}
		return(mc[name]);
	}
	
	/* 
	
	Function: setProps
	
	Applies an object of properties to a movieclip
	
	Parameters:
	
		mc - movieclip
		objProps - object of properties to be applied
		
	*/
	
	public static function setProps(mc:MovieClip, objProps:Object) : Void
	{
		for (var prop in objProps) {
			mc[prop] = objProps[prop];
		}
	}
	
	/*
	
	Function: changeProps
	
	Basic animation function, can handle any number of properties but only applies basic ease out
	
	Parameters:
	
		mc - movieclip
		objProps - object of properties and their target values
		easing - a number controlling the ease out rate (4) is common
		
	*/
	
	public static function changeProps(mc:MovieClip, objProps:Object, easing:Number) : Void
	{
		
		// need to subcontract easing formulas
		// need to change to time based rather than frame based
		
		mc.onEnterFrame = function() {
			var done = true;
			for (var prop in objProps) {
				this[prop] = (this[prop] - ((this[prop] - objProps[prop]) / easing));
				if ((Math.abs(this[prop] - objProps[prop]) > 2)) { // ***this test needs to be improved
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
	
	/*
	
	Function: drawRect
	
	Basic rectangle drawing, with fill and stroke
	
	Parameters:
	
		mc - movieclip
		w - width
		h - height
		rgb - fill color
		alpha - fill alpha
		lineStyle - array
	
	*/
	
	public static function drawRect(mc:MovieClip, w:Number, h:Number, rgb:Number, alpha:Number, lineStyle:Array, x:Number, y:Number) : Void
	{
		
		if (w == undefined) w = 100;
		if (h == undefined) h = 100;
		if (rgb == undefined) rgb = 0x000000;
		if (alpha == undefined) alpha = 100;
		if (x == undefined) x = 0;
		if (y == undefined) y = 0;
		
		mc.moveTo(x, y);
		mc.beginFill(rgb, alpha);
		mc.lineStyle(lineStyle[0], lineStyle[1], lineStyle[2]);
		mc.lineTo(x+w, y);
		mc.lineTo(x+w, y+h);
		mc.lineTo(x, y+h);
		mc.lineTo(x, y);
		mc.endFill();
	}
	
	/*
	
	Function: drawCircle
	
	Basic circle drawing, no strokes
	
	Parameters:
	
		mc - movieclip
		r - radius
		rgb - fill color
		alpha - fill alpha
	
	*/
	
	public static function drawCircle(mc:MovieClip,r:Number,rgb:Number, alpha:Number)
	{
		
		mc.beginFill(rgb,alpha);
		var TO_RADIANS:Number = Math.PI/180;
		// begin circle at 0, 0 (its registration point) -- move it when done
		mc.moveTo(0, 0);
		mc.lineTo(r, 0);
		
		// draw 12 30-degree segments 
		// (could do more efficiently with 8 45-degree segments)
		var a:Number = 0.268;  // tan(15)
		for (var i=0; i < 12; i++) {
		 
		  var endx = r*Math.cos((i+1)*30*TO_RADIANS);
		  var endy = r*Math.sin((i+1)*30*TO_RADIANS);
		  var ax = endx+r*a*Math.cos(((i+1)*30-90)*TO_RADIANS);
		  var ay = endy+r*a*Math.sin(((i+1)*30-90)*TO_RADIANS);
		  mc.curveTo(ax, ay, endx, endy);	
		}
		mc.endFill();
		

	
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
	
	public static function drawGradient(mc:MovieClip, w:Number, h:Number, props:Object ) : Void
	{
		var x,y,fillType,alphas,colors,ratios,matrix;
		
		if (w == undefined) w = 100;
		if (h == undefined) h = 100;
		
		(props.x == undefined) ? x = 0 : x = props.x;
		(props.y == undefined) ? y = 0 : y = props.y;
		(props.fillType == undefined) ? fillType = "linear" : fillType = props.fillType;
		(props.alphas == undefined) ? alphas = [100,100] : alphas = props.alphas;
		(props.ratios == undefined) ? ratios = [0,255] : ratios = props.ratios;
		
		colors = props.colors;
		matrix = props.matrix;
		
		mc.moveTo(x, y);
		mc.beginGradientFill(fillType, colors, alphas, ratios, matrix);
		mc.lineTo(x+w, y);
		mc.lineTo(x+w, y+h);
		mc.lineTo(x, y+h);
		mc.lineTo(x, y);
		mc.endFill();
	}
	
	
	/*
	==========================================================================
	Misc Utils
	==========================================================================
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
	
	public static function delay(obj:Object, method:Object, t:Number, args:Array ) : Void
	{
		
		// var intID = setInterval(execDelay, t, [this, obj, t, args]); // ALT DESIGN - IN PROGRESS - SEE execDelay
		
		var intID = setInterval(function() {
			method.apply(obj, args);
			clearInterval(intID);
		}, t);
		
	}
	
	/*
	
	Function: setVars
	
	Applies an object of properties to a movieclip or object after creation, not really used much
	
	Parameters:
	
		scope - base object
		varsObj - object of properties to be applied
		overwrite - boolean if to overwrite or not
	
	*/
	
	public static function setVars(scope:Object, varsObj:Object, overwrite:Boolean) : Void
	{
		overwrite = (overwrite != undefined) ? overwrite : false;
		for (var v in varsObj) {
			if (overwrite == true) {
				scope[v] = varsObj[v];
			} else if (scope[v] == undefined || scope[v] == null || scope[v] == "") {
				scope[v] = varsObj[v];
			}
		}
	}
	
	/*
	
	Function: inArray
	
	Checks if a value exists in an array, currently only supports checking a one-dimensional array 
	
	Parameters:
	
		a - array
		val - value to find
	
	Returns: 
	
		boolean
	
	*/
	
	public static function inArray(a:Array, val:Object) : Boolean
	{
		for(var i in a){
			if(a[i] == val){
				return true;
			}
		}
		return false;
	}
	
	/*
	
	Function: rnd
	
	Returns a random positive or negative value of 1
	
	Returns: 
		
		1 or -1
	
	*/
	
	public static function rnd() : Number
	{
		var tA = [1,-1];
		return tA[random(2)];
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
	
	public static function shuffle(a:Object, b:Object) : Object
	{
		return Math.floor(Math.random()*2);
	}
	
	/*
	
	Function: sortByNumber
	
	Used to force numeric sorting
	
	Parameters:
	
		a - a
		b - b
	
	Returns: 
		
		sorted array
	
	*/
	
	public static function sortByNumber(a, b) : Object 
	{
		return (a > b);
	}
	
	/* 
	
	Function: toRadians
	
	Converts degrees to radians
	
	Parameters:
	
		deg - degrees
	
	Returns: 
		
		radians
	
	*/
	
	public static function toRadians(deg) : Number
	{
		return deg * Math.PI/180;
	}
	
	/*
	
	Function: traceObj
	
	Debug trace of an object
	
	Parameters:
	
		obj - object to be traced
	
	*/	
	
	public static function traceObj(obj)
	{
		trace('-----------------------------------------');
		for(var i in obj){
			trace(i + '--' + obj[i]);
		}
	}
	
	/*
	
	Function: padZero
	
	Adds a 0 to a number less than 10 and returns as a string. If number is greater than 10 it returns that number as a string
	
	Parameters:
	
		num - number
	
	Returns: 
		
		string of the number
	
	*/
	
	public static function padZero(num) : String
	{
		if(num < 10){
			return '0' + num;
		}else{
			return String(num);
		}
	
	}
	
	/*
	
	Function: findReplace
	
	Find and replace for a string
	
	Parameters:
	
		str - haystack
		pattern - needle
		replacement - replacement
	
	Returns: 
		
		modified haystack
		
	Author:
	
		http://www.flzone.com/ShowDetail.asp?NewsId=7678
	
	*/
	
	public static function findReplace (str, pattern, replacement) : String
	{
		 return str.split(pattern).join(replacement);
	}
	
	/*
	
	Function: convertSeconds
	
	Creates an object with minutes and seconds properties from a number of seconds
	
	Parameters:
	
		time - number of seconds
		
	Returns: 
		
		object with minutes and seconds properties
		
	*/
	
	public static function convertSeconds(time:Number) : Object
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
	
	Function: trimRight
	
	Trims the whitespace on the right of a string
	
	Parameters:
	
		str - string to be trimmed
		
	Returns: 
		
		trimmed string
	
	Author: 
		
		Mike Chambers (Macromedia, Adobe)
	
	*/	
	
	public static function trimRight(str:String) : String
	{
				
		var size = str.length;
		
		for(var i = size; i > 0; i--){
			if(str.charCodeAt(i) > 32){
				return str.substring(0, i + 1);
			}
		}
		return "";
	
	}
	/*
	
	Function: removeDuplicates
	
	Removes duplicate values from an array, SLOW!
	
	Parameters:
	
		myA - array
		
	Returns: 
		
		cleaned array
	
	Author: 
		
		http://proto.layer51.com/d.aspx?f=1196
	
	*/
	
	public static function removeDuplicates(myA:Array) : Array
	{
		myA.sort();
		var obj={};
		var i=myA.length;
		var arr=[];
		var t;
		while(i--)t=myA[i],obj[t]=t;for(i in obj)arr.push(obj[i]);return arr;

	}
	
	/*
	==========================================================================
	Text Utils
	==========================================================================
	*/
	
	/*
	
	Function: createTF
	
	To create general textField objects specialized for different uses.
		
	When using these methods the order of the textField 
	properties is very important (e.g. 'htmltext' must come before 'html').
	Keep in mind that properties get assigned in reverse order.
	
	INTERNAL METHOD
	
	*/
			
	private static function createTF(mc:MovieClip, name:String, depth:Number, display:Array, props:Object) : TextField
	{
		if (name == undefined) name = "displayText";
		if (depth == undefined) depth = 1;
		
		mc.createTextField(name, depth, 0, 0, 0, 0); //instanceName, depth, x, y, width, height
		var tfObj:TextField = mc[name];
		
		for (var i in props) {
			//trace("--createTF " + tfObj + " " + i + ":" + props[i]);
			tfObj[i] = props[i];
		}
		
		tfObj.setNewTextFormat(display[0][0]);
		
		var indexArray:Array = [];
		var concatText:String = "";
		
		var len = display.length;
		for (var i=0;i<len;i++) {
			var beginIndex = concatText.length;
			concatText += display[i][1];
			var endIndex = concatText.length;
			indexArray.push([beginIndex, endIndex]);
		}
		
		tfObj.htmlText = concatText;
		var len = display.length;
		for (var i=0;i<len;i++) {
			tfObj.setTextFormat(indexArray[i][0], indexArray[i][1], display[i][0]);
		}
		
		// This is fix for multiline not displaying correctly, may need to be revised for special circumstances.
		if (mc[name].type != "input" && props["_height"] == undefined) {
			//trace("height not defined");
			//mc[name]._height = mc[name].textHeight;
			mc[name]._height = mc[name]._height;
		}
		return(mc[name]);
	}
	
	/*
	
	Function: makeTextfield
	
	Creates a textfield (with use of createTF)
	
	Parameters:
	
		mc - parent movieclip
		display - text to render
		format - textformat
		props - object of properties (_x,_y,selectable,autosize,embed)
		
	Returns:
	
		textfield
	
	*/
	
	public static function makeTextfield(mc:MovieClip, display:String, format:TextFormat, props:Object ) : TextField
	{
		
		var x,y,autosize,embed,selectable;
		
		if (display == undefined) display = "";
		(props._x == undefined) ? x = 0 : x=props._x;
		(props._y == undefined) ? y = 0 : y=props._y;
		(props.selectable == undefined) ? selectable = false : selectable=props.selectable;
		(props.autosize == undefined) ? autosize = "left" : autosize=props.autosize;
		//if (embed == undefined) embed = true;
		embed = true;
		
		var $props = { _x:x, _y:y, _height:10, _width:10, selectable:selectable, autoSize:autosize, embedFonts:embed };
		var $display = [ [format, display] ];
		
		// createTF(mc:MovieClip, name:String, depth:Number, display:Array, props:Object)
		var tf:TextField = createTF(mc, "displayText", 1, $display, $props);
		return(tf);
	};
	
	/*
	
	Function: makeTextbox
	
	Creates a textbox
	If autosize = "none" textfield will become a fixed size textbox... otherwise, _height will have no effect
	
	Parameters:
	
		mc - movieclip
		display - text to render
		format - textformat
		props - object of properties (_x,_y,_width,_height,selectable,autosize,embed,border)
		
	Returns: 
		
		textfield
	
	*/
	
	public static function makeTextbox(mc:MovieClip, display:String, format:TextFormat, props:Object) : TextField
	{
		
		var x,y,width,height,autosize,embed,selectable,border,styleSheet;
		
		if (display == undefined) display = "";
		(props._x == undefined) ? x = 0 : x=props._x;
		(props._y == undefined) ? y = 0 : y=props._y;
		(props._width == undefined) ? width = 200 : width=props._width;
		(props._height == undefined) ? height = 200 : height=props._height;
		(props.selectable == undefined) ? selectable = true : selectable=props.selectable;
		(props.autosize == undefined) ? autosize = "left" : autosize=props.autosize;
		(props.embed == undefined) ? embed = true : embed=props.embed;
		(props.border == undefined) ? border = false : border=props.border;
		
		var $props = { _x:x, _y:y, _width:width, _height:height, embedFonts:embed, selectable:selectable, html:true, autoSize:autosize, multiline:true, wordWrap:true, border:border, html:display};
		var $display = [ [format, display] ];
		
		var tf:TextField = createTF(mc, "displayText", 1, $display, $props);
		return(tf);
	}
	
	/*
	
	Function: makeStylebox
	
	Douglas's style makin' box
	
	Parameters:
		
		mc - movieclip
		display - text to render
		props - object of properties (_x,_y,_width,_height,selectable,autosize,embed,border,stylSheet)
	
	Returns: 
		
		textfield
	
	*/	
	
	public static function makeStylebox(mc:MovieClip, display:String, props:Object) : TextField
	{
		
		var x,y,width,height,autosize,embed,selectable,border,styleSheet;
		
		if (display == undefined) display = "";
		(props._x == undefined) ? x = 0 : x=props._x;
		(props._y == undefined) ? y = 0 : y=props._y;
		(props._width == undefined) ? width = 200 : width=props._width;
		(props._height == undefined) ? height = 200 : height=props._height;
		(props.selectable == undefined) ? selectable = true : selectable=props.selectable;
		(props.autosize == undefined) ? autosize = "left" : autosize=props.autosize;
		(props.embed == undefined) ? embed = true : embed=props.embed;
		(props.border == undefined) ? border = false : border=props.border;
		(props.styleSheet == undefined) ? styleSheet = undefined : styleSheet=props.styleSheet;
		
		var $props = { _x:x, _y:y, _width:width, _height:height, embedFonts:embed, selectable:selectable, html:true, autoSize:autosize, multiline:true, wordWrap:true, border:border, html:display, styleSheet:styleSheet};
		var $display = [ [undefined, display] ];
		
		var tf:TextField = createTF(mc, "displayText", 1, $display, $props);
		return(tf);
	}
	
	/*
	
	Function: makeFormatbox
	
	Douglas's old style makin' box method
	
	Parmeters:
	
		mc - movieclip
		display - text to render
		x - xpos
		y - ypos
		w - width
		autosize - string
		embed - boolean
	
	Rrturns: 
	
		textfield
	
	*/
	
	public static function makeFormatbox(mc:MovieClip, display:Array, x:Number, y:Number, w:Number, autosize:String, embed:Boolean) : TextField
	{
		
		// display is a multi-dimensional array in the format [ [textFormat, text], [textFormat, text], [textFormat, text], ... ]
		
		if (x == undefined) x = 0;
		if (y == undefined) y = 0;
		if (w == undefined) w = 200;
		if (autosize == undefined) autosize = "left";
		if (embed == undefined) embed = false;
		
		var $props = { _x:x, _y:y, _width:w, embedFonts:embed, selectable:true, html:true, autoSize:autosize, multiline:true, wordWrap:true};
		
		var tf:TextField = createTF(mc, "displayText", 1, display, $props);
		return(tf);
	}
	
	/*
	
	Function: makeTextinput
	
	Creates input textfield, same basically as textbox, but with additional input specific properties
	Consider consolidation
	
	Parameters:
	
		mc - movieclip
		display - text to render
		format - textformat
		props - object of properties (_x,_y,_width,_height,selectable,autosize,embed,border,multiline,restrictions,password,max_chars)
	
	Returns: 
	
		textfield
	
	*/	
	
	public static function makeTextinput(mc:MovieClip, display:String, format:TextFormat, props:Object) : TextField
	{
		
		var x,y,width,height,autosize,embed,selectable,border,multi,wrap,max_chars,restrictions,password;
		
		if (display == undefined) display = "";
		(props._x == undefined) ? x = 0 : x=props._x;
		(props._y == undefined) ? y = 0 : y=props._y;
		(props._width == undefined) ? width = 200 : width=props._width;
		(props._height == undefined) ? height = 200 : height=props._height;
		(props.autosize == undefined) ? autosize = "left" : autosize=props.autosize;
		(props.embed == undefined) ? embed = true : embed=props.embed;
		(props.multiline == undefined) ? multi = false : multi=props.multiline;
		(props.max_chars == undefined) ? max_chars = 255 : max_chars=props.max_chars;
		(props.restrictions == undefined) ? restrictions = "" : restrictions=props.restrictions;
		(props.password == undefined) ? password = false : password=props.password;
		
		
		if (multi) {
			var wrap = true;
		} else {
			multi = false;
			var wrap = false;
		}
		
		var $props = { _x:x, _y:y, _width:width, _height:height, selectable:true, embedFonts:embed, type:"input", multiline:multi, wordWrap:wrap, maxChars:max_chars, restrict:restrictions, password:password };
		var $display = [ [format, display] ];
		
		// createTF(mc:MovieClip, name:String, depth:Number, display:Array, props:Object)
		var tf:TextField = createTF(mc, "displayText", 1, $display, $props);
		return(tf);
	}
	
	/*
	==========================================================================
	Color Utils
	==========================================================================
	*/
	
	/*
	
	Function: changeColor
	
	Changes color of movieclip to hex value
	
	Parameters:
	
		mc - movieclip
		rgb - hex value of new color
		
	Returns: 
		
		color
	
	*/
	
	public static function changeColor(mc:MovieClip, rgb:Number) : Color
	{
		var c = new Color(mc);
		c.setRGB(rgb);
		return c;
	}
	
	/* 
	
	Function: hexToRgb
	
	Converts hex (0x000000) to rgb (r 0-255 g 0-255 b 0-255) values
	
	Parameters: 
	
		hex - color in hex format
		
	Returns: 
		
		object with r,g,b properties
	
	*/
	
	public static function hexToRgb(hex) : Object
	{
		var rgb24 = (isNaN(hex)) ? parseInt(hex, 16) : hex;
		var r = rgb24 >> 16;
		var g = (rgb24 ^ (r << 16)) >> 8;
		var b = (rgb24 ^ (r << 16)) ^ (g << 8);
		return {r:r, g:g, b:b};
	}
	
}