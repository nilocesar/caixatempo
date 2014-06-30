package com.view.game.controle  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;

	/**
	 * ...
	 * @author Daniela Cardeira Março 2009
	 * 
	 * Para implementar iniciar a classe e indicar o campo de texto a alterar
	 * var meu_cronometro: cronometro = new cronometro(cronometro_tx);
	 * 
	 */
	public class Cronometro extends MovieClip {
		public var campo_texto:TextField;
		public var stCronometro:String = "iniciar";
		private var meu_timer:Timer;
		private var tempo_inicial:Date;
		private var tempo_inicio_pausa:Date;
		private var tempo_pausa:int;
		private var status_play:Boolean = false;
		public var tempo_mili:Number = 0;
		
		private var tempoRegressivo:Number = 0;

		public function Cronometro(texto:TextField , _temp:Number):void {
			
			tempoRegressivo = _temp;
			campo_texto = texto;
			
			//TEMPO INICIAL 
			var min:String;
			tempoRegressivo < 10 ? min = String(0) + String(tempoRegressivo) : min = String(tempoRegressivo);
			if( tempoRegressivo < 10 )
			campo_texto.text = min + ":" + "00";
			//TEMPO INICIAL 
		}
		
		//--------------------------------------
		// EVENT/PUBLIC
		//--------------------------------------
		
		private function tempoFinalizadoEvent():void
		{
			dispatchEvent(new Event("TEMPO_FINALIZADO_EVENT"));
		}
		
		
		//--------------------------------------
		// INIT
		//--------------------------------------
		
		public function statusCronometro():void
		{
			if ( stCronometro == "iniciar" ) iniciar_timer(); // Ainda não foi incializado
			else if ( stCronometro == "play" ) pausar_timer(); /// Ta play e vai pausar
			else if ( stCronometro == "pause" ) recomecar_timer();// Ta pause e vai da play
		}
		
		
		public function iniciar_timer():void {
			tempo_inicial = new Date();
			tempo_pausa=0;
			var delay_:int=100;
			meu_timer=new Timer(delay_);
			meu_timer.addEventListener(TimerEvent.TIMER, actualizar);
			meu_timer.start();
			stCronometro = "play";
		}
		public function parar_timer():void {
			meu_timer.removeEventListener(TimerEvent.TIMER, actualizar);
			meu_timer.stop();
		}
		public function pausar_timer():void {
			parar_timer();
			tempo_inicio_pausa = new Date();
			stCronometro = "pause";
		}
		public function recomecar_timer():void {
			var tempo_actual:Date = new Date();
			tempo_pausa += (tempo_actual.getTime() - tempo_inicio_pausa.getTime()) / 1000;
			var delay_:int=100;
			meu_timer=new Timer(delay_);
			meu_timer.addEventListener(TimerEvent.TIMER, actualizar);
			meu_timer.start();
			stCronometro = "play";
		}
		private function actualizar(e:TimerEvent):void {
			var tempo_actual:Date = new Date();
			var tempo_decorrido:int = (tempo_actual.getTime() - tempo_inicial.getTime()) / 1000;
			tempo_decorrido-=tempo_pausa;
			tempo_mili= tempo_decorrido*1000;
			var minutos:int= tempoRegressivo - tempo_decorrido/60; // diminui com base no tempo definido
			
			//
			if(tempo_decorrido > 0)
				var segundos:int = 60 - tempo_decorrido % 60;
			
			if (segundos < 1) {

				minutos--;
				segundos = 60;
				segundos--;

			} else {

				segundos--;
			}
			
			var sec:String;
			var min:String;
			minutos < 10 ? min = String(0) + String(minutos) : min = String(minutos);
			segundos < 10 ? sec = String(0) + String(segundos) : sec = String(segundos);

			if ((segundos < 1) && (minutos == 0)) {

				meu_timer.removeEventListener(TimerEvent.TIMER, actualizar);

				// dispara tempo Finalizado
				stCronometro = "finalizado";
				tempoFinalizadoEvent();
				
			}
			
			campo_texto.text=min+":"+sec;
		}
	}
}