package com.affero.alert 
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageAlign;
    import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author luiz.coelho
	 */
	public class AlertBox extends MovieClip
	{
		
		public var fundoBox:MovieClip;
		public var conteudoAlertBox:ConteudoAlertBox;
		private var _stageRef:Stage;
		
		
		
		public function AlertBox(_stage:Stage = null) 
		{
			this._stageRef = _stage;
			this.conteudoAlertBox.confirmaBt.visible = false;
			this.conteudoAlertBox.rejeitaBt.visible = false;
			this.conteudoAlertBox.okBt.visible = false;
			
			if (this.stage == true && _stage != null) {
                this.init();
            } else {
                this.addEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
            }
			
			//
			//NILO
			//this.resizeHandler();	
			//NILO
		}
		
		private function handleAddedToStage(event:Event):void {
            this.removeEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
            this.init();
        }
		
		private function init():void {
			
			this.conteudoAlertBox.x = Main.instance.getStage().stageWidth/2;
			this.conteudoAlertBox.y = Main.instance.getStage().stageHeight/2;
			
			this.fundoBox.x = 0;
			this.fundoBox.y = 0;
			
			this.fundoBox.width = Main.instance.getStage().stageWidth;
			this.fundoBox.height = Main.instance.getStage().stageHeight;
			//Main.instance.resizeHandler(this.conteudoAlertBox, true);
			//this._stageRef.addEventListener(Event.RESIZE, resizeHandler);			
		}
		
		public function set infos(label:String):void {			
			this.conteudoAlertBox.descricaoTxt.htmlText = label;
		}
		
		
		public function confirmaButton(descLabel:String, onConfirma:Function):void {			
			this.conteudoAlertBox.confirmaBt.visible = true;
			this.conteudoAlertBox.confirmaBt.label.htmlText = descLabel;
			this.conteudoAlertBox.confirmaBt.addEventListener(MouseEvent.CLICK, onConfirma);			
		}
		
		public function rejeitaButton(descLabel:String, onRejeita:Function):void {			
			this.conteudoAlertBox.rejeitaBt.visible = true;
			this.conteudoAlertBox.rejeitaBt.label.htmlText = descLabel;
			this.conteudoAlertBox.rejeitaBt.addEventListener(MouseEvent.CLICK, onRejeita);
		}
		
		public function okButton(onOk:Function):void {			
			this.conteudoAlertBox.okBt.visible = true;
			this.conteudoAlertBox.confirmaBt.addEventListener(MouseEvent.CLICK, onOk);		
		}		
		
		public function removeFromStage():void {
			this.parent.removeChild(this);
		}
		
	}

}