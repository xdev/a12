import event.*;

/**
 * Manages a list of objects registered to receive events (i.e., instances 
 * of a class that implements EventListener). This class is used by an event
 * source to store its listeners.
 */
class event.EventListenerList {
  // The listener objects.
  private var listeners:Array;

  /**
   * Constructor
   */
  public function EventListenerList () {
    // Create a new array in which to store listeners.
    listeners = new Array();
  }

  /**
   * Adds a listener to the list.
   *
   * @param   l   The listener to add. Must implement EventListener.
   */
  public function addObj (l:EventListener):Boolean {
    // Search for the specified listener.
    var len:Number = listeners.length;
    for (var i = len; --i >= 0; ) {
      if (listeners[i] == l) {
        return false;
      }
    }

    // The new listener is not already in the list, so add it.
    listeners.push(l);
    return true;
  }

  /**
   * Removes a listener from the list.
   *
   * @param   l   The listener to remove. Must implement EventListener.
   */
  public function removeObj (l:EventListener):Boolean {
    // Search for the specified listener.
    var len:Number = listeners.length;
    for (var i:Number = len; --i >= 0; ) {
      if (listeners[i] == l) {
        // We found the listener, so remove it.
        listeners.splice(i, 1);
        // Quit looking.
        return true;
      }
    }
    return false;
  }

  /**
   * Returns the complete list of listeners, used during event notification.
   */
  public function getListeners ():Array {
    // Return a copy of the list, not the list itself.
    return listeners.slice(0);
  }
}