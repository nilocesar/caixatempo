package com.view.game.sendData
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	//
	import com.view.game.includes.globalVars;
	
	public class SendData extends MovieClip
	{
		private var container:MovieClip;
		
		//
		private var _conteudoArray:Array = [];
		
		// GlobalVars
		private var _globalVars = new globalVars();
		
		//--------------------------------------
		// INIT
		//--------------------------------------
		
		public function SendData( _arrayObj )
		{
			_conteudoArray = _arrayObj;
			sendDataInit();
		}
		
		
		//--------------------------------------
		// EVENT/PUBLIC
		//--------------------------------------
		

		public function sendDataEnd( itensInfoObj ):void
		{
			sendDataEndInfo( itensInfoObj );
		}
		
		
		//--------------------------------------
		// SEND DATA INIT
		//--------------------------------------
		
		private function sendDataInit():void
		{
			container = new MovieClip();
			addChild(container);
		}
		
		
		//--------------------------------------
		// SEND DATA END INFO
		//--------------------------------------
		
		private function sendDataEndInfo( itensInfoObj ):void
		{
			if (Main.instance._AppController != null)/// relativo ao Main do projeto inteiro Save scorm
			{ 
				if( Main.instance._stateController.configEngine.scorm )
				{
					Main.instance._AppController.refTelaAtual.person1 = itensInfoObj.respPeson1;
					Main.instance._AppController.refTelaAtual.person2 = itensInfoObj.respPeson2;
					
					if ( itensInfoObj.respPeson1 > itensInfoObj.respPeson2 || itensInfoObj.respPeson1 == itensInfoObj.respPeson2 )
					{
						var _scorePorcento:int = (( itensInfoObj.respPeson1 * 100) / _conteudoArray[0].LengthQuestoes ); // regra de 3
						Main.instance._stateController.scormControl.raw = _scorePorcento; /// porcentagem
					}
					else
					{
						var _scorePorcento2:int = (( itensInfoObj.respPeson2 * 100) / _conteudoArray[0].LengthQuestoes ); // regra de 3
						Main.instance._stateController.scormControl.raw = _scorePorcento2; /// porcentagem
					}
					
					//Save Config
					Main.instance._stateController.saveConfigScorm();
				}
			}
			
		}	
	}
}