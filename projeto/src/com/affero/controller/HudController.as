package com.affero.controller {
import com.affero.base.utils.mc;

import flash.display.MovieClip;
import flash.utils.Dictionary;

	public class HudController {


		public var placeHolder : MovieClip;
		public var onComplete : Function;
        public var itens : Dictionary = new Dictionary();


		public function HudController(inPlaceHolder : MovieClip) {
			placeHolder = inPlaceHolder;
		}

       public function addChildOnPlaceHolder(inMovieClip : MovieClip, inName : String) : void {
			inMovieClip.gotoAndStop(1);
			placeHolder.addChild(inMovieClip);
            
			//NIL0
			//Main.instance.resizeHandler(placeHolder);
			//NILO
			itens[inName] = inMovieClip;
		}

		public function removeChildOnPlaceHolder(inName : String) : void {
			placeHolder.removeChild(itens[inName]);
			delete itens[inName];
		}




	}
}