package com.view 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author luiz.coelho
	 */
	public class LoadingTela extends MovieClip
	{
		
		public function LoadingTela() 
		{
			if (this.stage) {
                this.init();
            } else {
				this.addEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
            }			
		}			
		
		
		// Event handlers
        private function handleAddedToStage(event:Event):void {
            this.removeEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
            this.init();
        }
		
		private function init():void {
			this.play();
		}
		
		public function set porcentagem(pct:Number):void {
			//var percent:uint = Math.round(100 * (pct / 1));NILO
			//this.gotoAndStop(percent);NILO
		}
		
		public function removeLoading():void {
			this.parent.removeChild(this);
		}
		
		
	}

}