package com.affero.alert 
{
	import com.affero.base.utils.BaseButton;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	/**
	 * ...
	 * @author luiz.coelho
	 */
	public class ConteudoAlertBox extends MovieClip
	{
		public var descricaoTxt:TextField;
		public var rejeitaBt:BaseButton;
		public var confirmaBt:BaseButton;
		public var okBt:BaseButton;
		public var boxAlert:MovieClip;
		
		
		public function ConteudoAlertBox() 
		{
			if (this.stage) {
                this.init();
            } else {
                this.addEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
            }
		}
		
		private function init():void {
			descricaoTxt.mouseWheelEnabled = false;
		}
		
		private function handleAddedToStage(event:Event):void {
            this.removeEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
            this.init();
        }
		
	}

}