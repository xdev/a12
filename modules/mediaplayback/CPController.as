import com.a12.pattern.observer.*;
import com.a12.pattern.mvc.*;

import com.a12.util.*;

import com.a12.modules.mediaplayback.*;

class com.a12.modules.mediaplayback.CPController extends AbstractController
{
	
	public function CPController(m:Observable)
	{
		super(m);		
		
	}
	
	public function toggleSound()
	{
		//
				
		var mod = getModel();
		
		switch(true){
		
			case (mod.soundController.getVolume() == 100):
				mod.soundController.setVolume(0);
			break;
			
			case (mod.soundController.getVolume() == 0):
				mod.soundController.setVolume(100);
			break;
			
		}
	
		//MediaPlaybackModel(getModel()).toggleSound();
		
	}
	
	public function pause()
	{
		var obj = getModel();
		obj.pauseStream();
	}
	
	
	
	
	public function findSeek(percent:Number) : Void
	{
		var obj = getModel();
		obj.seekStreamPercent(percent);
			
	}
	
	
	
}