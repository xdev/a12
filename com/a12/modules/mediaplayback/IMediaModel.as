package com.a12.modules.mediaplayback
{
	import flash.display.MovieClip;
	
	public interface IMediaModel
	{
		function stopStream():void;
		
		function playStream():void;
		
		function pauseStream():void;
		
		function toggleStream():void;
		
		function seekStream(time:Number):void;
		
		function seekStreamPercent(percent:Number):void;		
		
		function getMode():String;
		
		function getRef():MovieClip;
		
		function kill():void;
		
	}
	
}