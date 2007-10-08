import com.a12.util.*;

class com.a12.ui.RadioSet implements com.a12.ui.UIElement
{

	private	var _value			: String;
	
	
	public function RadioSet(cSet,node,config)
	{
		var _config = config.config;
		//code from form class in here
		var colC = 0;
		var rowC = 0;
		var colM = 3;
		
		
		for(var i=0;i<node.childNodes.length;i++){
			var cNode = node.childNodes[i];
			var cCheck = Utils.createmc(cSet,"radio_"+i,cSet.getNextDepth(),{_x:colC * 100,_y:(24*rowC) + _config.labelY});
			
			if(cNode.attributes.checked == "checked"){
				cCheck.checked = true;
			}	
			
			
			var t = Math.floor((_config.modH) / 2);
		
			Utils.createmc(cCheck,"back",0,{_x:_config.modH/2,_y:_config.modH/2});
			Utils.createmc(cCheck,"nip",1,{_x:t+.5,_y:t+.5,_alpha:10});
			Utils.createmc(cCheck,"label",2);
			Utils.createmc(cCheck,"hitzone",3);
			Utils.makeTextfield(cCheck.label, cNode.attributes.label, _config.tf_label, {_x:_config.modH + _config.padding,_y:4} );
			
			
			Utils.drawCircle(cCheck.back,Math.floor(_config.modH/2),_config.clr_primary,100);
			
			//Utils.drawRect(cCheck.back,_config.modH,_config.modH,0xCCCCCC,100);
			
			Utils.drawCircle(cCheck.nip,Math.floor(_config.modH/4),_config.clr_radio_focus,100);
			
			//Utils.drawRect(cCheck.nip,10,10,0x000000,100);
			
			//Utils.drawRect(cCheck.hitzone,_config.modH + _config.padding + cCheck.label._width ,_config.modH,0xFFFFFF,0);
			//cCheck.hitArea = cCheck.hitzone;
			
			cCheck.value = cNode.attributes.value;
			
			cCheck.onSetFocus = function(oldFocus){
				this.back._alpha = 100;
			}
			cCheck.onKillFocus = function(newFocus){
				this.back._alpha = 40;
			}
			
			cCheck.setState = function(){
			
				if(this.checked == true){
					Utils.changeProps(this.nip,{_alpha:100},5);
				}else{
					Utils.changeProps(this.nip,{_alpha:10},5);
				}
			}
			
					
			cCheck.setState();
		
			cCheck._scope = this;
			cCheck.cSet = cSet;
			
			
			
			cCheck.onPress = function(){				
				this.checked = true;
				this.setState();
				this._scope._value = this.value;
				this._scope.setRadios(this.cSet,this);
			}
			
			
			
			cCheck.tabIndex = config.contentClip.tabDepth.getNextDepth();
			
			if(colC<colM){
				colC++;
			}
			if(colC == colM){
				rowC++;
				colC = 0;
			}
			
		}
		
	}
	
	public function getValue()
	{
		return _value;
	}
	
	public function setValue(val) : Void
	{
		//take the string here, loop through items and set the state for the active one.. doh!
	}
	
	public function reset()
	{
		
	}
	
	public function setRadios(name,mc) : Void
	{
		//loop through clips and setState
		for(var i in name){
			//trace(name[i]);
			if(name[i] != mc){
				name[i].checked = false;
				name[i].setState();
			}
		}
	
	}
	
	



}