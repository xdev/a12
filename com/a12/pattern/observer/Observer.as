package com.a12.pattern.observer
{

	import com.a12.pattern.observer.Observable;

	/**
	 * The interface that must be implemented by all observers of an
	 * Observable object.
	 */
	public interface Observer {
	  /**
	   * Invoked automatically by an observed object when it changes.
	   * 
	   * @param   o   The observed object (an instance of Observable).
	   * @param   infoObj   An arbitrary data object sent by 
	   *                    the observed object.
	   */
	  function update(o:Observable, infoObj:Object):void;
	}

}