package com.affero.controller {

import com.affero.alert.AlertBox;
import com.affero.model.application.ConfigVO;
import com.affero.model.application.TelasVO;
import com.greensock.events.LoaderEvent;
import com.greensock.loading.SWFLoader;
import com.greensock.loading.XMLLoader;
import com.greensock.TweenMax;
import com.affero.base.utils.json.Converter;
import com.view.Fundo;
import com.view.LoadingTela;
import com.view.Moldura;
import com.view.MovieClipInteraction;
import flash.display.MovieClip;
import flash.events.*;
import flash.external.ExternalInterface;
import flash.net.FileReference;
import flash.utils.Timer;
import com.maccherone.json.JSON;

public class AppController extends EventDispatcher {
    public var main : Main = null;
    public var mapController : MapController;
    public var hudController : HudController;
    public var popUpController : PopUpController;
	public var molduraController : InfosLayerController;
    public var stateMachine:StateController;
	private var loadingTelas:MovieClip;
	public var indiceMark:int;
	private var loader:SWFLoader;
	private var xmlLoader:XMLLoader;
	public var interactionAtual:MovieClip;
	public var moldura:Moldura;
	
	public var refTelaAtual:TelasVO;
	private var alertBox:AlertBox;
	private var loadingTela:LoadingTela;
	public var _qlComents:Qc;
	
	private var xmlTela:XML;
	private var frameInicial:String = "";
	
	public function AppController() {
        this.main = Main.instance;
        mapController = new MapController(Main.instance._mapLayer);
        hudController = new HudController(Main.instance._hudLayer);
        popUpController = new PopUpController(Main.instance._popUpLayer);
		molduraController = new InfosLayerController(Main.instance._molduraLayer);		
    }

    public function initialize(stateMachine : StateController) : void {
        this.stateMachine= stateMachine;    
    }

    public function startApp():void {		
       	//TODO:// Iniciar a aplicação aqui
		moldura = new Moldura();	
		
		moldura.visible = Main.instance._stateController.configEngine.moldura;		
		moldura.controlesMc.visible = Main.instance._stateController.configEngine.controles;
		moldura.footerMc.visible = Main.instance._stateController.configEngine.controles;
		moldura.mcBarra.visible = Main.instance._stateController.configEngine.controles;
		
		
		this.molduraController.addChildOnPlaceHolder(moldura, "moldura");
		///nilo///moldura.tituloTreinamento = Main.instance._stateController.couserConfig.tituloTreinamento;///nilo
		
		var fundo:Fundo = new Fundo();
		fundo.name = "fundo";
		
		this.mapController.addChildOnPlaceHolder(fundo, "fundo");
		Main.instance.resizeHandler(fundo, true);
		
		loadingTelas = new MovieClip();
		this.mapController.addChildOnPlaceHolder(loadingTelas, "loadingTelas");
		openScreen();
		
		
		//Adiciona Coments		
		if (stateMachine.configEngine.comments) {
			_qlComents = new Qc("on");
		}else {
			_qlComents = new Qc("off");
		}
    }
	
	
	private function openScreen():void {
	
		//this.popUpController.addChildOnPlaceHolder(_qlComents, _qlComents.name);
		
		if (bookMark.length > 0) {
		   //Confirmação se deseja continuar de onde parou			   
		  alertBox = new AlertBox(Main.instance.getStage());
		  alertBox.infos = 'Você deseja continuar de onde parou?';
		  alertBox.confirmaButton('Sim', onConfirma);
		  alertBox.rejeitaButton('Não', onRejeita);		  
		  
		  this.molduraController.addChildOnPlaceHolder(alertBox, 'bookMarkAlert');		  		   
	    }
	    else {		  
		  //Começa do inicio
		  addScreenToStage(Main.instance._stateController.couserConfig.telas[this.indiceMark]);	
		  
		  if (Main.instance._stateController.configEngine.maxScore > 0 && Main.instance._stateController.configEngine.scorm == true) {
			Main.instance._stateController.scormControl.maxScore = Main.instance._stateController.configEngine.maxScore;
		  }
		  
		  if (Main.instance._stateController.configEngine.minScore > 0) {
			Main.instance._stateController.scormControl.minScore = Main.instance._stateController.configEngine.minScore;	
		  }
	    }/**/
	}
	
	
	private function onConfirma(evt:MouseEvent):void {
		 findMarkPosition(bookMark);
		 addScreenToStage(Main.instance._stateController.couserConfig.telas[this.indiceMark]);
		 this.molduraController.removeChildOnPlaceHolder('bookMarkAlert');			
    }
	
	private function onRejeita(evt:MouseEvent):void {
		addScreenToStage(Main.instance._stateController.couserConfig.telas[this.indiceMark]);
		this.molduraController.removeChildOnPlaceHolder('bookMarkAlert');
	}
	
	private function ativaBtsControle(screenAtualId:String):void {
		//Controle volta
		if (findPosition(screenAtualId) == 0) {
			   moldura.voltaBt.mouseEnabled = false;
			   moldura.voltaBt.gotoAndStop('DISABLED');
		}else {
			moldura.voltaBt.mouseEnabled = true;
			moldura.voltaBt.gotoAndStop('UP');
		}			   				   
		
		
		//controle avança
		if (Main.instance._stateController.couserConfig.telas[findPosition(screenAtualId)].visited == true) {
		   if (Main.instance._stateController.couserConfig.telas.length != findPosition(screenAtualId) + 1) {
			   moldura.avancarBt.mouseEnabled = true;
			   
			   if (Main.instance._stateController.couserConfig.telas[findPosition(screenAtualId) + 1].visited == true) {
				 moldura.avancarBt.gotoAndStop('UP');
			   }else {
				 moldura.avancarBt.gotoAndStop('BLINK');
			   }
			   
		   }else {
			   moldura.avancarBt.mouseEnabled = false;
			   moldura.avancarBt.gotoAndStop('DISABLED');
		   }		   		   
		}else {
			   moldura.avancarBt.mouseEnabled = false;
			   moldura.avancarBt.gotoAndStop('DISABLED');
		}
    }
	
	
	
	private function findMarkPosition(screenId:String = ""):void {		 
	 	  for (var i:int; i < Main.instance._stateController.couserConfig.telas.length; i++ ) {
				this.indiceMark = i;
				
				if (Main.instance._stateController.couserConfig.telas[i].id == screenId) {
					break;
				}			
		  }	  
	}
	
	
	private function findPosition(screenId:String = ""):int {		 
	 	var rtInt:int = -1; 
		for (var i:int; i < Main.instance._stateController.couserConfig.telas.length; i++ ) {
				if (Main.instance._stateController.couserConfig.telas[i].id == screenId) {
					rtInt = i;					
				}			
		 }
		 
		 return rtInt;
	}
	
	
	//Adiciona 
	private function addScreenToStage(telaObject:TelasVO):void {		
		
		loader = new SWFLoader(telaObject.telaURL, {container:this.loadingTelas, alpha:0, onProgress:progressHandler, onComplete:completeHandler});
        loader.load();
		
		loadingTela = new LoadingTela();		
		this.mapController.addChildOnPlaceHolder(loadingTela, loadingTela.name);
		Main.instance.resizeHandler(loadingTela, true);
		
		
		//ativaBtsControle(telaObject.id);
		refTelaAtual = telaObject;
		//nilo//moldura.tituloTela = telaObject.tituloTela;
		
		var indiceProgress:int = Main.instance._stateController.couserConfig.telas.indexOf(telaObject) + 1;
		/*Main.instance.debug("Tela OBJ", telaObject);
		Main.instance.debug("Indice", indiceProgress);
		Main.instance.debug("Total", Main.instance._stateController.couserConfig.telas.length);*/
		
		var progressPct:uint = Math.round(100 * (indiceProgress / Main.instance._stateController.couserConfig.telas.length));
		this.moldura.courseProgress = progressPct;		
		
		
		//Loading XML Tela
		xmlLoader = new XMLLoader(telaObject.xmlTela, { name:"xmltela", onComplete:completeLoadXmlTela});
		xmlLoader.load();
		
		//_qlComents.updateTela(telaObject.id);
	}
	
	private function completeLoadXmlTela(event:Event):void {
		xmlTela = xmlLoader.getContent("xmltela");	
	}
	
	public function getXmlTelaNode(nodeId:String):* {
		var rtStr:String =  "ID NÃO ENCONTRADO.";
		if (xmlTela[nodeId].length() > 0) {
			rtStr = xmlTela[nodeId].children()[0].toXMLString();
		}
		
		return rtStr;
	}
	
	
	
	public function getXMLNodes(nodeId:String):* {
	  	var rtXML:*;
		if (xmlTela[nodeId].length() == 0) {
			rtXML = "XML NÃO ENCONTRADO.";
		}else {
			rtXML = xmlTela[nodeId];
		}
		
		return rtXML;
	}
	
	private function progressHandler(event:LoaderEvent):void {
        loadingTela.porcentagem = event.target.progress;
    }

	private function completeHandler(e:LoaderEvent):void {
		
		loadingTela.removeLoading();// Nilo
		//Book Mark
		this.bookMark = refTelaAtual.id;	
		
		//Deixa o alpha em 100% e dá play na timeline;
		e.target.rawContent.stop();
		
		TweenMax.to(e.target.content, 0.3, { alpha:1, onComplete: e.target.rawContent.play } );
		interactionAtual = e.target.rawContent;
		
		///NILO
		if ( frameInicial == "returnAbertura" ) 
		{
			 interactionAtual.aberturaMc.gotoAndPlay( frameInicial );
			 interactionAtual.aberturaMc.aviao.gotoAndPlay( frameInicial );
		}//// quando vc esta no Game e depois retorna para a Abertura... retorna nesse Frame
		////NILO	
		
		Main.instance.resizeHandler(e.target.content, false);
	}
	
	//NILO --- Avisa que o carregamento foi completado -- CALL dentro da MainAbertura/MainGames
	public function completeLoaderGame():void
	{
		loadingTela.removeLoading();
	}
	//NILO --- Avisa que o carregamento foi completado
	
	public function nextInteraction(evt:MouseEvent):void {
		evt.target.mouseEnabled = false;
		evt.target.gotoAndStop('DISABLED');
		
		
        var position:int = findPosition(refTelaAtual.id);
		if(position < Main.instance._stateController.couserConfig.telas.length - 1){
		  finishInteraction(nextFn);
		}
	}
	
	private function nextFn():void {
		var position:int = findPosition(refTelaAtual.id);
		
		interactionAtual.parent.removeChild(interactionAtual);
		addScreenToStage(Main.instance._stateController.couserConfig.telas[findPosition(refTelaAtual.id) + 1]);
    }
	
	public function prevInteraction(evt:MouseEvent):void {
		evt.target.mouseEnabled = false;
		evt.target.gotoAndStop('DISABLED');
		
		var position:int = findPosition(refTelaAtual.id);
		if(position > 0){
			finishInteraction(prevFn);
		}
	}
	
	private function prevFn():void {
		interactionAtual.parent.removeChild(interactionAtual);
		addScreenToStage(Main.instance._stateController.couserConfig.telas[findPosition(refTelaAtual.id) - 1]);	
    }
	
	public function refreshInteraction(evt:MouseEvent):void {
		finishInteraction(refreshFn);
	}
	
	private function refreshFn():void {
		interactionAtual.parent.removeChild(interactionAtual);
		addScreenToStage(Main.instance._stateController.couserConfig.telas[findPosition(refTelaAtual.id)]);	
	}
	
	public function closeCourseWindow(evt:MouseEvent = null): void {
		if (ExternalInterface.available) {	
		alertBox = new AlertBox(Main.instance.getStage());
		alertBox.confirmaButton("Sim", confirmaSair);
		alertBox.rejeitaButton("Não", rejeitaSair);
		alertBox.infos = "Você deseja sair?";
		this.molduraController.addChildOnPlaceHolder(alertBox, alertBox.name);
	  }
	  
	  function confirmaSair(evt:MouseEvent):void {
		ExternalInterface.call("closeCourseWindow");	  
	  }
	  
	  function rejeitaSair(evt:MouseEvent):void {
		alertBox.removeFromStage();
	  }	  
	  
	}
	
	///////////////////////////////////
	
	public function set bookMark(screenId:String):void {
		///NILO///Main.instance._stateController.couserConfig.bookMark = screenId;
		///NILO/*Main.instance._stateController.saveConfigScorm();*/ ////NILO
	}
	
	public function get bookMark():String {
		return ""
		////NILO////return Main.instance._stateController.couserConfig.bookMark;
	}
	
	
	//Salva um objeto no scorm para resgate
	public function saveObject():void {
		
	}
	
	public function getSavedObject():Object {
		var obj:Object;
		return obj;
	}
	
	public function gotoTela(telaId:String, frameInit:String = ""):void {
		frameInicial = frameInit;
		
		var position:int = findPosition(refTelaAtual.id);
		if(position != -1){
		  finishInteraction(onRemoveToJump);		  
		}
		
		function onRemoveToJump():void {
			interactionAtual.parent.removeChild(interactionAtual);
			addScreenToStage(Main.instance._stateController.couserConfig.telas[findPosition(telaId)]);
		}
	}
	
	
	
	private function goTelaFn():void {
		interactionAtual.parent.removeChild(interactionAtual);
		addScreenToStage(Main.instance._stateController.couserConfig.telas[findPosition(refTelaAtual.id) + 1]);
    }	
	
	
	/* 
	  Metodos para controlar a interação atual 
	*/
	  
	public function liberaTela():void {
		Main.instance._stateController.couserConfig.telas[findPosition(refTelaAtual.id)].visited = true;
		ativaBtsControle(refTelaAtual.id);
		
		if (allView() == true && Main.instance._stateController.configEngine.autoComplete == true && Main.instance._stateController.configEngine.scorm == true) {
			Main.instance._stateController.scormControl.setCourseToComplete();			
		}
	}
	
	public function allView():Boolean {
		var arrView:Array = new Array();
		var viewRt:Boolean = true;
		
		for each(var objConfig:TelasVO in Main.instance._stateController.couserConfig.telas) {
			//nilo//arrView.push(objConfig.visited);
		}
		
		if (arrView.indexOf(false) != -1) {
			viewRt = false;
		}
		
		return viewRt;
	}
	
	public function finishInteraction(disparaOnInteractionFinish:Function):void {
		var _interactionLabels:Array = new Array();		
		for(var i:int; i <  this.interactionAtual.currentLabels.length; i++){
		  _interactionLabels.push(this.interactionAtual.currentLabels[i].name);			  
		}
		
		if(_interactionLabels.indexOf('closeBegin') != -1 && _interactionLabels.indexOf('closeEnd') != -1){
			this.interactionAtual.gotoAndStop('closeBegin');
			TweenMax.to(this.interactionAtual, 1, { frameLabel:'closeEnd', onComplete:disparaOnInteractionFinish } );//NILO
		}
		else{
			TweenMax.to(this.interactionAtual, 0.5, { alpha:0, onComplete:disparaOnInteractionFinish } ); //NILO              
		}		
	}	
	
  }
}