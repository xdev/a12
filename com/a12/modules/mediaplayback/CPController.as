/* $Id$ */

package com.a12.modules.mediaplayback
{

	import com.a12.pattern.observer.*;
	import com.a12.pattern.mvc.*;

	import com.a12.util.*;

	import com.a12.modules.mediaplayback.*;

	public class CPController extends AbstractController
	{
	
		private	var	mod:Object;
	
		public function CPController(m:Observable)
		{
			super(m);
			mod = getModel();	
		}
		
		public function toggleSound():void
		{
			mod.toggleSound();		
		}
		
		public function setVolume(value:Number):void
		{
			mod.setVolume(value);		
		}
	
		public function pause():void
		{
			mod.pauseStream();
		}
	
		public function getPlaying():Boolean
		{
			return mod.getPlaying();
		}
	
		public function toggle():void
		{
			mod.toggleStream();
		}
	
		public function play():void
		{
			mod.playStream();
		}	
	
		public function stop():void
		{
			mod.stopStream();
		}	
	
		public function findSeek(percent:Number):void
		{
			mod.seekStreamPercent(percent);
		}

	}

}