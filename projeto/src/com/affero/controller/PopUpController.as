package com.affero.controller {

import com.affero.base.utils.MovieClipExtended;
import com.greensock.TweenMax;
import flash.display.Sprite;
import flash.events.Event;

import flash.display.DisplayObject;

import flash.display.MovieClip;
import flash.utils.Dictionary;

	public class PopUpController {
		
		public var placeHolder : MovieClip = new MovieClip();
		public var itens : Dictionary = new Dictionary();
		public var fundoAlpha:MovieClip  = new MovieClip();
		
		
		public function PopUpController(inPlaceHolder : MovieClip) {
			placeHolder = inPlaceHolder ;			
			
			//Adiciona o alpha do pop
			fundoAlpha = new MovieClip();
			var square:Sprite = new Sprite();
			square.graphics.beginFill(0xFFFFFF);
			square.graphics.drawRect(0,0,100,100);
			square.graphics.endFill();
			fundoAlpha.addChild(square);			
			inPlaceHolder.addChild(fundoAlpha);
			fundoAlpha.alpha = .9;
			fundoAlpha.visible = false;
			
			inPlaceHolder.stage.addEventListener(Event.RESIZE, resizeHandler);
		
		}
		
		
		public function resizeHandler(e:Event = null):void {
			fundoAlpha.width = Main.instance.stage.stageWidth;
			fundoAlpha.height = Main.instance.stage.stageHeight;
			
			for (var i:int; i < placeHolder.numChildren; i++ ) {
				var mcAtual:* = placeHolder.getChildAt(i);
				
				if (mcAtual != fundoAlpha) {
					mcAtual.x = (Main.instance.stage.stageWidth / 2) - (mcAtual.width / 2);
					mcAtual.y = (Main.instance.stage.stageHeight / 2) - (mcAtual.height / 2);					
				}
				
			}			
			
		}
		
		public function addChildOnPlaceHolder(inMovieClip : MovieClip, inName : String) : void {
            inMovieClip.alpha = 0;
            TweenMax.to(inMovieClip, 0.5, {alpha:1});
			
           	inMovieClip.gotoAndStop(1);
			placeHolder.addChild(inMovieClip);
            itens[inName] = inMovieClip;	
			
			fundoAlpha.visible = true;
			resizeHandler();
			
		}
		
		public function removeChildOnPlaceHolder(inName : String) : void {
            TweenMax.to(itens[inName], 0.3, {alpha:0, onComplete:continuaRemove, onCompleteParams:[inName]});            
		}

        private function continuaRemove(inName:String):void{
            placeHolder.removeChild(itens[inName]);
			
			 if (placeHolder.numChildren == 1) {
				fundoAlpha.visible = false;
			 }
			 
			delete itens[inName];
        }
		
	}

}