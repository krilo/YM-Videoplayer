package com.unsafemethods.io {
	import com.unsafemethods.error.UError;

	import flash.utils.Dictionary;

	/**
	 * @author jonathanpetersson
	 */
	public class QueueLoader extends AbstractLoader implements LoaderListener, QueueLoaderListener {

		private var queue							:Array;
		private var currentItem						:AbstractLoader;
		
		private var listeners						:Dictionary;
		
		private var continuousLoad					:Boolean;
		
		/**
		 * This constructor <i>must</i> be called.
		 */
		function QueueLoader() {			
			queue = [];
			listeners = new Dictionary();
			
			super();
		}
		
		/**
		 * If this is TRUE the loader will automatically call reset() when the load is finished. 
		 * This enabled the same QueueLoader to be used continuously. 
		 */
		public function setContinuousLoad(bool:Boolean):void {
			continuousLoad = bool;
		}
		
		/**
		 * Register a new QueueLoaderListener to be notified when something interesting happens.
		 */
		public function addListener(listener:QueueLoaderListener):void {
			listeners[listener] = true;
		}
		
		/**
		 * Unregister a QueueLoaderListener.
		 */
		public function removeListener(listener:QueueLoaderListener):void {
			if(listeners[listener]) delete listeners[listener];
		}
		
		/**
		 * Add an item to be loaded. Since this method takes and AbstractLoader, this item can be anything extending this baseclass. Such as an XMLLoader or another QueueLoader.
		 */
		public function addItem(item:AbstractLoader):void {
			//O(this, "addItem(" + item + ")");
			if(item is QueueLoader) {
				(item as QueueLoader).addListener(this);
			}else if(item is Loader) {
				(item as Loader).addListener(this);
			}else{
				throw new UError("Unsupported AbstractLoader descendant!");
			}
			
			progress.setBytesTotal(progress.getBytesTotal() + item.getProgress().getBytesTotal());
			
			queue.push(item);
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function doStart():Boolean {
			return loadNextItem();
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function doStop():Boolean {
			
			pause();
			queue = [];
			return true;
			
		}
		
		/**
		 * Try to stop the current load item.
		 */
		public function pause():Boolean {
			if(getState() == AbstractLoader.STATE_RUNNING) {
				setState(AbstractLoader.STATE_WAITING);
				
				if(currentItem) {
					return currentItem.stop();
				}
			}
			
			return false;
		}
		
		private function loadNextItem():Boolean {		
			
			if(getState() == AbstractLoader.STATE_RUNNING && queueIsReady()) {
				for(var i:String in queue) {
					var item:AbstractLoader = queue[i];
					if(item.getState() == AbstractLoader.STATE_WAITING) {
						currentItem = item;
						
						//If start fails, load next, or finish if there are no more items.	
						if(item.start()) {
							//O(this, "loadNextItem: true");
							return true;
						}else{
							loadNextItem();
						}
						
						//O(this, "loadNextItem: false");
						return false;
					}
				}
				
				//O(this, "loadNextItem: done");	
				loaded();
				return true;
			}
			
			//O(this, "loadNextItem: busy");	
			return false;
		}
		/**
		 * @inheritDoc
		 */
		protected override function loaded():void {
			super.loaded();
			for(var o:Object in listeners) (o as QueueLoaderListener).onQueueDone(this);

			if(continuousLoad) reset();
		}
		
		/**
		 * This method returns true when there's no Loader running. For instance, right after one loader has finished, or when the entire qeueue is done.
		 */
		protected function queueIsReady():Boolean {
			for(var i:String in queue) {
				var item:AbstractLoader = queue[i];
				
				if(item.getState() == AbstractLoader.STATE_RUNNING) {
					//trace("item BUSY: " + item);
					return false;
				}
			}
			
			return true;
		}
		
		
		public function onLoaderDone(item:AbstractLoader):void {
			onItemDone(item);
		}
		
		public function onLoaderFailed(item:AbstractLoader):void {
			onItemFailed(item);
		}
		
		public function onLoaderProgressUpdated(loader:AbstractLoader):void {
			onProgress();
		}
		
		
		//QueueLoaderListener
		public function onQueueItemDone(queue:QueueLoader, item:AbstractLoader):void { } 		// > 1 level away, ignore
		public function onQueueItemFailed(queue:QueueLoader, item:AbstractLoader):void { 
			for(var o:Object in listeners) (o as QueueLoaderListener).onQueueItemFailed(this, item);
		}
		

		public function onQueueProgressUpdated(queue:QueueLoader):void {
			
		}
		
		public function onQueueDone(queue:QueueLoader):void {
			onItemDone(queue);
		}
		
		public function toArray():Array {
			return queue;
		}		
		
		private function onItemDone(item:AbstractLoader):void {
			for(var o:Object in listeners) (o as QueueLoaderListener).onQueueItemDone(this, item);
			
			loadNextItem();
		}
		
		private function onItemFailed(item:AbstractLoader):void {
			for(var o:Object in listeners) (o as QueueLoaderListener).onQueueItemFailed(this, item);
			
			loadNextItem();
		}
		
		protected override function onProgress():void {
			progress.setBytesTotal(0);
			progress.setBytesLoaded(0);
			
			for(var i:int=0;i<queue.length;i++) {
				progress.setBytesTotal(progress.getBytesTotal() + (queue[i] as AbstractLoader).getProgress().getBytesTotal());
				progress.setBytesLoaded(progress.getBytesLoaded() + (queue[i] as AbstractLoader).getProgress().getBytesLoaded());
			}
			
			for(var o:Object in listeners) (o as QueueLoaderListener).onQueueProgressUpdated(this);

		}
	}
}
