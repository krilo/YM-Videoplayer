package com.unsafemethods.io {

	/**
	 * @author jonathanpetersson
	 */
	public interface QueueLoaderListener {
		
		function onQueueItemDone(queue:QueueLoader, item:AbstractLoader):void;	
		function onQueueItemFailed(queue:QueueLoader, item:AbstractLoader):void;	
		function onQueueProgressUpdated(queue:QueueLoader):void;
		function onQueueDone(queue:QueueLoader):void;	
		
	}
}