/* $Id$ */

package com.a12.modules.mediaplayback
{

	import com.a12.pattern.observer.*;
	import com.a12.modules.mediaplayback.*;


	public class MediaPlayback
	{
		private var _model;
		private var _view:CPView;
	
		public function MediaPlayback(ref,file)
		{
			var ext = file.substr(file.lastIndexOf('.')+1,file.length);
		
			if(ext == 'mp4' || ext == 'mov' || ext == 'm4v' || ext == 'flv'){
				_model = new VideoModel(ref,file);
			}
		
			if(ext == 'mp3'){
				_model = new AudioModel(ref,file);
			}
							
			_view = new CPView(_model,null);
			_model.addObserver(_view);
						
		}
		
		/* API Methods */
		
		public function setScale(s:Number):void
		{
			_view.setScale(s);
		}

		public function getDimensions(mode:Boolean=true):Object
		{
			return _view.getDimensions(mode);
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
		
		public function kill():void
		{
			_model.kill();
		}
	
	}

}