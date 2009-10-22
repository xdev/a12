package com.a12.util
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.DataEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	public class FileUploader extends EventDispatcher
	{
		
		private var transferA:Array;
		private var queueA:Array;
		private var _url:URLRequest;
		private var fileReference:FileReference;
		private var transferProgress:Number;
		private var transferTotal:Number;
		private var expectsData:Boolean;
		
		public function FileUploader(url:String,fileA:Array)
		{
			_url = new URLRequest(url);
			transferA = [];
			queueA = fileA;
			
			transferTotal = 0;
			transferProgress = 0;
			for(var i:int=0;i<queueA.length;i++){
				transferTotal += queueA[i].file.size;
			}			
		}
		
		public function uploadFile():void
		{
			fileReference = queueA[0].file;
			fileReference.upload(_url);
			fileReference.addEventListener(ProgressEvent.PROGRESS,handleProgress,false,0,true);
			fileReference.addEventListener(Event.COMPLETE,handleComplete,false,0,true);
			if(queueA[0].data){
				expectsData = true;
				fileReference.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,handleData,false,0,true);
			}else{
				expectsData = false;	
			}
		}		
				
		private function handleProgress(e:ProgressEvent):void
		{
			var p:Number = e.bytesLoaded / e.bytesTotal;
			var obj:Object = {};
			
			obj.filePercent = p;
			obj.file = e.target;
			obj.queueTotal = transferTotal;
			obj.queuePercent = (transferProgress + e.bytesLoaded) / transferTotal; 
			obj.queueProgress = transferProgress + e.bytesLoaded;
			
			dispatchEvent(new CustomEvent('onFileUploadProgress',true,false,obj));
		}
		
		private function handleData(e:DataEvent):void
		{
			advanceQueue(e,e.data);
		}
		
		private function advanceQueue(e:*,data:*=null):void
		{
			var complete:Boolean = false;
			if(queueA.length > 0){
				transferA.push({file:queueA.shift(),data:data});
				transferProgress += transferA[transferA.length-1].size;
				if(queueA.length == 0){
					complete = true;	
				}
			}else{
				complete = true;
			}
			
			if(complete){
				dispatchEvent(new CustomEvent('onComplete',true,false,{fileA:transferA}));
			}else{
				uploadFile();
			}
		}
		
		private function handleComplete(e:Event):void
		{
			dispatchEvent(new CustomEvent('onFileUploadComplete',true,false,{obj:e.target}));
			if(!expectsData){
				advanceQueue(e);				
			}
			
		}

	}
}