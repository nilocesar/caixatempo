package com.affero.base.utils.cronometro {
	/**
	 * ...
	 * @author LF Coelho
	 */
	
	import com.affero.base.utils.cronometro.events.PercentEvent;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	public class Tempo extends Sprite {
		
		// Variavel publica do tipo Timer
		private var temporizador:Timer;
		
		// Variavel aonde vamos guardar quantos segundos passaram
		public var segundos:int;
		
		private var orientacao:String;
		
		private var setOk:Boolean = false;
		
		private var textTimer:TextField = new TextField();
		
		private var onFinishedFn:Function;
		
		private var secondsUser:int;
		
		private var min:Number;
		private var seg:Number;
		private var minStr:String;
		private var secStr:String;
		private var negativeOut:Boolean;
		
		// Constructor
		public function Tempo():void {
			this.temporizador = new Timer(1000);
		}
		
		// Public API
		public function setCronometro(seconds:int, displayText:TextField, orientation:String = "progressiva", negative:Boolean = false, onFinish:Function = null):void {
			if (orientation == "progressiva"){
				segundos = 0;
			} else if (orientation == "regressiva"){
				segundos = seconds;
				negativeOut = negative;
			}
			
			secondsUser = seconds;
			orientacao = orientation;
			textTimer = displayText;
			this.onFinishedFn = onFinish;
			
			formatTime();
			setOk = true;
		}
		
		
		public function getTimeString():String {			
			return convertToHHMMSS(segundos);
		}
		
		private function atualizaTempo(temp:TimerEvent):void {
			if (orientacao == "progressiva") {
				segundos++;
			} else if (orientacao == "regressiva") {
				segundos--;
			} else {
				trace('Verifique se o tempo informado é maior que zero ou a orientação é igual a progressiva ou regressiva');
			}
			
			var pctTimer:int = (100 * segundos) / secondsUser;
			var pctTimerII:int;
			
			switch (orientacao) {
				case "progressiva":
					this.dispatchEvent(new PercentEvent(pctTimer));
					
					if (segundos == secondsUser){
						stopCronometro();
						if (onFinishedFn != null){
							onFinishedFn();
						}
					}
					break;
				case "regressiva":
					pctTimer = 100 - pctTimer;
					
					this.dispatchEvent(new PercentEvent(pctTimer));
					
					if (!negativeOut){
						
						if (segundos == 0){
							
							stopCronometro();
							if (onFinishedFn != null){
								onFinishedFn();
							}
							
						}
						
					}
					
					break;
			
			}
			
			formatTime();
		
		}
		
		private function formatTime():void {
			if (segundos < 0){
				formatText(segundos * -1, true);
			} else {
				
				formatText(segundos, false);
			}
		
		}		
		
		
		private function formatText($seconds:Number, negativo:Boolean):void {			
			
			var s:Number = $seconds % 60;
			var m:Number = Math.floor(($seconds % 3600 ) / 60);
			var h:Number = Math.floor($seconds / (60 * 60));
		 
			var hourStr:String = (h == 0) ? "" : doubleDigitFormat(h) + ":";
			var minuteStr:String = doubleDigitFormat(m) + ":";
			var secondsStr:String = doubleDigitFormat(s);		
			
			
			if (negativo){
				textTimer.text = '-' + hourStr + minuteStr + secondsStr;
			} else {
				textTimer.text = hourStr + minuteStr + secondsStr;
			}

		}
		
		
		public function convertToHHMMSS($seconds:Number):String
		{
			var s:Number = $seconds % 60;
			var m:Number = Math.floor(($seconds % 3600 ) / 60);
			var h:Number = Math.floor($seconds / (60 * 60));
		 
			var hourStr:String = (h == 0) ? "" : doubleDigitFormat(h) + ":";
			var minuteStr:String = doubleDigitFormat(m) + ":";
			var secondsStr:String = doubleDigitFormat(s);
		 
			return hourStr + minuteStr + secondsStr;
		}
		
		
		private function doubleDigitFormat($num:uint):String
		{
			if ($num < 10)
			{
				return ("0" + $num);
			}
			return String($num);
		}
		
		
		public function updateCronometro(seconds:int, onFinish:Function = null):void {
			if (setOk) {
				
				if (onFinish!=null) {
					this.onFinishedFn = onFinish;
				}
				
				stopCronometro();
				segundos = seconds;
				secondsUser = seconds;
				startCronometro();
			}
		}
		
		public function startCronometro():void {
            if (setOk){
				temporizador.addEventListener(TimerEvent.TIMER, atualizaTempo);
				temporizador.start();
			} else {
				
				trace("É necessário informar os parâmetros no método setCronometro.");
			}
		}
		
		public function stopCronometro():void {
			temporizador.removeEventListener(TimerEvent.TIMER, atualizaTempo);
			temporizador.stop();
			formatTime();
		}
		
		public function pauseCronometro():void {
			temporizador.removeEventListener(TimerEvent.TIMER, atualizaTempo);
			temporizador.stop();
		
		}
	
	}

}


