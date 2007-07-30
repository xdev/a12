import com.a12.util.*;
import com.a12.ui.*;
import com.a12.modules.form.Validator;

class com.a12.modules.form.Form
{
	
	private	var _ref				: MovieClip;
	private	var _formXML			: XMLNode;
	private	var _fieldsA			: Array;
	private	var _checkboxesA		: Array;
	private	var _radioA				: Array;
	private	var _myForm				: MovieClip;
	private	var _config				: Object;
	private	var _pullListener		: Object;
	private	var _hiddenA			: Array;
	private	var _contentClip		: MovieClip;
	public	var pageA				: Array;	
	public	var pageIndex			: Number;
	public	var	statusBroadcaster	: Object;
	
	public function Form(clip:MovieClip,xml:XMLNode,config:Object)
	{
		
		statusBroadcaster = new EventBroadcaster();
		
		// this an easy way of doing it
		MovieClip.prototype.getNextDepth = function() {
			if (this.$depth == undefined) {
				this.$depth = 0;
			}
			this.$depth++;
			return(this.$depth);
		}
		
		
		_focusrect = false;
		
		_ref = clip;
		_formXML = xml;
		_config = new Object();
		_hiddenA = new Array();
		
		for(var i in config){
			_config[i] = config[i];
		}
		
		var defaultObj = 
		{ 
			back_clr:0xFFFFFF,
			modH:25,
			modW:300,
			padding:10,
			labelY:17
		
		};
		
		for(var i in defaultObj){
			if(_config[i] == undefined){
				_config[i] = defaultObj[i];
			}
		}
		//		
		//
		var yOff = 0;
		_myForm = Utils.createmc(clip, "form", clip.getNextDepth());
		Utils.createmc(_myForm,"tabDepth",1000);
		
				
		_fieldsA = [];
		
		//if we have only 1 page or no pages do something
		var txml = Data.findNodeName(_formXML,"page");
		
		if(txml == undefined){
			_contentClip = Utils.createmc(clip,"page0",5);
			
			for (var i=0;i<_formXML.childNodes.length;i++){
				var node = _formXML.childNodes[i];
				if(node.nodeName == "row"){
					
					var textarea = false;
					var xOff = 0;
					
					//loop through columns
					for(var j=0;j<node.childNodes.length;j++){
						var tnode = node.childNodes[j].childNodes[0];
						
						textarea = _buildItem(tnode,xOff,yOff);
						
						xOff += _config.modW + _config.padding;
						
					}
					
					if(!textarea){
						yOff+= _config.modH + _config.padding + _config.labelY;
					}else{
						yOff+= textarea;
					}
					
					
				}			
				if(node.nodeName == "button"){
					_buildSubmit(node,yOff);
				}
				//yOff = _myForm._height;
			}
		
		}else{
		
			//loop through each page and create that shizzle
			
			pageA = new Array();
			
			for(var pageC=0;pageC<_formXML.childNodes.length;pageC++){
				
				_contentClip = Utils.createmc(clip,"page"+pageC,pageC,{_visible:0});
				pageA.push(_contentClip);
				yOff = 0;
				
			
				
				for(var j=0;j<_formXML.childNodes[pageC].childNodes.length;j++){
					var node = _formXML.childNodes[pageC].childNodes[j];
					
					if(node.nodeName == "row"){
						
						var textarea = false;
						var xOff = 0;
						
						//loop through columns
						for(var k=0;k<node.childNodes.length;k++){
							var tnode = node.childNodes[k].childNodes[0];
							
							textarea = _buildItem(tnode,xOff,yOff);
							
							xOff += _config.modW + _config.padding;
							
						}
						
						if(!textarea){
							yOff+= _config.modH + _config.padding + _config.labelY;
						}else{
							yOff+= textarea;
						}
						
						
					}			
					if(node.nodeName == "button"){
						_buildSubmit(node,yOff);
					}
				}
			}
			
			displayPage(0);
		
		}
		
		
	}
	
	private function _buildItem(tnode,xOff,yOff)
	{
		var textarea = false;
		switch(true){
					
			case tnode.nodeName == "select":
				_buildSelect(tnode,xOff,yOff);
			break;
		
			case tnode.nodeName == "input" && tnode.attributes.type == "text":
				_buildInput(tnode,xOff,yOff);
			break;
			
			case tnode.nodeName == "input" && tnode.attributes.type == "textarea":
				_buildInput(tnode,xOff,yOff);
				textarea = (Number(tnode.attributes.rows) * _config.modH) + _config.padding + _config.labelY;
			break;
			
			case tnode.nodeName == "radioset":
				_buildRadioset(tnode,xOff,yOff);
			break;
			
			case tnode.nodeName == "checkset":
				_buildCheckset(tnode,xOff,yOff);
			break;
			
			case tnode.nodeName == "copy":
				_buildCopy(tnode,xOff,yOff);
			break;
		
		}
		
		return textarea;
		
	}
	
	public function hasPages() : Object
	{
		if(pageA.length > 1){
			return pageA.length;
		}else{
			return false;
		}
	}
	
	public function displayPage(page:Number,validate:Boolean) : Void
	{
		if(validate == true){
			var errors = validatePage();
			if(errors == true){
				pageIndex = page;
				_displayPage(page);
				
			}
		}else{
			pageIndex = page;
			_displayPage(page);
		}	
	}
	
	private function _displayPage(page:Number) : Void
	{
		for(var i=0;i<pageA.length;i++){
			var tPage = pageA[i];
			if(i == page){
				tPage._visible = 1;
			}else{
				tPage._visible = 0;
			}
		}
		statusBroadcaster.broadcastMessage("onPageChange");
	}
	
	public function getPage() : Number
	{
		return pageIndex;
	}
	
	public function getPageHeight() : Number
	{
		return _contentClip._height;
	}
	
	private function _buildCopy(node,xOff,yOff)
	{
		var cField = Utils.createmc(_contentClip, "copy", _contentClip.getNextDepth(), {_x:xOff, _y:yOff});
		Utils.createmc(cField,"txt",1);
		
		if(node.attributes.width == undefined){
			var tw = _config.modW;
			var chars = 255;
		}else{
			var tw = Number(node.attributes.width);
			var chars = 1500;
		}
		
		Utils.makeTextbox(cField.txt,node.firstChild.nodeValue,_config.copy_tf,{_width:tw});
		return cField.txt._height;
	
	}
	
	public function addHidden(name,value) : Void
	{
		_hiddenA.push([name,value]);
	}
	
	
	private function _buildInput(node,xOff,yOff) : Void
	{	
		var cField = Utils.createmc(_contentClip, "field_"+node.attributes.name, _contentClip.getNextDepth(), {_x:xOff, _y:yOff, name:node.attributes.name});
			
		//set text display options
		if(node.attributes.rows != undefined){
			var th = Number(node.attributes.rows) * _config.modH;
			var multi = true;
		}else{
			var th = _config.modH;
			var multi = false;
		}
		
		if(node.attributes.width == undefined){
			var tw = _config.modW;
			var chars = 255;
		}else{
			var tw = Number(node.attributes.width);
			var chars = 1500;
		}
		
		var label = node.attributes.label;
		if(node.attributes.req == "true"){
			label += "*";
		}
		
		Utils.createmc(cField,"label",2,{_x:0,_y:0});
		Utils.makeTextfield(cField.label, label, _config.tf_label , {_x:-2,_y:-4} );
		
		
		var obj = new TextInput(cField,
			{
				clr_primary		: _config.clr_primary,
				clr_focus		: _config.clr_focus,
				labelY			: _config.labelY,
				tf_input		: _config.tf_input,
				th				: th,
				tw				: tw,
				chars			: chars,
				w				: _config.modW,
				h				: _config.modH
			}
		);
					
		_fieldsA.push(
			{
				clip		: cField,
				name		: cField.name,
				obj			: obj,
				page		: _contentClip,
				validate	: node.attributes.validate
			}
		);
		
		cField.txt.displayText.tabIndex = _contentClip.tabDepth.getNextDepth();
	}
	
	private function _buildSelect(node,xOff,yOff) : Void
	{
		var newclip = Utils.createmc(_contentClip, "field_"+node.attributes.name, _contentClip.getNextDepth(), {_x:xOff, _y:yOff+_config.labelY});
		var pull = new Pulldown(newclip,node,
			{
				_width			: _config.modW,
				clr_primary		: _config.clr_primary,
				clr_focus		: _config.clr_focus,
				tf_main			: _config.tf_input,
				textxoff		: 1,
				unitSize		: 25,
				ty				: 3
			},
			
		
			_contentClip.tabDepth.getNextDepth()
		);
		
		_fieldsA.push(
			{
				clip		: newclip,
				name		: node.attributes.name,
				obj			: pull,
				page		: _contentClip,
				validate	: node.attributes.validate
			}
		);
			
		Utils.createmc(newclip,"label",200,{_x:0,_y:-_config.labelY});		
		Utils.makeTextfield(newclip.label, node.attributes.label, _config.tf_label, {_x:-2,_y:-4} );
				
		
		if(_pullListener == undefined){
			_pullListener = new Object();
			_pullListener.onDisplay = function(mc){
				//pop mc to the top
				mc.swapDepths(50);
			}
		}
		
		pull._addListener(_pullListener);
	}
	
	private function _buildCheckset(node,xOff,yOff) : Void
	{
		//blablablablabla
		var cSet = Utils.createmc(_contentClip, "field_"+node.attributes.name, _contentClip.getNextDepth(), {_x:xOff, _y:yOff});
			
		cSet.name = node.attributes.name;
		
		
	
		Utils.createmc(cSet,"label",cSet.getNextDepth());
		Utils.makeTextfield(cSet.label, node.attributes.label, _config.tf_label, {_x:-2,_y:-4});
		
		//
		
		
		var tA = [];
		
		for(var i=0;i<node.childNodes.length;i++){
			var cNode = node.childNodes[i];
			var cCheck = Utils.createmc(cSet,"checkbox_"+i,cSet.getNextDepth(),{_y:((_config.modH + Math.ceil(_config.padding/2)) *i) + _config.labelY});
			tA.push(cCheck);
			
			if(cNode.attributes.checked == "checked"){
				cCheck.checked = true;
			}	
			
			new CheckBox(cCheck,cNode.attributes.label,_config);
			cCheck.tabIndex = _contentClip.tabDepth.getNextDepth();
			
		}
		
		//need to find way to group into checkset or something.. doh
		
		/*
		for(var i=0;i<formCheckBoxes.length;i++){
			
			var name = formCheckBoxes[i];
		
			form_sendData[name] = format_bool(_myForm.checkset_interests["checkbox_"+name].checked);
		
		}
		*/
		
		_fieldsA.push(
			{
				clip		: cSet,
				name		: cSet.name,
				page		: _contentClip,
				validate	: node.attributes.validate
			}
		);
	}
	
	private function _buildRadioset(node,xOff,yOff) : Void
	{
		//blablablablabla
		var cField = Utils.createmc(_contentClip, "field_"+node.attributes.name, _contentClip.getNextDepth(), {_x:xOff, _y:yOff});
			
		var obj = new RadioSet(cField,node,
			{
				config		: _config,
				contentClip	: _contentClip
			
			}
		);
		
		_fieldsA.push(
			{
				clip		: cField,
				name		: node.attributes.name,
				obj			: obj,
				page		: _contentClip,
				validate	: node.attributes.validate
			}
		);
	
		Utils.createmc(cField,"label",cField.getNextDepth());
		Utils.makeTextfield(cField.label, node.attributes.label, _config.tf_label, {_x:-2,_y:-4});
		
		//
		
		//need to find way to push radio set or all radio buttons
		
	}
	
	
	
	private function _buildSubmit(node,yOff) : Void
	{
		var cBut = Utils.createmc(_contentClip, "button_submit", _contentClip.getNextDepth(), {_x:-2, _y:yOff,_alpha:60});
		Utils.createmc(cBut,"label",0);
		
		Utils.makeTextfield(cBut.label, node.attributes.label, _config.tf_label);
		cBut.t = this;
		cBut.onPress = function(){
			this.t.validate();
		}			
		cBut.onRollOver = function(){
			Utils.changeProps(this,{_alpha:100},4);
		}
		cBut.onRollOut = function(){
			Utils.changeProps(this,{_alpha:60},4);
		}
	}
	
	private function _validate(mode:String) : Boolean
	{
		var vData = [];
		
		for(var i in _fieldsA){
			
			switch(mode){
				case 'page':
					
					if(_fieldsA[i].page == pageA[pageIndex]){
						
					}else{
						break;
					}
				
				default :
					
					
					if(_fieldsA[i].validate != undefined){
						var obj = _fieldsA[i];
						vData.push(
							{
								value	: obj.obj.getValue(),
								mode	: obj.validate,
								obj		: obj.obj,
								clip	: obj.obj.cField,
								name	: obj.name
							}
						);
					}
				break;
			}
			
		}
		
		
		var errors = Validator.validateObject(vData);
		if(errors == false){
			return true;
		}else{
			statusBroadcaster.broadcastMessage("onErrors",errors);
			return false;
		}	
	}
	
	public function validate() : Void
	{
		var errors = _validate();
		if(errors == true){
			submit();
		}	
	}
	
	public function validatePage() : Boolean
	{
		var errors = _validate('page');
		return errors;		
	}
	
	private function _formatBool(val) : Number
	{
		if(val == true){
			return 1;
		}else{
			return 0;
		}
	}
	
	public function processResults(_loadData) : Void
	{
		
		if(_loadData.result == "success"){
			statusBroadcaster.broadcastMessage("onPost","success");
			_contentClip.button_submit.enabled = true;
			clear();
		}
		if(_loadData.result == "failed"){
			statusBroadcaster.broadcastMessage("onPost","failed");
			clear();
		}
		if(_loadData.result == "duplicate"){
			statusBroadcaster.broadcastMessage("onPost","duplicate");
			_contentClip.button_submit.enabled = true;
		}
	
	}
		
	public function submit() : Void
	{
		
		//need to be able to switch up from LoadVars and XML transfer
		
		//show a generic tranmission message
		statusBroadcaster.broadcastMessage("onTransmit","inprogress");
		
		_contentClip.button_submit.enabled = false;
	
		var _sendData = new LoadVars();
		var _loadData = new LoadVars();
		
		for(var i=0;i<_fieldsA.length;i++){
			var obj = _fieldsA[i];
			_sendData[obj.name] = obj.obj.getValue();
			trace(obj.obj);
		}
		
		for(var i in _hiddenA){
			_sendData[_hiddenA[i][0]] = _hiddenA[i][1];
		}
		
				
		_loadData._scope = this;			
		_loadData.onLoad = function(){
			this._scope.processResults(this);		
		}
				
		_sendData.sendAndLoad(_config.action + "?nc="+random(30000),_loadData,"POST");
		
	}
	
	public function clear() : Void
	{
		for(var i=0;i<_fieldsA.length;i++){
			var obj = _fieldsA[i].obj;
			obj.setValue('');			
		}
	}
	
	

}
