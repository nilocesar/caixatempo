package com.view.game
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import com.view.game.xml.XmlControle;
	import com.view.game.controle.Controle;
	import com.view.game.cenario.Cenario;
	import com.view.game.feedFinal.FeedFinal;
	import com.view.game.sendData.SendData;
	
	/**
	 * ...
	 * @author Nilo
	 */
	
	public class Main extends MovieClip 
	{
		//
		private var _xmlControle:XmlControle;
		private var _controle:Controle;
		private var _cenario:Cenario;
		private var _feedFinal:FeedFinal;
		private var _sendData:SendData;
		
		//
		private var container:MovieClip;
		
		//
		private var currentData:Object;
		private var conteudoArray:Array;
		private var currentQuestao:Number = 0;
		
		
		public function Main():void 
		{
			//Preloader
			this.loaderInfo.addEventListener(Event.COMPLETE, loadComplete);
		}
		
		private function loadComplete(e:Event):void 
		{
			// load complete - remove listeners and move on
			this.loaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
			//this.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
			
			/*if ( Main.instance._AppController != null)
				Main.instance._AppController.completeLoaderGame();*/
				
				
			// 
			mainInit();
			xmlInit();
		}
		
		
		//--------------------------------------
		// MAIN INIT
		//--------------------------------------
		
		private function mainInit():void
		{
			container = new MovieClip();
			addChild(container);
		}
		
		
		//--------------------------------------
		// XML
		//--------------------------------------
		
		private function xmlInit():void
		{
			//
			_xmlControle = new XmlControle();
			container.addChild(_xmlControle);
			conteudoArray = _xmlControle.conteudoArray;// Array de todo o conteudo do xml
			
			_xmlControle.addEventListener( "GO_GAME_INIT_EVENT", goGameInit ); /// inicia o game depois de carregado o xml
			
		}
		
		private function goGameInit(e:Event):void
		{
			cenarioInit();
			controleInit("inicial");
			sendDataInit();
		}
		
		//--------------------------------------
		// CONTROLE
		//--------------------------------------
		
		private function controleInit( _frameControle:String ):void
		{
			_controle = new Controle( conteudoArray , currentQuestao, _frameControle );
			_controle.addEventListener( "GO_CENARIO_EVENT", goCenarioInit );
			container.addChild(_controle);
		}
		
		private function goCenarioInit(e:Event):void
		{
			container.removeChild(_controle);/// Remove controle para ir para o Cenário;
			
			//Avisa a situação no cenário em que questão estar
			currentSituacaoQuestoes();
		}
		
		//--------------------------------------
		// CENARIO
		//--------------------------------------
		
		private function cenarioInit():void
		{
			_cenario = new Cenario( conteudoArray );
			_cenario.addEventListener( "GO_CONTROLE_EVENT", goControleInit );
			_cenario.addEventListener( "STATUS_FINAL_EVENT", statusFinalInit );
			container.addChild(_cenario);
		}
		
		private function currentSituacaoQuestoes():void
		{
			_cenario.currentSituacaoQuestoes();
		}
		
		private function goControleInit(e:Event):void
		{
			currentQuestao++;
			controleInit("feed");
		}
		
		private function statusFinalInit(e:Event):void
		{
			feedFinalInit(  e.currentTarget.status_final );
			sendDataEnd( e.currentTarget.currentSituacaoObj );
		}
		
		//--------------------------------------
		// FEED FINAL
		//--------------------------------------
		
		private function feedFinalInit( _statusFinal :String ):void
		{
			_feedFinal = new FeedFinal( conteudoArray , _statusFinal );
			container.addChild(_feedFinal);
		}
		
		
		//--------------------------------------
		// SEND DATA
		//--------------------------------------
		
		private function sendDataInit():void
		{
			_sendData = new SendData( conteudoArray );
			container.addChild(_sendData);
		}
	
		
		private function sendDataEnd( _dataObj ):void
		{
			_sendData.sendDataEnd( _dataObj );
		}
	}
	
}