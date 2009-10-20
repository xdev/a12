package com.a12.ui
{
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public dynamic class DoubleClickMovieClip extends MovieClip
	{
		private var _timer:Timer;
		public var delay:Number;
		private var _e:MouseEvent;
		
		public function DoubleClickMovieClip()
		{
			doubleClickEnabled = true;
			mouseChildren = false;
			addEventListener(MouseEvent.CLICK, onClick,false,10,true);
			addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick,false,10,true);
			delay = 250;
		}
		
		private function onClick(e:MouseEvent):void
		{
			_e = MouseEvent(e.clone());
			_timer = new Timer(delay,1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);			
			_timer.start();
			e.preventDefault();
			e.stopImmediatePropagation();			
		}
		
		private function onDoubleClick(e:MouseEvent):void
		{
			_e = MouseEvent(e.clone());
			e.preventDefault();
			e.stopImmediatePropagation();
			
			if(_timer != null){
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);
				_timer = null;
				removeEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick,false);
				dispatchEvent(MouseEvent(_e));
				addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick,false,10,true);
			}
		}
		
		private function onTimerComplete(e:TimerEvent):void
		{
			removeEventListener(MouseEvent.CLICK, onClick, false);
			dispatchEvent(MouseEvent(_e));
			addEventListener(MouseEvent.CLICK, onClick,false,10,true);
			
			if(_timer){
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);
				_timer = null;
			}
			
		}
		
	}
	
}