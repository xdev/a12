package com.a12.managers
{	
	import com.a12.util.CustomEvent;
	import com.a12.util.Utils;
	
	import flash.desktop.NativeApplication;
	import flash.display.MovieClip;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.NativeWindowResize;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.Capabilities;
	
	
	public class WindowManager extends Sprite
	{
		private static var instance:WindowManager = new WindowManager();
		protected var windowA:Array;		
		protected var mainWindow:NativeWindow;
				
		public function WindowManager()
		{
			windowA = [];
		}
		
		public function setMainWindox(window:NativeWindow):void
		{
			mainWindow = window;	
		}
		
		public static function getInstance():WindowManager 
        {
			return instance;
        }
		
		/* API */
		
		public function openWindow(id:String='', _options:Object=null):NativeWindow
		{
			//check for it and focus
			var window:NativeWindow;
			
			window = findWindow(id);

			if(window){
				return window;
			}
			
			var tw:int = 600;
			var th:int = 400;
			var minw:int = 400;
			var minh:int = 300;
			var title:String = '';
			var transparent:Boolean = false;
			var windowType:String = NativeWindowType.NORMAL;
			var windowChrome:String = NativeWindowSystemChrome.STANDARD;
			var resizable:Boolean = true;
			var centered:Boolean = true;
			
			if(_options != null){
				if(_options.width != undefined){
					tw = _options.width;
				}
				if(_options.height != undefined){
					th = _options.height;
				}
				if(_options.minWidth != undefined){
					minw = _options.minWidth;	
				}
				if(_options.minHeight != undefined){
					minh = _options.minHeight;	
				}
				if(_options.title != undefined){
					title = _options.title;	
				}
				if(_options.windowType != undefined){
					windowType = _options.windowType;	
				}
				//defeats the purpose somewhat
				if(tw <= minw){
					minw = tw;	
				}
				if(th <= minh){
					minh = th;	
				}
				if(_options.resizable != undefined){
					resizable = false;
				}
				
				if(_options.windowChrome != undefined){
					windowChrome = _options.windowChrome;	
				}
				
				if(_options.transparent != undefined){
					transparent = _options.transparent;	
				}
					
			}
			
			//or create if doesn't exist
			var options:NativeWindowInitOptions = new NativeWindowInitOptions(); 
			options.systemChrome = windowChrome;
			options.transparent = transparent;
			options.type = windowType;
			options.resizable = resizable;
			if(resizable == false){
				options.maximizable = false;	
			}
			window = new NativeWindow(options);
			window.title = title;

			window.width = tw;
			window.height = th;
			window.minSize = new Point(minw, minh);
			window.stage.scaleMode = 'noScale';
			window.stage.align = 'TL';
			
			if(centered){
				window.x = Math.floor((Capabilities.screenResolutionX / 2) - (tw/2));
				window.y = Math.floor((Capabilities.screenResolutionY / 2) - (th/2)); 
			}
			
			windowA.push({ window:window, id:id, objects:[], mainClass:{} });

			//add event on closing to remove it from stuff oh!
			registerWindow(window);

			return window;
		}

		public function closeWindow(window:NativeWindow):void
		{
			trace('Window.closeWindow');
			var closingEvent:Event = new Event(Event.CLOSING, true, true); 
			window.dispatchEvent(closingEvent);
			
		    if(!closingEvent.isDefaultPrevented()){
		    	trace('NativeWindow.close()');
		    	_getWindow(window).window.close(); 
			}
							
		}
		
		public function setTitle(window:NativeWindow, title:String=''):void
		{
			_getWindow(window).window.title = title;
		}
			
		public function findWindow(id:String, activate:Boolean=true):NativeWindow
		{
			trace('\rWindow.findWindow ', id);
			
			for(var i:int=0;i<windowA.length;i++){
				if(windowA[i].id == id){
					//optional?
					if(activate){
						windowA[i].window.activate();
					}
					return windowA[i].window;
				}
			}
			return null;
		}
		
		public function setMainClass(window:NativeWindow, mc:MovieClip, classobj:Object):void
		{
			window.stage.addChild(mc);
			window.stage.addEventListener(Event.RESIZE, resizeWindows, false, 0, true);
			
			var index:int = getWindowIndex(window);
			if(index != -1){
				windowA[index].mainClass = classobj;
				//classobj.setSize(NativeApplication.nativeApplication.activeWindow.stage.stageWidth, NativeApplication.nativeApplication.activeWindow.stage.stageHeight);
			}
		}
		
		public function getMainClass(window:NativeWindow):*
		{
			var index:int = getWindowIndex(window);
			if(index != -1){
				return(windowA[index].mainClass);
			}	
		}

		/* Private Class Methods */
		
		private function resizeWindows(event:Event=null):void
		{
			for(var i:int=0;i<windowA.length;i++){
				var ts:Stage = windowA[i].window.stage;
				if(ts == Stage(event.currentTarget)){
					windowA[i].mainClass.setSize(NativeApplication.nativeApplication.activeWindow.stage.stageWidth, NativeApplication.nativeApplication.activeWindow.stage.stageHeight);
					break;
				}				
			}
		}
		
		private function getWindowIndex(window:NativeWindow):int
		{
			for(var i:int=0;i<windowA.length;i++){
				if(windowA[i].window == window){					
					return i;
				}
			}
			return -1;
		}
		
		private function registerWindow(window:NativeWindow):void
		{
			//user clicks system chrome, option to prevent
			window.addEventListener(Event.CLOSING, handleClosing, false, 0, true);
			//window is closed internally, or after closing fires
			window.addEventListener(Event.CLOSE, handleClose, false, 0, true);
			
			window.addEventListener(Event.ACTIVATE, onActivate, false, 0, true);
			window.addEventListener(Event.DEACTIVATE, onDeactivate, false, 0, true);
		}
		
		private function handleClose(event:Event):void
		{
			trace('handleClose');
			
			var window:NativeWindow = NativeWindow(event.target);
			
			window.removeEventListener(Event.CLOSING, handleClosing, false);
			window.removeEventListener(Event.CLOSE, handleClose, false);
			window.removeEventListener(Event.ACTIVATE, onActivate, false);
			window.removeEventListener(Event.DEACTIVATE, onDeactivate, false);
		    
		    
		    
		    //remove from our internal lists
		    for(var i:int=0;i<windowA.length;i++){
		    	if(windowA[i].window == window){
		    		
		    		try
					{
						windowA[i].mainClass.onKill();
						windowA[i].mainClass = null;					
					}						
					catch(error:Error)
					{
						
					}
										
		    		removeWindow(window, i);
		    		break;	
		    	}	
		    }
		    
			
		}
				
		private function removeWindow(window:NativeWindow, i:int):void
		{
			if(window.closed == false){
    			window.close();
    		}
    		
    		windowA.splice(i, 1);
    		window = null;
		}
		
		protected function handleClosing(event:Event):void
		{
						
		}
		
		private function onActivate(event:Event):void
		{ 
			var obj:Object = _getWindow(NativeWindow(event.target));
			obj.mainClass.setSize(NativeApplication.nativeApplication.activeWindow.stage.stageWidth, NativeApplication.nativeApplication.activeWindow.stage.stageHeight);
			//TODO: Make optional
			//dispatchStatusChange(e, true);
		}
		
		private function onDeactivate(event:Event):void
		{
			//TODO: Make optional
			//dispatchStatusChange(e, false);
		}
		
		private function _getWindow(window:NativeWindow):Object
		{
			var r:Object = null;
			for(var i:int=0;i<windowA.length;i++){
				if(windowA[i].window == window){
					r = windowA[i];
					break;
				}
			}
			return r;
		}
		
	}
	
}