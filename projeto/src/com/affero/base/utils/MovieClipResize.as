package com.affero.base.utils 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author luiz.coelho
	 */
	public class MovieClipResize extends MovieClip
	{
		
		public function MovieClipResize():void
		{
			
		}		
		
		override public function set x(value:Number):void{
		  super.x = value;
		  dispatchResizeEvent();
		}

		override public function set y(value:Number):void{
		  super.y = value;
		  dispatchResizeEvent();
		}
		
		override public function set width(value:Number):void{
		  super.width = value;
		  dispatchResizeEvent();
		}

		override public function set height(value:Number):void{
		  super.height = value;
		  dispatchResizeEvent();
		}
		
		private function dispatchResizeEvent():void{
		  dispatchEvent(new Event("MovieClipResize", false, false));
		}
		
	}

}