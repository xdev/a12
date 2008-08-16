import com.a12.pattern.observer.*;
import com.a12.modules.mediaplayback.*;


class com.a12.modules.mediaplayback.MediaPlayback
{
	private	var	mp_model;
	private	var	mp_view		: CPView;
	
	public function MediaPlayback(ref,file)
	{
		if(file.lastIndexOf('.flv') == file.length - 4){
			mp_model = new VideoModel(ref,file);
		}
		if(file.lastIndexOf('.mp3') == file.length - 4){
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