/*

Class: TabManager
Manages an array of MovieClips that are bestowed with tab properties

*/

class com.a12.managers.TabManager
{
	
	private	var	dataA		: Array;
	private var tabC		: Number;
	
	/*
	
	Constructor: TabManager	
	
	*/
	
	public function TabManager()
	{
		tabC = 1;
		dataA = new Array();
	}
	
	/*
	
	Method: addItem
	Adds object to array and enables it's tab properties
	
	Parameters:
		
		obj - movieclip to be added
		
	*/
	
	public function addItem(obj:MovieClip) : Void
	{
		//insert into array if not in
		obj.tabEnabled = true;
		obj.tabChildren = false;
		obj.focusEnabled = true;
		obj.tabIndex = tabC;
		
		dataA.push(obj);
		
		tabC++;
	
	}
	/*
	
	Method: removeItem
	Removes object from array and removes it's tab properties
	
	Parameters:
		
		obj - movieclip to be removed
	
	*/
	
	public function removeItem(obj) : Void
	{
		//remove it
	}
	
}


