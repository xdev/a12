package com.a12.util
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	public class FileUploader extends EventDispatcher
	{
		
		private var transferA:Array;
		private var queueA:Array;
		private var _url:URLRequest;
		private var fileReference:FileReference;
		
		public function FileUploader(url:String,fileA:Array)
		{
			_url = new URLRequest(url);
			transferA = [];
			queueA = fileA;
			
			uploadFile();
			
		}
		
		public function uploadFile():void
		{
			fileReference = queueA[0];
			fileReference.upload(_url);
			fileReference.addEventListener(ProgressEvent.PROGRESS,handleProgress,false,0,true);
			fileReference.addEventListener(Event.COMPLETE,handleComplete,false,0,true);
		}
				
		private function handleProgress(e:ProgressEvent):void
		{
			dispatchEvent(new CustomEvent('onFileUploadProgress',true,false,{obj:e.target}));
		}
		
		private function handleComplete(e:Event):void
		{
			dispatchEvent(new CustomEvent('onFileUploadComplete',true,false,{obj:e.target}));
			var complete:Boolean = false;
			if(queueA.length > 0){
				transferA.push(queueA.shift());
				if(queueA.length == 0){
					complete = true;	
				}
			}else{
				complete = true;
			}
			
			if(complete){
				dispatchEvent(new CustomEvent('onComplete',true,false,{obj:e.target}));
			}else{
				uploadFile();	
			}
			
		}

	}
}