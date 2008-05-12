/* $Id$ */

package com.a12.modules.mediaplayback
{

	import com.a12.pattern.observer.*;
	import com.a12.modules.mediaplayback.*;


	public class MediaPlayback
	{
		private	var	mp_model;
		private	var	mp_view		: CPView;
	
		public function MediaPlayback(ref,file)
		{
			var ext = file.substr(file.lastIndexOf('.')+1,file.length);
		
			if(ext == 'mp4' || ext == 'mov' || ext == 'm4v' || ext == 'flv'){
				mp_model = new VideoModel(ref,file);
			}
		
			if(ext == 'mp3'){
				mp_model = new AudioModel(ref,file);
			}
				
			mp_view = new CPView(mp_model,undefined);
			mp_model.addObserver(mp_view);
		
						
		}
	
		public function kill()
		{
			mp_model.kill();
		}
	
		public function stop()
		{
			mp_model.stopStream();
		}
	
		public function pause()
		{
			mp_model.pauseStream();
		}
	
		public function play()
		{
			mp_model.playStream();
		}
	
	}

}