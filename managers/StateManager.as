/**
 *
 * StateManager.as
 *
 *     Adds state management (back button and deep-linking) to your flash app.
 *     For usage instructions, see <http://exanimo.com/actionscript/statemanager/>.     
 *
 *     @author     matthew at exanimo dot com
 *     @version    2007.04.30
 *
 */




import flash.external.ExternalInterface;
import mx.events.EventDispatcher;




class com.a12.managers.StateManager
{


    private static var _eventDispatcherInitializer = EventDispatcher.initialize(StateManager);
	private static var _isSetup:Boolean = StateManager._setup();


    // The current stateChange event.
    private static var event:Object;

	// The default value of defaultStateID.
	private static var DEFAULT_STATE:String = 'defaultState';
	
	// The ID of the default state.
	private static var _defaultStateID:String;
	
    // Event Dispatcher functions.
    public static var addEventListener:Function;
    public static var removeEventListener:Function;
    public static var dispatchEvent:Function;


	/**
	 *
	 * Allow the user to get and set the id of the default state.
	 *
	 */
	public static function set defaultStateID(defaultStateID:String):Void
	{
		StateManager._defaultStateID = defaultStateID;
		ExternalInterface.call('eval', 'EXANIMO.managers.StateManager.defaultStateID="' + defaultStateID.split('"').join('\\"') + '"');
	}
	public static function get defaultStateID():String
	{
		return StateManager._defaultStateID == null ? StateManager.DEFAULT_STATE : StateManager._defaultStateID;
	}


	/**
	 *
	 * Automatically add the required callback functions.
	 *
	 */
	private static function _setup():Boolean
	{
		ExternalInterface.addCallback('dispatchStateChangeEvents', null, StateManager._dispatchEvent);
		return true;
	}


    /**
     *
     * Initializes the StateManager.
     *
     */
    public static function initialize():Void
    {
        ExternalInterface.call('EXANIMO.managers.StateManager.initialize', true);
    }
	

    /**
     *
     * Log a state change.
     *
     *     @param id          the id of the state you want to load
     *
     */
    public static function setState(id:String, title:String):Void
    {
        // If the state hasn't been set, set it.
        if (!StateManager.event)
        {
            ExternalInterface.call('EXANIMO.managers.StateManager.setState', id, title);
            StateManager._dispatchEvent(id, true);
        }
        
        // Otherwise, just set the title.
        else
        {
            ExternalInterface.call('EXANIMO.managers.StateManager.setTitle', title);
        }
    }

    
    /**
     *
     * Dispatch a stateChange event.
     *
     *     @param id         the id of the new state
     *     @param manual     was the stateChange manual? manual changes are the
     *                       result of calls to setState. (automatic changes
     *                       are the result of the back / forward buttons or
     *                       deep-linking.)
     */
    private static function _dispatchEvent(id:String, manual:Boolean):Void
    {
        // Dispatch a stateChange event.
        StateManager.event = {target: StateManager, type: 'stateChange', id: id};
        StateManager.dispatchEvent(StateManager.event);
        
        if (manual)
        {
            var e:Object = {target: StateManager, type: 'stateSet', id: id};
            StateManager.dispatchEvent(e);
        }
        else
        {
            var e:Object = {target: StateManager, type: 'stateRevisit', id: id};
            StateManager.dispatchEvent(e);
        }
        
        StateManager.event = null;        
    }
    

    /**
     *
     * Sets the title for the state.
     *
     *     @param title    the String to show in your browser's title bar
     *
     */
    public static function setTitle(title:String):Void
    {
        ExternalInterface.call('EXANIMO.managers.StateManager.setTitle', title);
    }




}




// Copyright (c) 2007 matthew john tretter.  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.