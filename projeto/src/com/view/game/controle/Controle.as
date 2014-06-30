package com.view.game.controle
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.view.game.controle.Cronometro;
	
	/**
	 * ...
	 * @author Nilo
	 */
	public class Controle extends MovieClip
	{	
		//
		private var container:MovieClip;
		
		//
		private var _controleObj:ControleObj; /// lib swc
		private var _cronometro:Cronometro;
		
		
		//
		private var _controleCurrent:int = 0;
		private var _tempoCurrent:int = 1;
		private var _frameInicial:String = "";
		private var _conteudoArray:Array = [];
		
		public function Controle(_conArray:Array , _current:Number , _frameInit:String )
		{
			_controleCurrent = _current;
			_conteudoArray = _conArray;
			_frameInicial = _frameInit;
			
			init();
			createConteudo();
			feedControle();
		}
		
		//--------------------------------------
		// EVENT/PUBLIC
		//--------------------------------------
		
		public function returnControle():void
		{
			//itemInfo(_itemObject);
		}
		
		public function getConteudo(_itemObject:Object):void
		{
			//itemInfo(_itemObject);
		}
		
		private function goCenarioEvent():void
		{
			dispatchEvent(new Event("GO_CENARIO_EVENT"));
		}
		
		//--------------------------------------
		// INIT
		//--------------------------------------
		
		private function init():void
		{
			//
			container = new MovieClip();
			addChild(container);
			
			//
			_controleObj = new ControleObj();
			container.addChild(_controleObj);
			_controleObj.controleTela.goBtn.visible = false;
			
			if (_frameInicial == "inicial")
			{
				_controleObj.gotoAndPlay("animacao");
				_controleObj.addEventListener(Event.ENTER_FRAME, frameCurrentEvent )
				
				function frameCurrentEvent(e:Event)
				{
					if (e.currentTarget.currentFrameLabel == "feed" )
					{
						_controleObj.feedControle.gotoAndPlay(0);
						_controleObj.removeEventListener(Event.ENTER_FRAME, frameCurrentEvent )
					}
				}
			}
				
			
			if (_frameInicial == "feed")
			{
				_controleObj.gotoAndPlay("feed");
			}
					
				
			
		}
		
		//--------------------------------------
		// XML
		//--------------------------------------
		
		private function createConteudo():void
		{
			_tempoCurrent = _conteudoArray[_controleCurrent].tempo;
			_controleObj.feedControle.controleFeedTxt.htmlText = _conteudoArray[_controleCurrent].feed;
			_controleObj.controleTela.currentControle.txt.htmlText = _conteudoArray[_controleCurrent].header;
			_controleObj.controleTela.questaoControle.txt.htmlText  = _conteudoArray[_controleCurrent].alternativa;
		}
		
		//--------------------------------------
		// FEED
		//--------------------------------------
		
		private function feedControle():void
		{
			//AVANÇAR
			_controleObj.feedControle.okFeedBtn.buttonMode = true;
			_controleObj.feedControle.okFeedBtn.mouseChildren = false;
			//_controleObj.feedControle.okFeedBtn.addEventListener( MouseEvent.MOUSE_OVER, eventOver );
			//_controleObj.feedControle.okFeedBtn.addEventListener( MouseEvent.MOUSE_OUT, eventOut );
			_controleObj.feedControle.okFeedBtn.addEventListener(MouseEvent.CLICK, eventClick);
		}
		
		//--------------------------------------
		// CALL TELA
		//--------------------------------------
		
		private function callTela():void
		{
			// CRONOMETRO
			_cronometro = new Cronometro(_controleObj.controleTela.cronometroControle.txt, _tempoCurrent); //tempo
			_cronometro.addEventListener("TEMPO_FINALIZADO_EVENT", completadosItens);
			
			//
			_controleObj.controleTela.cronometroControle.cronometroBtn.buttonMode = true;
			_controleObj.controleTela.cronometroControle.cronometroBtn.mouseChildren = false;
			_controleObj.controleTela.cronometroControle.cronometroBtn.addEventListener(MouseEvent.MOUSE_OVER, eventOver);
			_controleObj.controleTela.cronometroControle.cronometroBtn.addEventListener(MouseEvent.MOUSE_OUT, eventOut);
			_controleObj.controleTela.cronometroControle.cronometroBtn.addEventListener(MouseEvent.CLICK, eventClick);
		}
		
		//--------------------------------------
		// CONTROLE
		//--------------------------------------
		
		private function controleStatusBtn(_targetBtn:*):void
		{
			
			if (_cronometro.stCronometro == "play")
			{
				desativarGoBtn();
			}
			else if (_cronometro.stCronometro == "pause")
			{
				ativarGoBtn();
			}
			
			_targetBtn.gotoAndStop(_cronometro.stCronometro);
		}
		
		private function completadosItens(e:Event):void
		{
			_controleObj.controleTela.cronometroControle.cronometroBtn.buttonMode = false;
			_controleObj.controleTela.cronometroControle.cronometroBtn.removeEventListener(MouseEvent.CLICK, eventClick);
			_controleObj.controleTela.cronometroControle.cronometroBtn.gotoAndStop("finalizado");
		
		}
		
		private function desativarGoBtn():void
		{
			//
			_controleObj.controleTela.goBtn.visible = false;
			_controleObj.controleTela.goBtn.buttonMode = false;
			_controleObj.controleTela.goBtn.mouseChildren = false;
			//_controleObj.controleTela.goBtn.removeEventListener( MouseEvent.MOUSE_OVER, eventOver );
			//_controleObj.controleTela.goBtn.removeEventListener( MouseEvent.MOUSE_OUT, eventOut );
			_controleObj.controleTela.goBtn.removeEventListener(MouseEvent.CLICK, eventClick);
		}
		
		private function ativarGoBtn():void
		{
			//
			_controleObj.controleTela.goBtn.visible = true;
			_controleObj.controleTela.goBtn.buttonMode = true;
			_controleObj.controleTela.goBtn.mouseChildren = false;
			//_controleObj.controleTela.goBtn.addEventListener( MouseEvent.MOUSE_OVER, eventOver );
			//_controleObj.controleTela.goBtn.addEventListener( MouseEvent.MOUSE_OUT, eventOut );
			_controleObj.controleTela.goBtn.addEventListener(MouseEvent.CLICK, eventClick);
		}
		
		//--------------------------------------
		// MOUSE EVENT
		//--------------------------------------
		
		private function eventOver(e:MouseEvent):void
		{
			if (_cronometro.stCronometro == "play")
			{
				e.currentTarget.gotoAndStop("play_over");
			}
			else if (_cronometro.stCronometro == "pause")
			{
				e.currentTarget.gotoAndStop("pause_over");
			}
			if (_cronometro.stCronometro == "finalizado")
			{
				e.currentTarget.gotoAndStop("finalizado_over");
			}
		}
		
		private function eventOut(e:MouseEvent):void
		{
			if (_cronometro.stCronometro == "play")
			{
				e.currentTarget.gotoAndStop("play");
			}
			else if (_cronometro.stCronometro == "pause")
			{
				e.currentTarget.gotoAndStop("pause");
			}
			if (_cronometro.stCronometro == "finalizado")
			{
				e.currentTarget.gotoAndStop("finalizado");
			}
		}
		
		private function eventClick(e:MouseEvent):void
		{
			if (e.currentTarget.name == "okFeedBtn")
			{
				_controleObj.addEventListener(Event.ENTER_FRAME, frameCurrentEvent )
				
				function frameCurrentEvent(e:Event)
				{
					if (e.currentTarget.currentFrameLabel == "controle" )
					{
						_controleObj.controleTela.gotoAndPlay(0);
						_controleObj.removeEventListener(Event.ENTER_FRAME, frameCurrentEvent )
					}
				}
				e.currentTarget.parent.parent.play(); /// vai para a tela de controle
				callTela();
			}
			if (e.currentTarget.name == "cronometroBtn")
			{
				_cronometro.statusCronometro();
				controleStatusBtn(e.currentTarget);
			}
			if (e.currentTarget.name == "goBtn")
			{
				goCenarioEvent();
			}
		
		}
	}

}