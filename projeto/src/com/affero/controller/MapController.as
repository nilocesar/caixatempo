package com.affero.controller {

import flash.display.MovieClip;
import flash.utils.Dictionary;

	public class MapController{
		
		public var placeHolder : MovieClip;
		public var itens : Dictionary = new Dictionary();

		public function MapController(inPlaceHolder : MovieClip) {
			placeHolder = inPlaceHolder ;
		}
		
		public function addChildOnPlaceHolder(inMovieClip : MovieClip, inName : String) : void {
			inMovieClip.gotoAndStop(1);
			placeHolder.addChild(inMovieClip);
           
			itens[inName] = inMovieClip;
		}
		
		public function removeChildOnPlaceHolder(inName : String) : void {
			placeHolder.removeChild(itens[inName]);
			delete itens[inName];
		}
	}

}