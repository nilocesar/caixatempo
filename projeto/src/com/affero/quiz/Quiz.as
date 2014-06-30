package com.affero.quiz 
{
	import com.affero.quiz.model.CaseVO;
	import com.affero.quiz.model.QuizVO;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author luiz.coelho
	 */
	public class Quiz extends Sprite
	{
		
		private var arrObjQuiz:Array;
		private var quizContainner:MovieClip;
		private var resetArr:Array;
		private var objQuizAtual:QuizVO;
		
		private var arrAlternativas:Array;
		private var arrUserResps:Array;
		private var quizBox:QuizBox;
		private var onFinish:Function;
		private var caseVo:CaseVO;
		
		
		//Nota
		private var totalPerguntas:int;
		private var userAcertos:int;
		private var pctCorte:uint;
		
		
		
		
		public function Quiz(caseVO:CaseVO, onFinish:Function = null):void
		{		
			this.onFinish = onFinish;
			this.arrObjQuiz = caseVO.arrQuiz;
			this.pctCorte = caseVO.pctCorte;
			this.caseVo = caseVo;
			resetArr = new Array();
			
			Main.instance.debug("Case Atual", caseVO);
			
			
			quizBox = new QuizBox();
			quizBox.fundoAlpha.mouseChildren = false;
			//quizBox.fundoAlpha.width = Main.instance.stage.stageWidth;
			//quizBox.fundoAlpha.height = Main.instance.stage.stageHeight;
			quizBox.fundoAlpha.alpha = 0;
			quizBox.baseQuiz.x = (quizBox.fundoAlpha.width / 2) - (quizBox.baseQuiz.width / 2);
			quizBox.baseQuiz.y = (quizBox.fundoAlpha.height / 2) - (quizBox.baseQuiz.height / 2);
			quizBox.btFechar.x = quizBox.baseQuiz.x + quizBox.baseQuiz.width - (quizBox.btFechar.width/2);
			quizBox.btFechar.y = quizBox.baseQuiz.y - (quizBox.btFechar.height / 2) - 3;
			quizBox.btFechar.visible = false;
			Main.instance._AppController.popUpController.addChildOnPlaceHolder(quizBox, "QuizBox" + quizBox.name);
			
			quizBox.btFechar.addEventListener(MouseEvent.CLICK, onClose);
			
			totalPerguntas = caseVO.arrQuiz.length;
			nextQuiz();			
		}	
		
		private function onClose(evt:MouseEvent):void {
			Main.instance._AppController.popUpController.removeChildOnPlaceHolder("QuizBox" + quizBox.name);
			this.onFinish();
		}
		
		public function nextQuiz(evt:MouseEvent = null):void {
			Main.instance.debug('next', 'next');
			arrObjQuiz = randomize(arrObjQuiz);
			
			
			
			if (arrObjQuiz.length > 0) {
			   	var objAtual:QuizVO = arrObjQuiz.shift();
				objAtual.arrAlternativas = randomize(objAtual.arrAlternativas);
				
				objAtual.contadorInteraction = String(Main.instance._stateController.scormControl.addInteraction(String(objAtual.quizId), "Choice"));
				openQuiz(objAtual);
				resetArr.push(objAtual);								
			}else{
			    //FIM
				var feedGeral:FeedGeral = new FeedGeral();
				
				Main.instance.debug("pct", totalPerguntas +" / "+ userAcertos);
				if (getPct(0, totalPerguntas, userAcertos) >= 70) {
					feedGeral.gotoAndStop('positivo');
					quizBox.btFechar.visible = true;
					
				}else{
					feedGeral.gotoAndStop('negativo');	
					this.arrObjQuiz = resetArr;
					
					resetArr = new Array();
					userAcertos = 0;
					feedGeral.refreshBt.addEventListener(MouseEvent.CLICK, onRefresh);
					feedGeral.refreshBt.buttonMode = true;
				}			
				
				feedGeral.x = (quizBox.baseQuiz.width / 2) - (feedGeral.width/2);
				feedGeral.y = (quizBox.baseQuiz.height / 2) - (feedGeral.height/2);
				
				quizBox.baseQuiz.addChild(feedGeral);
		    }
		}	
		
		
		private function onRefresh(evt:MouseEvent):void {
			quizBox.baseQuiz.removeChild(evt.currentTarget.parent);
			nextQuiz();
		}
		
		private function openQuiz(objQuiz:QuizVO):void {			
			var lastAlter:MovieClip;
			var enunciadoMc:EnunciadoMc = new EnunciadoMc();
			quizContainner = new MovieClip(); 
			
			objQuizAtual = objQuiz;
			arrUserResps = new Array();
			
			enunciadoMc.txt.autoSize = TextFieldAutoSize.LEFT;
			enunciadoMc.txt.htmlText = objQuiz.enunciado;
			enunciadoMc.x = 85;
			
			quizContainner.addChild(enunciadoMc);
			lastAlter = enunciadoMc;
	
			arrAlternativas = new Array();
			for (var k:int; k < objQuiz.arrAlternativas.length; k++) {
				//Main.instance.debug('alternativas', objQuiz.arrAlternativas[k]);
				var quizAlternativa:AlternativaMc = new AlternativaMc();
				quizAlternativa.txt.autoSize = TextFieldAutoSize.LEFT;
				quizAlternativa.txt.text = objQuiz.arrAlternativas[k].conteudo;
				quizAlternativa.id = objQuiz.arrAlternativas[k].id;
				arrAlternativas.push(quizAlternativa);
				
				quizAlternativa.checkBt.addEventListener(MouseEvent.CLICK, icoPress);
				quizAlternativa.checkBt.buttonMode = true;
				quizAlternativa.checkBt.objAtual = objQuiz;
				quizAlternativa.checkBt.id = objQuiz.arrAlternativas[k].id;
				
				
				if (lastAlter != null) {
					if (k == 0)
					{
					quizAlternativa.y = lastAlter.y + (lastAlter.height / 2) + 60;
					}else 
					{
						quizAlternativa.y = lastAlter.y + (lastAlter.height / 2) + 30;
					}
				}
				
				lastAlter = quizAlternativa;
				quizContainner.addChild(quizAlternativa);
			}
	
			var confirmaBt:ConfirmaBt = new ConfirmaBt();
			//confirmaBt.y = lastAlter.y + (lastAlter.height/2);
			//confirmaBt.x = lastAlter.x + lastAlter.width - confirmaBt.width;
			
			confirmaBt.y = 400;
			confirmaBt.x = 445;
 			
			confirmaBt.visible = false;
			quizContainner.confirmaBt = confirmaBt;
			quizContainner.addChild(confirmaBt);
			
			confirmaBt.addEventListener(MouseEvent.CLICK, verificaResposta);
			confirmaBt.buttonMode = true;
			
			var avancaBt:AvancaBt = new AvancaBt();
			avancaBt.y = confirmaBt.y;
			avancaBt.x = confirmaBt.x + 70;
			
			avancaBt.addEventListener(MouseEvent.CLICK, avanca);
			avancaBt.buttonMode = true;
			avancaBt.visible = false;
			quizContainner.avancaBt = avancaBt;			
			quizContainner.addChild(avancaBt);			
			quizBox.baseQuiz.addChild(quizContainner);	
		}
		
		
		private function avanca(evt:MouseEvent):void {
			quizBox.baseQuiz.removeChild(quizContainner);
			nextQuiz();
		}
		
		
		private function icoPress(evt:MouseEvent):void{	
			if(arrUserResps.indexOf(evt.currentTarget.id) == -1){		
				evt.currentTarget.gotoAndStop('CHECK');
				
				if(arrUserResps.length == 1 && evt.currentTarget.objAtual.arrGabarito.length == 1){
					arrUserResps = new Array();			
					for each (var mcDisabled:MovieClip in arrAlternativas) {
						if(mcDisabled.checkBt != evt.currentTarget){				
							mcDisabled.checkBt.gotoAndStop('DISABLED');
						}
					}			
				}
				
				arrUserResps.push(evt.currentTarget.id);		
				
			}else{
				//Remove o ID do array de respostas
				arrUserResps.splice(arrUserResps.indexOf(evt.currentTarget.id), 1);
				evt.currentTarget.gotoAndStop('DISABLED');
			}
			
			evt.currentTarget.parent.parent.confirmaBt.visible = true;
		}
		
		
		private function feedView():void {		    
			for each (var mcDisabled:MovieClip in arrAlternativas) {				
				if (mcDisabled.checkBt.currentFrameLabel == "CHECK") {
					if (objQuizAtual.arrGabarito.indexOf(mcDisabled.checkBt.id)){
						mcDisabled.checkBt.gotoAndStop("FEED");
						mcDisabled.checkBt.feedMc.anima.mao.gotoAndStop("negativo");
						TweenMax.to(mcDisabled.checkBt.feedMc.anima, 1, { y:44 } );						
					}else {
						mcDisabled.checkBt.gotoAndStop("FEED");
						mcDisabled.checkBt.feedMc.anima.mao.gotoAndStop("positivo");
						TweenMax.to(mcDisabled.checkBt.feedMc.anima, 1, { y:44 } );							
					}
				}
			}
		}
		
		
		
		private function verificaResposta(evt:MouseEvent):void{			
			//Desabilita alternativas
			evt.currentTarget.visible = false;
			quizContainner.avancaBt.visible = true;
			for each (var mcDisabled:MovieClip in arrAlternativas) {
				mcDisabled.mouseChildren = false;	
				mcDisabled.mouseEnabled = false;
			}			
			
			//Envia para o LMS a resposta do usuario e o gabarito.
			if (Main.instance._stateController.configEngine.scorm) {
				Main.instance.debug("interection id: ", arrUserResps);
				Main.instance.debug("interection2 id: ", objQuizAtual.arrGabarito);
				Main.instance.debug("interection3 id: ", objQuizAtual.contadorInteraction);
				Main.instance._stateController.scormControl.salvaResposta(arrUserResps.join(','), objQuizAtual.arrGabarito.join(','), objQuizAtual.contadorInteraction);
			}
			
			if(isCorrect()){
				//Caso acerto grava o acerto no LMS.
				if(Main.instance._stateController.configEngine.scorm){
					Main.instance._stateController.scormControl.interactionIsCorrect(objQuizAtual.contadorInteraction);		
				}
				userAcertos++;
			}else{
			   //Caso erro grava o erro no LMS.
			   if(Main.instance._stateController.configEngine.scorm){
					Main.instance._stateController.scormControl.interactionIsWrong(objQuizAtual.contadorInteraction);
			   }
			  
			}
			
			feedView();
		}
		
		
		private function isCorrect():Boolean {	
			var isCorrectBl:Boolean = true;
			
			if(objQuizAtual.arrGabarito.length == arrUserResps.length){
				for each (var correctRespId:String in objQuizAtual.arrGabarito) {
					if(arrUserResps.indexOf(correctRespId) == -1){
						isCorrectBl = false;
					}
				}
			}else{
				isCorrectBl = false;
			}
				
			return isCorrectBl;
		}
		
		 
		
		private function getPct(min:Number, max:Number, valueAtual:Number):Number
		{
			if (valueAtual <= min) {
				return 0;
			}else {
				return Number(((valueAtual - min) * 100) / (max - min));
			}
		}
		
		
		//Randomiza
		private function randomize(array:Array):Array
		{
			var temp:Object;
			var tempOffset:int;
			for (var i:int = array.length - 1; i >= 0; i--)
			{
				tempOffset = Math.random() * i;
				temp = array[i];
				array[i] = array[tempOffset];
				array[tempOffset] = temp;
			}
			return array;
		}		
		
	}

}