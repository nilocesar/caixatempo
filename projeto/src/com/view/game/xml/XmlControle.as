package com.view.game.xml 
{
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	///
	import com.view.game.includes.globalVars;
	
	/**
	 * ...
	 * @author Nilo
	 */
	public class XmlControle extends MovieClip 
	{
		public var _itemObject:Object;
		public var conteudoArray:Array = new Array();
		
		// GlobalVars
		private var _globalVars = new globalVars();
		private var _xml:XML;
		
		
		public function XmlControle() 
		{
			init()
		}
		
		//--------------------------------------
		// EVENT/PUBLIC
		//--------------------------------------
		
		public function loaderComplete():void
		{
			//itemInfo(_itemObject);
		}
		
		private function goInitGameEvent():void
		{
			dispatchEvent(new Event("GO_GAME_INIT_EVENT"));
		}
		
		//--------------------------------------
		// INIT
		//--------------------------------------
		
		private function init():void 
		{
			var _pathXml:String = "";
			if (Main.instance._AppController != null) /// PATH DO XML relativo ao Main do projeto inteiro
				_pathXml = _globalVars.get("path_xml_projeto");
			else
				_pathXml = _globalVars.get("path_xml");
				
			var loader:URLLoader = new URLLoader(new URLRequest( _pathXml ));
			loader.addEventListener(Event.COMPLETE, loadedCompleteHandler);
		}
		
		private function loadedCompleteHandler(e:Event):void
		{
			
			e.target.removeEventListener(Event.COMPLETE, loadedCompleteHandler);
			_xml = XML(e.target.data);
			
			var LengthQuestoes:Number = _xml.questoes.questao.length();
			
			for (var i:int = 0; i < LengthQuestoes; i ++  )
			{
				//
				_itemObject = new Object();
				
				_itemObject.LengthQuestoes = LengthQuestoes;
				_itemObject.tempo =  _xml.questoes.questao[i].tempoResposta;
				
				_itemObject.empate =  _xml.questoes.empate;
				_itemObject.pers1Win =  _xml.questoes.pers1Win;
				_itemObject.pers2Win =  _xml.questoes.pers2Win;
				
				_itemObject.alternativa = _xml.questoes.questao[i].alternativa;
				_itemObject.feed = _xml.questoes.questao[i].feed;
				_itemObject.header = _xml.questoes.questao[i].header;
				
				conteudoArray.push( _itemObject );
			}
			
			
			//
			goInitGameEvent();/// iniciar o jogo depois de carregado o xml
			
		}
	}

}