import com.a12.pattern.observer.*;
import com.a12.pattern.mvc.*;


/**
 * Specifies the minimum services that the "view" 
 * of a Model/View/Controller triad must provide.
 */
interface com.a12.pattern.mvc.View {
  /**
   * Sets the model this view is observing.
   */
  public function setModel (m:Observable):Void;

  /**
   * Returns the model this view is observing.
   */
  public function getModel ():Observable;

  /**
   * Sets the controller for this view.
   */
  public function setController (c:Controller):Void;

  /**
   * Returns this view's controller.
   */
  public function getController ():Controller;

  /**
   * Returns the default controller for this view.
   */
  public function defaultController (model:Observable):Controller;
}