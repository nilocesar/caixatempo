package com.view 
{
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author luiz.coelho
	 */
	public class Fundo extends MovieClip
	{
		public var btSair:MovieClip;
		public var btFull:MovieClip;
		
		public function Fundo() 
		{
				btSair.buttonMode = true;
				btSair.mouseChildren = false;				
				btSair.addEventListener(MouseEvent.CLICK, eventClick);
				
				btFull.buttonMode = true;
				btFull.mouseChildren = false;				
				btFull.addEventListener(MouseEvent.CLICK, eventClick);
		}
		
		private function eventClick(e:MouseEvent):void {
			
			if (e.currentTarget.name == "btSair")
			{
				Main.instance._AppController.closeCourseWindow();
			}
			
			if (e.currentTarget.name == "btFull")
			{
					if (Main.instance.stage.displayState == StageDisplayState.NORMAL) 
					{
						Main.instance.stage.displayState=StageDisplayState.FULL_SCREEN;
					} else {
						Main.instance.stage.displayState=StageDisplayState.NORMAL;
					}
			}
			
		}
		
	}

}