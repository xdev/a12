package com.a12.pattern.mvc
{

	import com.a12.pattern.observer.*;
	import com.a12.pattern.mvc.*;


	/**
	 * Specifies the minimum services that the "view" 
	 * of a Model/View/Controller triad must provide.
	 */
	public interface View {
	  /**
	   * Sets the model this view is observing.
	   */
	  function setModel (m:Observable):void;

	  /**
	   * Returns the model this view is observing.
	   */
	  function getModel ():Observable;

	  /**
	   * Sets the controller for this view.
	   */
	  function setController (c:Controller):void;

	  /**
	   * Returns this view's controller.
	   */
	  function getController ():Controller;

	  /**
	   * Returns the default controller for this view.
	   */
	  function defaultController (model:Observable):Controller;
	}

}