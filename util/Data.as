/*

Class: Data

*/


/** 
 * General Data class designed to load, store and process data.
 * Last Updated: 02.18.07
 */
 
import com.a12.util.Utils; 

class com.a12.util.Data
{
	
	/** 
	 * Private constructor function prevents object from being instantiated.
	 */
	private function Data()
	{
	
	}
	

	
	/*
	
	Function: loadData
	
	loads data into a provided XML object and executes a result 
	function when fully loaded. Result function must accept XMLNode
	as first argument.
	
	Parameters:
		
		srcXML - string of xml file to load
		xmlObj - xml obj to create
		result - method
		obj - obj
		args - array of arguments to pass (in addition to the xml)
	
	*/	
	
	public static function loadData(srcXML:String, xmlObj:XML, result:Function, obj:Object, args:Array) : Void
	{
		//trace("--Data.loadData Attempting to load " + srcXML);
		xmlObj = new XML;
		xmlObj.ignoreWhite = true;
		xmlObj.onLoad = function(success) {
			if (success) {
				//trace("--Data.loadData Load successful: " + srcXML);
				if (args) {
					args.unshift(xmlObj);
					result.apply(obj, args);
				} else {
					result.apply(obj, [xmlObj]);
				}
			} else {
				trace("--Data.loadData Load failed: " + srcXML);
			}
		}
		xmlObj.load(srcXML);
	}
	
	/*
	
	Function: findNodeAttributeArray
	
	Searchs xml and finds a node that matches multiple attributes
	
	Parameters:
	
		node - XMLNode
		nName - node name to search for
		aArray - array of attribute names and values to search for
		
	Returns:
	
		XMLNode
	
	*/
	
	public static function findNodeAttributeArray(node:XMLNode, nName:String, aArray:Array, result:Function, obj:Object) : XMLNode
	{
		var foundNode:XMLNode;
		var tempNode:XMLNode;
		
		function searchNode(tempNode:XMLNode) : Void 
		{
			var leni:Number = tempNode.childNodes.length;
			for (var i=0;i<leni;i++) {
				if(nName && aArray){
					if(tempNode.childNodes[i].nodeName == nName){
						var foundC = 0;
						for(var j in tempNode.childNodes[i].attributes){
							
							for(var k=0;k<aArray.length;k++){
								if(tempNode.childNodes[i].attributes[j] == aArray[k].att_value && j == aArray[k].att_name){
									foundC++;
								}
							
							}
							
							if(foundC == aArray.length){
								foundNode = tempNode.childNodes[i];
								break;
							}
							
						
							
						}
					}
					
				}
				
				if (tempNode.childNodes.length >= 1) {
					searchNode(tempNode.childNodes[i]);
				}
			
			}
			
			
			
		}
		
		searchNode(node);
			
			if (foundNode) {
			
			return(foundNode); // exit function, return found node
		} else {
			//trace("--findNode: Node does not exist.")
			return(undefined);
		}
	
	}
	
	/*
	
	Function: findNode
	
	Searches an XMLNode for 'node name' and/or 'attribute name' and/or 'attribute value' 
	and executes a result function. Result function must accept XMLNode as first argument.
	 
	Parameters:
	
		node - XMLNode
		nName - node name
		aName - attribute name
		aValue - attribute value
		result - method
		obj - object
		args - array of arguments to send
		
	Returns: 
		
		XMLNode
	
	*/
	
	public static function findNode(node:XMLNode, nName:String, aName:String, aValue:String, result:Function, obj:Object, args:Array) : XMLNode
	{
		
		var foundNode:XMLNode;
		var tempNode:XMLNode;
		var searchNode:Object;
		
		// Recursive search function
		function searchNode(tempNode:XMLNode) : Void {
			var leni:Number = tempNode.childNodes.length;
			for (var i=0;i<leni;i++) {
				
				if (nName && aName && aValue) {
					if (tempNode.childNodes[i].nodeName == nName) {
						for (var j in tempNode.childNodes[i].attributes) {
							if (j == aName && tempNode.childNodes[i].attributes[j] == aValue) {
								//trace("--Data:findNode found nName, aName, aValue");
								foundNode = tempNode.childNodes[i];
								break;
							}
						}
					}
				}
				
				if (nName && aName && !aValue) { 
					if (tempNode.childNodes[i].nodeName == nName) {
						for (var j in tempNode.childNodes[i].attributes) {
							if (j == aName) {
								//trace("--Data:findNode found nName, aName");
								foundNode = tempNode.childNodes[i];
								break;
							}
						}
					}
				}
				
				if (nName && !aName && aValue) {
					if (tempNode.childNodes[i].nodeName == nName) {
						for (var j in tempNode.childNodes[i].attributes) {
							if (tempNode.childNodes[i].attributes[j] == aValue) {
								//trace("--Data:findNode found nName, aValue");
								foundNode = tempNode.childNodes[i];
								break;
							}
						}
					}
				}
				
				if (nName && !aName && !aValue) {
					if (tempNode.childNodes[i].nodeName == nName) {
						//trace("--Data:findNode found nName");
						foundNode = tempNode.childNodes[i];
						break;
					}
				}
				
				if (!nName && aName && aValue) { 
					for (var j in tempNode.childNodes[i].attributes) {
						if (j == aName && tempNode.childNodes[i].attributes[j] == aValue) {
							//trace("--Data:findNode found aName, aValue");
							foundNode = tempNode.childNodes[i];
							break;
						}
					}
				}
				
				if (!nName && aName && !aValue) { 					
					for (var j in tempNode.childNodes[i].attributes) {
						if (j == aName) {
							//trace("--Data:findNode found aName");
							foundNode = tempNode.childNodes[i];
							break;
						}
					}
				}
				
				if (!nName && !aName && aValue) { 
					for (var j in tempNode.childNodes[i].attributes) {
						if (tempNode.childNodes[i].attributes[j] == aValue) {
							//trace("--Data:findNode found aValue");
							foundNode = tempNode.childNodes[i];
							break;
						}
					}
				}
				
				if (tempNode.childNodes.length >= 1) {
					searchNode(tempNode.childNodes[i]);
				}
			}
		}
		searchNode(node);
		
		// breakpoint reentry
		if (foundNode) {
			if (result) {
				if (args) {
					args.unshift(foundNode);
					result.apply(obj, args);
				} else {
					result.apply(obj, [foundNode]);
				}
			}
			return(foundNode); // exit function, return found node
		} else {
			//trace("--findNode: Node does not exist.")
			return(undefined);
		}
		
	}
	
	
	/*
	
	Function: findNodeName
	
	Shortcut to findNode Method
	
	Parameters:
	
		node - XMLNode
		nName - node name
		result - method
		obj - object
		args - array of arguments to pass
	
	Returns:
		
		XMLNode
	
	*/
	
	public static function findNodeName(node:XMLNode, nName:String, result:Function, obj:Object, args:Array) : XMLNode
	{
		// pass everything to findNode and return result
		return(findNode(node, nName, undefined, undefined, result, obj, args));
	}
	
	/*
	
	Function: hasAttributeValue
	
	Checks to see if a node has an attribute value
	
	Parameters:
	
		node - XMLNode
		aName - attribute name
		aValue - attribute value
		
	Returns:
	
		Boolean
		
	*/	
	
	public static function hasAttributeValue(node:XMLNode, aName:String, aValue:String) : Boolean
	{
		var tA = new Array();
		tA = node.attributes[aName].split(" ");
		
		if(tA.length > 0){
			if(Utils.inArray(tA,aValue)){
				return true;
			}
		}else{
			if(node.attributes[aName] == aValue){
				return true;
			}
		}
		
		return false;		
	
	}	

}


	