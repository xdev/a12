import com.a12.pattern.observer.*;
import com.a12.pattern.mvc.*;

/**
 * Specifies the minimum services that the "controller" of
 * a Model/View/Controller triad must provide.
 */
interface com.a12.pattern.mvc.Controller {
  /**
   * Sets the model for this controller.
   */
  public function setModel (m:Observable):Void;

  /**
   * Returns the model for this controller.
   */
  public function getModel ():Observable;

  /**
   * Sets the view this controller is servicing.
   */
  public function setView (v:View):Void;

  /**
   * Returns this controller's view.
   */
  public function getView ():View;
}