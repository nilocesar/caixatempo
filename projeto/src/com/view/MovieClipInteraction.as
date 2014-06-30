/**
 * Created by IntelliJ IDEA.
 * User: luiz.coelho
  */
package com.view {

	import com.affero.base.utils.SoundController;
	import com.affero.scorm.ScormControl;
    import com.greensock.TweenMax;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import flash.filters.ColorMatrixFilter;
    import flash.geom.ColorTransform;

public class MovieClipInteraction extends MovieClip {
        public var _xmlTela:XML;
		public var _onFinished:Function;
		//Comtém todos os nós contidos no xml da tela em propriedades dentro do objeto.
		public var _xmlNodes:Object;
        private var _interactionLabels:Array;
		public var _mcRef:MovieClip;


        public function MovieClipInteraction() {
           //this._onFinished = onFinished;
           //this._xmlTela = xmlTela;
         
           if (this.stage) {
                this.init();
           } else {
				this.addEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
           }
        }
		
		// Event handlers
        private function handleAddedToStage(event:Event):void {
            this.removeEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
            this.init();
        }
        
        // Init
        protected function init():void {
          this._interactionLabels = new Array();
          for(var i:int; i < this.currentLabels.length; i++){
              this._interactionLabels.push(currentLabels[i].name);			  
          }
        }

      
        //On Finish
        protected function finish():void {
            if(this._interactionLabels.indexOf('closeBegin') != -1 && this._interactionLabels.indexOf('closeEnd') != -1){
                this.gotoAndStop('closeBegin');
                TweenMax.to(this, 1, { frameLabel:'closeEnd', onComplete:disparaOnFinish } );
            }else{
               TweenMax.to(this, 0.5, { alpha:0, onComplete:disparaOnFinish } );               
            }
        }

		//Chama o metododo de finalização e remove a interação do stage.
        private function disparaOnFinish():void{
             if (this._onFinished !== null) {
                    this._onFinished(); 
			}
            
            this.parent.removeChild(this);
        }

        //Methods Utils
        public function setFilter(mc:MovieClip, obj:Object):void{
            var color:ColorTransform;
            color = new ColorTransform();

            if(obj.brightness!=null){
                color.redOffset = obj.brightness;
                color.greenOffset = obj.brightness;
                color.blueOffset = obj.brightness;
                mc.transform.colorTransform = color;
            }

            if(obj.blackWhite){
                var rc:Number = 1/3;
                var gc:Number = 1/3;
                var bc:Number = 1/3;
                var cmf:ColorMatrixFilter = new ColorMatrixFilter([rc, gc, bc, 0, 0, rc, gc, bc, 0, 0, rc, gc, bc, 0, 0, 0, 0, 0, 1, 0]);
                mc.filters = [cmf];
            }
        }
		
		
		//Controle de sons
		public function playSound(soundID:String, onInit:Function, onComplete:Function):void {
			var soundURL:String = _xmlNodes[soundID];
			var soundController:SoundController = new SoundController();
			soundController.playFromStream("", soundURL, soundID, 1, 1 ,0, onInit, onComplete);
		}
		
		public function get scormControls():ScormControl {
			return Main.instance._stateController.scormControl;
		}		
		
    }
}
