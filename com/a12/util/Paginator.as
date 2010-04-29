package com.a12.util
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.StyleSheet;
	
	public class Paginator extends Sprite
	{
		public function Paginator(content:String, width:int, height:int, options:Object)
		{
			//create a textfield, get all the details about it
			var tf:TextField = new TextField();
			tf.width = width;
			/*tf.height = 10;*/
			tf.embedFonts = true;
			tf.wordWrap = true;
			tf.multiline = true;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.condenseWhite = false;
			
			tf.text = content;
			tf.htmlText = content;
						
			if(options.format){
				tf.defaultTextFormat = options.format;
				tf.setTextFormat(options.format);
			}
			if(options.styleSheet){
				tf.styleSheet = options.styleSheet;
			}	
			
			trace(tf.htmlText, tf.textHeight, tf.numLines);
			
		}
		
		public function getData():Array
		{
			return [];
		}
	}	
}