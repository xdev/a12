package com.a12.pattern.mvc
{
	
	import com.a12.pattern.observer.*;
	import com.a12.pattern.mvc.*;

	/**
	 * Specifies the minimum services that the "controller" of
	 * a Model/View/Controller triad must provide.
	 */
	public interface Controller {
	  /**
	   * Sets the model for this controller.
	   */
	  function setModel (m:Observable):void;

	  /**
	   * Returns the model for this controller.
	   */
	  function getModel ():Observable;

	  /**
	   * Sets the view this controller is servicing.
	   */
	  function setView (v:View):void;

	  /**
	   * Returns this controller's view.
	   */
	  function getView ():View;
	}

}