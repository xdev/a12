import com.a12.util.*;

class com.a12.ui.TextInput implements com.a12.ui.UIElement
{
	
	public	var cField			: MovieClip;
	private	var options			: Object;
	
	//
	public function TextInput(mc,_options){
	
		options = _options;
		
		cField = mc;
	
		Utils.createmc(cField,"back",0,{_x:0,_y:options.labelY,_alpha:100});
		Utils.createmc(cField,"txt",1,{_x:0,_y:options.labelY,_alpha:100});
		
	
		Utils.drawRect(cField.back,options.tw,options.th,options.clr_primary,100);
		//makeTextinput(mc:MovieClip, display:String, x:Number, y:Number, w:Number, h:Number, format:TextFormat, embed:Boolean, multi:Boolean, max_chars:Number, restrictions:String, pass:Boolean) : TextField {
		
		//cField.default_text = node.attributes.text;
		//Utils.makeTextinput(cField.txt, node.attributes.text, 2, 2, tw,th+2,_config.input_tf, true,multi);
		Utils.makeTextinput(cField.txt, options.default_txt, options.tf_input, {_x:2, _y:4, _width:options.tw, _height:options.th+2, multiline:options.multi, max_chars:options.chars} );
		
		//
		cField.clr_primary = options.clr_primary;
		cField.clr_focus = options.clr_focus;
		
		cField.txt.displayText.onSetFocus = function(oldFocus){
			//this._parent._alpha = 100;
			Utils.changeColor(this._parent._parent.back,this._parent._parent.clr_focus);
			//Utils.changeProps(this._parent._parent.back,{_alpha:100},4);
		}
		
		cField._scope = this;
		
		cField.txt.displayText.onKillFocus = function(newFocus){
			
			Utils.changeColor(this._parent._parent.back,this._parent._parent.clr_primary);
			//Utils.changeProps(this._parent._parent.back,{_alpha:50},4);
		}
		
		
	}
	
	public function reset()
	{
		setValue(options.default_txt);
	}
	
	public function getValue()
	{
		return cField.txt.displayText.text;
	}
	
	public function setValue(val) : Void
	{
		cField.txt.displayText.text = val;
	}


}