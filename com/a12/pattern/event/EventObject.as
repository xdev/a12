/**
 * The base class for an object describing an event. EventObject instances
 * are passed to event methods defined by classes that implement EventListener.
 * Each kind of event should be represented by an EventObject subclass. 
 *
 * Each EventObject instance stores a reference to its event "source", 
 * which is the object that generated event.
 */
class event.EventObject {
  // The source of the event.
  private var source:Object;

  /**
   * Constructor
   *
   * @param   src   The source of the event.
   */
  public function EventObject (src:Object) {
    source = src;
  }
  
  /**
   * Returns the source of the event.
   */
  public function getSource ():Object {
    return source;
  }
}