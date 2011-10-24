package com.unsafemethods.io {

	/**
	 * @author jonathanpetersson
	 */
	public interface LoaderListener {
		
		function onLoaderDone(loader:AbstractLoader):void;
		function onLoaderFailed(loader:AbstractLoader):void;
		function onLoaderProgressUpdated(loader:AbstractLoader):void;
		
	}
}
