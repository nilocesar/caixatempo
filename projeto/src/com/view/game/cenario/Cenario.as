package com.view.game.cenario 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	// Import Tweener
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.DisplayShortcuts;
	DisplayShortcuts.init();
	
	/**
	 * ...
	 * @author Nilo
	 */
	public class Cenario extends MovieClip 
	{
		//
		private var _cenarioObj:CenarioObj; /// lib swc
		private var container:MovieClip;
		
		//
		private var _conteudoArray:Array = [];
		private var _blockPerson1:Boolean = false;
		private var _blockPerson2:Boolean = false;
		private var _finalConferencia:Boolean = false;
		
		//
		public var status_final:String = "";
		public var currentSituacaoObj:Object = new Object();
		
		
		public function Cenario( _conArray:Array ) 
		{
			_conteudoArray = _conArray;
			init();
		}
		
		//--------------------------------------
		// EVENT/PUBLIC
		//--------------------------------------
		
		public function currentSituacaoQuestoes():void
		{
			currentSituacao();
		}
		
		
		private function goControleEvent():void
		{
			dispatchEvent(new Event("GO_CONTROLE_EVENT"));
		}
		
		private function statusFinalEvent():void
		{
			dispatchEvent(new Event("STATUS_FINAL_EVENT"));
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
			_cenarioObj = new CenarioObj();
			container.addChild(_cenarioObj);
			
			
			
			_cenarioObj.anim1.personagem.pers1.visible = true;
			_cenarioObj.anim1.personagem.pers1.blockOver.visible = false;
			_cenarioObj.anim1.personagem.pers2.visible = false;
			
			_cenarioObj.anim2.personagem.pers1.visible = false;
			_cenarioObj.anim2.personagem.pers2.visible = true;
			_cenarioObj.anim2.personagem.pers2.blockOver.visible = false;
			
			_cenarioObj.anim1.personagem.pers1.buttonMode = true;
			_cenarioObj.anim1.personagem.pers1.mouseChildren = false;
			_cenarioObj.anim1.personagem.pers1.addEventListener( MouseEvent.MOUSE_OVER, eventOver );
			_cenarioObj.anim1.personagem.pers1.addEventListener( MouseEvent.MOUSE_OUT, eventOut );
			_cenarioObj.anim1.personagem.pers1.addEventListener(MouseEvent.CLICK, eventClick);
			
			_cenarioObj.anim2.personagem.pers2.buttonMode = true;
			_cenarioObj.anim2.personagem.pers2.mouseChildren = false;
			_cenarioObj.anim2.personagem.pers2.addEventListener( MouseEvent.MOUSE_OVER, eventOver );
			_cenarioObj.anim2.personagem.pers2.addEventListener( MouseEvent.MOUSE_OUT, eventOut );
			_cenarioObj.anim2.personagem.pers2.addEventListener(MouseEvent.CLICK, eventClick);
			
			//_cenarioObj.goControle.visible = false; Deixar sempre ativado pq ele pode ter zero
			_cenarioObj.goControle.buttonMode = true;
			_cenarioObj.goControle.mouseChildren = false;
			//_cenarioObj.goControle.addEventListener( MouseEvent.MOUSE_OVER, eventOver );
			//_cenarioObj.goControle.addEventListener( MouseEvent.MOUSE_OUT, eventOut );
			_cenarioObj.goControle.addEventListener(MouseEvent.CLICK, eventClick);
			
			//OBJ
			currentSituacaoObj.questaoCurrent = 0;
			currentSituacaoObj.respPeson1 = 0;
			currentSituacaoObj.respPeson2 = 0;
		}
		
		//--------------------------------------
		//  CURRENT SITUACAO
		//--------------------------------------
		
		private function currentSituacao():void
		{
			currentSituacaoObj.questaoCurrent += 1;
			
			if ( currentSituacaoObj.questaoCurrent == _conteudoArray[0].LengthQuestoes ) /// confere se estar no final
			{
				_cenarioObj.goControle.play();/// coloca texto de finalizar //frame2
				_finalConferencia = true;
			}
				
				
			
		}
		
		
		private function situacaoFinal():void
		{
			if ( currentSituacaoObj.respPeson1 == currentSituacaoObj.respPeson2 )// Empate
			{
				status_final = "empate";
				
				//_cenarioObj.anim1.personagem.pers1.person.gotoAndPlay("voo");// play no person voo do personagem
				var _time:Number = _cenarioObj.anim1.totalFrames/30 - _cenarioObj.anim1.currentFrame/30;
				Tweener.addTween( _cenarioObj.anim1, { _frame:_cenarioObj.anim1.totalFrames, time:_time, transition:"linear" } );	
				
				//_cenarioObj.anim2.personagem.pers2.person.gotoAndPlay("voo");// play no person voo do personagem
				var _time2:Number = _cenarioObj.anim2.totalFrames/30 - _cenarioObj.anim2.currentFrame/30;
				Tweener.addTween( _cenarioObj.anim2, { _frame:_cenarioObj.anim2.totalFrames, time:_time2, transition:"linear",
														onComplete:statusFinalEvent});	
			}
				
			else if ( currentSituacaoObj.respPeson1 > currentSituacaoObj.respPeson2 )//  person1 ganhou
			{
				status_final = "pers1";
				
				//_cenarioObj.anim1.personagem.pers1.person.gotoAndPlay("voo");// play no person voo do personagem
				_time = _cenarioObj.anim1.totalFrames/30 - _cenarioObj.anim1.currentFrame/30;
				Tweener.addTween( _cenarioObj.anim1, { _frame:_cenarioObj.anim1.totalFrames, time:_time, transition:"linear",
														onComplete:statusFinalEvent});	
			}
				
			else if ( currentSituacaoObj.respPeson1 < currentSituacaoObj.respPeson2 )//  person2 ganhou
			{
				status_final = "pers2";
				
				//_cenarioObj.anim2.personagem.pers2.person.gotoAndPlay("voo");// play no person voo do personagem
				_time = _cenarioObj.anim2.totalFrames/30 - _cenarioObj.anim2.currentFrame/30;
				Tweener.addTween( _cenarioObj.anim2, { _frame:_cenarioObj.anim2.totalFrames, time:_time, transition:"linear",
														onComplete:statusFinalEvent});	
			}
		}
		
		
		//--------------------------------------
		// MOUSE EVENT
		//--------------------------------------
		
		private function eventOver(e:MouseEvent):void
		{
			if (e.currentTarget.name == "pers1" && _blockPerson1)
			{
				_cenarioObj.anim1.personagem.pers1.blockOver.visible = true;
			}
			
			if (e.currentTarget.name == "pers2" && _blockPerson2)
			{
				_cenarioObj.anim2.personagem.pers2.blockOver.visible = true;
			}
		}
		
		private function eventOut(e:MouseEvent):void
		{
			if (e.currentTarget.name == "pers1" && _blockPerson1)
			{
				_cenarioObj.anim1.personagem.pers1.blockOver.visible = false;
			}
			
			if (e.currentTarget.name == "pers2" && _blockPerson2)
			{
				_cenarioObj.anim2.personagem.pers2.blockOver.visible = false;
			}
		}
		
		private function eventClick(e:MouseEvent):void
		{
			if (e.currentTarget.name == "pers1" && !_blockPerson1)
			{
				e.currentTarget.play();// play na timeline do personagem
				e.currentTarget.person.gotoAndPlay("voo");// play no person voo do personagem
				e.currentTarget.parent.parent.play();// play na timeline da anima geral
				_blockPerson1 = true;
				_cenarioObj.goControle.visible = true;
				currentSituacaoObj.respPeson1 += 1;
			}
			
			if (e.currentTarget.name == "pers2" && !_blockPerson2)
			{
				e.currentTarget.play();// play na timeline do personagem
				e.currentTarget.person.gotoAndPlay("voo");// play no person voo do personagem
				e.currentTarget.parent.parent.play(); // play na timeline da anima geral
				_blockPerson2 = true;
				_cenarioObj.goControle.visible = true;
				currentSituacaoObj.respPeson2 += 1;
			}
			
			if ( e.currentTarget.name == "goControle" )
			{
				_blockPerson1 = false;
				_blockPerson2 = false;
				//_cenarioObj.goControle.visible = false;
				
				if ( !_finalConferencia )/// confere se estar no final
					goControleEvent();
				else
					situacaoFinal();
			}
		}
	}

}