import com.a12.pattern.observer.*;
import com.a12.pattern.mvc.*;

import com.a12.modules.mediaplayback.*;

import com.a12.util.*;

class com.a12.modules.mediaplayback.CPView extends AbstractView
{

	private var _ref		: MovieClip;
	private	var	height		: Number;
	private	var width		: Number;
	private	var stripW		: Number;

	public function CPView(m:Observable,c:Controller)
	{
			
		super(m,c);
		width = 320;
		height = 240;
		
		stripW = 120;
		
		var obj = getModel();
		_ref = obj.getRef();		
		
		//renderUI();
		
				
	}
	
	
	public function defaultController(m:Observable) : Controller
	{
		return new CPController(m);
	}
	
	public function update(o:Observable, infoObj:Object) : Void
	{
		if(infoObj.stream != undefined){
			
			
		}
		if(infoObj.mode != undefined){
			_ref.controls.icon_playpause.gotoAndStop("icon_" + infoObj.icon);
		}
		if(infoObj.action == 'updateView'){
			updateView(infoObj);
		}
		if(infoObj.action == 'mediaComplete'){
			_ref.controls.icon_playpause.gotoAndStop("icon_pause");
		}

	}	
	
	private function updateView(infoObj)
	{
		
		var label = '';
		
		label += Utils.padZero(infoObj.time_current.minutes) + ':' + Utils.padZero(infoObj.time_current.seconds);
		
		if(infoObj.time_duration != undefined){
			label += '/' + Utils.padZero(infoObj.time_duration.minutes) + ':' + Utils.padZero(infoObj.time_duration.seconds);
		}
		
		_ref.controls.timeline.label.displayText.text = label;
		
		
		var factor = (width-stripW) / 100;
		
		//if dragging false
		if(infoObj.time_percent){
			if(_ref.controls.timeline.scrubber.dragging == false){
				_ref.controls.timeline.scrubber._x = infoObj.time_percent * factor;
			}
		}
		
		Utils.createmc(_ref.controls.timeline,"loader",1,{_y:-2.5});
		Utils.drawRect(_ref.controls.timeline.loader,infoObj.loaded_percent * factor,5,0x73CDE7,100);
		
	}
	
	private function renderUI()
	{
		
		
		_ref.video._scope = this;
		
		
		
		_ref.video.onPress = function()
		{
			CPController(this._scope.getController()).toggle();
		}
		
		Utils.createmc(_ref,"controls",5,{_y:240});
		
		Utils.createmc(_ref.controls,"back",0,{_alpha:90});
		Utils.drawRect(_ref.controls.back,320,20,0xFFFFFF,100);
		
		//attach play/pause button
		
		_ref.controls.attachMovie("icons","icon_playpause",1,{_x:10,_y:10,_scope:this,mode:'pause'});
		_ref.controls.icon_playpause.gotoAndStop("icon_pause");
		
		_ref.controls.icon_playpause.onPress = function()
		{
			
			CPController(this._scope.getController()).toggle();
		}
		
		
		
		//attach timeline
		
		Utils.createmc(_ref.controls,"timeline",2,{_x:30,_y:10});
		Utils.createmc(_ref.controls.timeline,"strip",0,{_y:-2.5,_scope:this});
		Utils.drawRect(_ref.controls.timeline.strip,200,5,0xCCCCCC,100);
		
		Utils.createmc(_ref.controls.timeline,"strip_hit",-1,{_y:-5});
		Utils.drawRect(_ref.controls.timeline.strip_hit,200,10,0xCCCCCC,0);
		
		_ref.controls.timeline.strip.hitArea = _ref.controls.timeline.strip_hit;
		
		_ref.controls.timeline.strip.onPress = function()
		{
			CPController(this._scope.getController()).findSeek(this._xmouse / 200);
		}
		
		_ref.controls.timeline.attachMovie("icons","scrubber",10,{_scope:this,dragging:false});
		_ref.controls.timeline.scrubber.gotoAndStop("icon_scrub");
		
		
		_ref.controls.timeline.scrubber.onPress = function(){
			this.startDrag(false,0,0,200,0);
			this.dragging = true;
			//deactivate the scrubber from receiving time updates
		}
		
		_ref.controls.timeline.scrubber.onRelease = function()
		{	
			this.dragging = false;
			this.stopDrag();
			CPController(this._scope.getController()).findSeek(this._x / 200);			
			
			//reactivate the scrubber for time updates
		}
		
		//attach scrubber
		var tf = new TextFormat();
		tf.font = "standard 07_55";
		tf.size = 8;
		tf.color = 0x000000;
		
		Utils.createmc(_ref.controls.timeline,"label",3,{_x:204,_y:-5});
		Utils.makeTextbox(_ref.controls.timeline.label,"00:00/00:00",tf,{selectable: false});
	
		//attach audio buttons
		_ref.controls.attachMovie("icons","icon_audio",10,{_x:305,_y:10,_scope:this});
		_ref.controls.icon_audio.gotoAndStop("icon_audio");
		
		_ref.controls.icon_audio.onPress = function()
		{
			CPController(this._scope.getController()).toggleSound();
		}
		
		
	}	
	


}