package com.view 
{
	import com.affero.base.utils.BaseButton;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import flash.display.Stage;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
	import com.greensock.TweenMax;
	
	
	/**
	 * ...
	 * @author luiz.coelho
	 */
	public class Moldura extends MovieClip
	{	
		
		//Controles Aplicação
		public var avancarBt:BaseButton;
		public var voltaBt:BaseButton;
		public var btRefresh:BaseButton;
		public var btSair:BaseButton;
		
		public var logoMc:MovieClip;
		public var mcBarra:MovieClip;
		public var titulo0:TextField;
		public var titulo1:TextField;
		
		public var headerMc:MovieClip;
		public var footerMc:MovieClip;
		public var textosMc:MovieClip;
		public var controlesMc:MovieClip;
		
		public function Moldura(){			
			if (this.stage) {
                this.init();
           }else {
				this.addEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
           }			   
		}
		
		// Event handlers
        private function handleAddedToStage(event:Event):void {
            this.removeEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
            this.init();
        }
        
        // Init
        protected function init():void{          
			mcBarra.stop();			
			//Mapeia objetos
			this.avancarBt = controlesMc.btAvancar;
			this.voltaBt = controlesMc.btVoltar;
			this.btRefresh = controlesMc.btRefresh;
			this.btSair = btSair;
			this.logoMc = logoMc;
			this.titulo0 = textosMc.titulo0;
			this.titulo1 = textosMc.titulo1;
			this.mcBarra = mcBarra;
			
			this.titulo0.autoSize = TextFieldAutoSize.LEFT;
			this.titulo1.autoSize = TextFieldAutoSize.LEFT;
			
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.addEventListener(Event.RESIZE, resizeHandler);	
			resizeHandler();			
			
			avancarBt.addEventListener(MouseEvent.CLICK, Main.instance._AppController.nextInteraction);
			voltaBt.addEventListener(MouseEvent.CLICK, Main.instance._AppController.prevInteraction);
			btRefresh.addEventListener(MouseEvent.CLICK, Main.instance._AppController.refreshInteraction);
			btSair.addEventListener(MouseEvent.CLICK, Main.instance._AppController.closeCourseWindow);
			
			avancarBt.mouseEnabled = false;
			avancarBt.gotoAndStop('DISABLED');
			
			voltaBt.mouseEnabled = false;
			voltaBt.gotoAndStop('DISABLED');
		}
		
		public function resizeHandler(e:Event = null):void{
			setMcPosition(headerMc,"TL",true);
			setMcPosition(footerMc, "BL", true);
			setMcPosition(btSair, "TR", false,false, -10, 10);
			setMcPosition(controlesMc, "BR", false, false, -10, -10);	
			setMcPosition(mcBarra, "BL", false, false, 10, -10);	
		}
		
		
		public function setMcPosition(mc:MovieClip, orientacao:String, stageWidth:Boolean = false,  stageHeight:Boolean = false, difX:Number=0, difY:Number=0):void {
			if (stageHeight) {
				mc.width = Main.instance.stage.stageHeight;
			}
			
			if (stageWidth) {
				mc.width = Main.instance.stage.stageWidth;
			}
			
			switch(orientacao) {
				case "TL":
				  mc.x = 0 + difX;
				  mc.y = 0 + difY;
				break;
				
				case "TR":
				 mc.y = 0 + difY;
				 mc.x = Main.instance.stage.stageWidth - mc.width + difX;				
				break;
				
				case "BL":
				 mc.y = Main.instance.stage.stageHeight - mc.height + difY;
				 mc.x = 0 + difX;				
				break;
				
				case "BR":
				 mc.y = Main.instance.stage.stageHeight - mc.height + difY;
				 mc.x = Main.instance.stage.stageWidth  - mc.width + difX;				
				break;
				
				case "CL":
				 mc.y = (Main.instance.stage.stageHeight / 2) - (mc.height / 2) + difY;
				 mc.x = 0 + difX;
				break;
				
				case "CR":
				 mc.y = (Main.instance.stage.stageHeight / 2) - (mc.height / 2) + difY;
				 mc.x = Main.instance.stage.stageWidth - mc.width + difX;
				
				break ;
				
				case "CENTER":
				 mc.y = (Main.instance.stage.stageHeight / 2) - (mc.height / 2) + difY;
				 mc.x = (Main.instance.stage.stageWidth / 2) - (mc.width / 2) + difX;				
				break ;
				
			}
			
		}				
		
		public function set tituloTreinamento(str:String):void {
			this.titulo0.htmlText = str;
		}
		
		public function set tituloTela(str:String):void {
			this.titulo1.htmlText = str;
		}
		
		public function set courseProgress(pct:Number):void {
			TweenMax.to(this.mcBarra, 0.3, { frame:pct } );			
		}		
		
	}

}