/* $Id$ */

package com.a12.pattern.mvc
{

	import com.a12.pattern.observer.*;
	import com.a12.pattern.mvc.*;

	/**
	 * Provides basic services for the "controller" of
	 * a Model/View/Controller triad.
	 */
	public class AbstractController implements Controller {
	  private var model:Observable;
	  private var view:View;

	  /**
	   * Constructor
	   *
	   * @param   m   The model this controller's view is observing.
	   */
	  public function AbstractController (m:Observable) {
	    // Set the model.
	    setModel(m);
	  }

	  /**
	   * Sets the model for this controller.
	   */
	  public function setModel (m:Observable):void {
	    model = m;
	  }

	  /**
	   * Returns the model for this controller.
	   */
	  public function getModel ():Observable {
	    return model;
	  }

	  /**
	   * Sets the view that this controller is servicing.
	   */
	  public function setView (v:View):void {
	    view = v;
	  }

	  /**
	   * Returns this controller's view.
	   */
	  public function getView ():View {
	    return view;
	  }
	}

}