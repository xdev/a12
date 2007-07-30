import com.a12.util.*;

class com.a12.ui.CheckBox
{

	public function CheckBox(cCheck,label,_config)
	{
	
		
		
		Utils.createmc(cCheck,"back",0,{_alpha:100});
		Utils.createmc(cCheck,"nip",1,{_x:6,_y:6,_alpha:30});
		Utils.createmc(cCheck,"label",2);
		Utils.createmc(cCheck,"hitzone",3);
		
		if(label != '' || label != undefined){
			Utils.makeTextfield(cCheck.label, label, _config.tf_label, {_x:_config.modH + _config.padding,_y:2} );
		}
		
		Utils.drawRect(cCheck.back,_config.modH,_config.modH,_config.clr_primary,100);
		Utils.drawRect(cCheck.nip,8,8,_config.clr_focus,100);
		
		//Utils.drawRect(cCheck.hitzone,24 + cCheck.label._width ,20,0xFFFFFF,0);
		//cCheck.hitArea = cCheck.hitzone;
		
		
		cCheck.onSetFocus = function(oldFocus){
			//this.back._alpha = 100;
		}
		cCheck.onKillFocus = function(newFocus){
			//this.back._alpha = 40;
		}
		
		cCheck.setState = function(){
		
			if(this.checked == true){
				Utils.changeProps(this.nip,{_alpha:100},5);
			}else{
				
				Utils.changeProps(this.nip,{_alpha:30},5);
			}
		}
		
				
		cCheck.setState();
		
		cCheck.onPress = function(){				
			this.checked = !this.checked;
			this.setState();
		}
			
			
			
		
		
	
	
	}
	
	public function getValue()
	{
	
	}

}