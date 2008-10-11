package com.a12.modules.mediaplayback
{

	import flash.display.Sprite;
	
	import com.a12.pattern.observer.*;
	import com.a12.modules.mediaplayback.*;	

	dynamic public class MediaPlayback extends Sprite
	{
		private var _model;
		public var _view:CPView;
	
		public function MediaPlayback(ref,file,options:Object=null)
		{
			var ext = file.substr(file.lastIndexOf('.')+1,file.length);
			
			if(ext == 'mp4' || ext == 'mov' || ext == 'm4v' || ext == 'flv'){
				_model = new VideoModel(ref,file,options);
			}
		
			if(ext == 'mp3'){
				_model = new AudioModel(ref,file,options);
			}
			if(options.hasView != false){				
				_view = new CPView(_model,null,options);
				_model.addObserver(_view);
			}
						
		}
		
		/* API Methods */
		
		public function setScale(value:Number):void
		{
			_view.setScale(value);
		}

		public function getDimensions(mode:Boolean=true):Object
		{
			return _view.getDimensions(mode);
		}
		
		public function setWidth(value:Number):void
		{
			_view.setWidth(value);
		}
			
		public function stop():void
		{
			_model.stopStream();
		}
	
		public function pause():void
		{
			_model.pauseStream();
		}
	
		public function play():void
		{
			_model.playStream();
		}
		
		public function toggle():void
		{
			_model.toggleStream();
		}
		
		public function kill():void
		{
			_model.kill();
			_view.kill();
		}
	
	}

}