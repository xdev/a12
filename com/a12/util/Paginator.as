package com.a12.util
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextLineMetrics;
	import flash.text.StyleSheet;
	import flash.geom.Rectangle;
	
	import com.a12.util.Utils;
	
	public class Paginator
	{
		private var tf:TextField;
		private var pageA:Array;
		private var lineStart:int;
		private var lineEnd:int;
		private var lineIndex:int;
		private var options:Object;
		private var format:TextFormat;
		private var height:int;
		
		public function Paginator(content:String, height:int, format:TextFormat, options:Object)
		{
			this.height = height;
			this.format = format;
			this.options = options;
			
			pageA = [];
			tf = Utils.createTextField(content, format, options);
			//hack http://onlearnevent.blogspot.com/2009/04/textfield-getcharboundaries.html
			tf.height = tf.textHeight + 5;
			
			var lineStart:int = 0;
			var lineEnd:int;
			
			if(tf.textHeight > height){
				for(lineIndex=0;lineIndex<tf.numLines;lineIndex++){
					var r:Rectangle = tf.getCharBoundaries(tf.getLineOffset(lineIndex)+1);
					//if we're over our cutoff, take everything out and copy to a new page
					try {
						if(r.y > ((pageA.length+2)*height) - height ){
							addPage();
						}
					} catch(error:Error){
						//this is the last page
						addPage();
					}
				}
			}else{
				pageA.push(Utils.createTextField(content, format, options));
			}
		}
		
		private function addPage():void
		{
			/*
			let's be sure to jump back 1 line, ok? or not
			tricky part, match the html text.. etc DOH, find opening tag, so we can close and then reopen on the next page
			or we can go character by character and copy over the TextFormat, whatever, this is probably the best idea, but SLOW, oh wells
			lastly, we're not supporting html at this point
			*/
			
			lineEnd = lineIndex;
			
			var startIndex:int = tf.getLineOffset(lineStart);
			var endIndex:int = tf.getLineOffset(lineEnd) + tf.getLineLength(lineEnd);
			var t:String = tf.text.substring(startIndex, endIndex);
			
			//we can't use a stylesheet anymore, so strip it out
			options.styleSheet = null;
			var pageTf:TextField = Utils.createTextField(t, format, options);
			var offset:int = 0;
			for(var ind:int=startIndex;ind<endIndex;ind++){
				pageTf.setTextFormat(tf.getTextFormat(ind), offset);
				offset++;
			}
			pageA.push(pageTf);
			lineStart = lineEnd;
		}
		
		public function getPages():Array
		{
			return pageA;
		}
	}
}