package com.a12.display
{
	import com.a12.display.A12MovieClip;
	
	dynamic public class Rectangle extends com.a12.display.A12MovieClip
	{
		
		public function Rectangle(w:Number, h:Number, rgb:Number, alpha:Number = 1.0, lineStyle:Array = null, x:Number = 0, y:Number = 0)
		{
			super();
			graphics.moveTo(x, y);
			graphics.beginFill(rgb, alpha);
			if(lineStyle != null){
				graphics.lineStyle(lineStyle[0], lineStyle[1], lineStyle[2]);
			}
			graphics.drawRect(x,y,w,h);
			graphics.endFill();
		}		
		
	}
	
}