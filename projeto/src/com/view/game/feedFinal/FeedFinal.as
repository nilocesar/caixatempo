package com.view.game.feedFinal 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Nilo
	 */
	public class FeedFinal extends MovieClip 
	{
		//
		private var _feedFinalObj:FeedFinalObj; /// lib swc
		private var container:MovieClip;
		
		//
		private var _conteudoArray:Array = [];
		private var _statusFinal:String = "";
		
		public function FeedFinal( _conArray:Array , _status:String ) 
		{
			_statusFinal = _status;
			_conteudoArray = _conArray;
			init();
			
		}
		
		//--------------------------------------
		// EVENT/PUBLIC
		//--------------------------------------
		
		/*public function callFeed():void
		{
			
		}*/
		
		//--------------------------------------
		// INIT
		//--------------------------------------
		
		private function init():void 
		{
			//
			container = new MovieClip();
			addChild(container);
			
			_feedFinalObj = new FeedFinalObj();
			container.addChild(_feedFinalObj);
			
			_feedFinalObj.persona.empate.visible = false;
			_feedFinalObj.persona.pers1.visible = false;
			_feedFinalObj.persona.pers2.visible = false;
			
			if (_statusFinal == "empate")
			{
				_feedFinalObj.feedFinalTxt.txt.text = _conteudoArray[0].empate;
				_feedFinalObj.persona.empate.visible = true;
			}
			else if (_statusFinal == "pers1")
			{
				_feedFinalObj.feedFinalTxt.txt.text = _conteudoArray[0].pers1Win;
				_feedFinalObj.persona.pers1.visible = true;
			}
			else if (_statusFinal == "pers2")
			{
				_feedFinalObj.feedFinalTxt.txt.text = _conteudoArray[0].pers2Win;
				_feedFinalObj.persona.pers2.visible = true;
			}
			
		}
	}

}