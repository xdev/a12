class com.a12.modules.Cart
{
		
	private var _shoppingCart:Array;
	private var _ship_method:String;
	
	public function Cart(ship)
	{
		//load or set adaptor... example PayPal Pro
		_shoppingCart = new Array();
		setShipping(ship);
	}

	public function setShipping(str) : Void
	{
		_ship_method = str;
	}
	
	public function getShipping() : String
	{
		return _ship_method;
	}
	
	public function addItem(item) : Void
	{
		var in_cart = false;
		for(var i in _shoppingCart){
			if(_shoppingCart[i].id == item.id){
				in_cart = true;
			}
		}
		if(!in_cart){
			_shoppingCart.push(item);
		}
				
	}
	
	public function getItem(id) : Object
	{
		for(var i in _shoppingCart){
			if(_shoppingCart[i].id == id){
				return _shoppingCart[i];		
			}
		}
	}
	
	public function getLength() : Number
	{
		return _shoppingCart.length;
	}
	
	public function getSubtotal() : Number 
	{
		var subtotal = 0;
		for(var i in _shoppingCart){
			subtotal+= _shoppingCart[i].quantity * Number(_shoppingCart[i].price);
		}
		return subtotal;
	}
	
	public function updateItem(id,quantity) : Boolean
	{
		for(var i in _shoppingCart){
			if(_shoppingCart[i].id == id){
				_shoppingCart[i].quantity = quantity;
				return true;				
			}
		}
		
		return false;
	}
	
	public function deleteItem(id) : Void
	{
		for(var i=0;i<_shoppingCart.length;i++){
			if(_shoppingCart[i].id == id){
				_shoppingCart.splice(i,1);
			}
		}
	
	}
	
	public function getItems() : Array 
	{
		return _shoppingCart;	
	}	

}