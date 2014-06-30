package com.affero.base.utils {

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

public class LoadingProgress extends MovieClip {

    private var _stage:Stage;
    public var loadingMovie:MovieClip;
    public var background:Sprite;
    public var mcBackGround:MovieClip;
    public var isVisible:Boolean = false;
    public var loadingLabel:TextField;

    //O loading precisa ter um movieclip com  nome "mcBackGround" como base para calculo de posicionamento
    //O loading precisa ter um textfield com o nome "txtLabel" onde sera exibido o texto
    //a instancia do preloader no palco precisa se chamar "preLoader"
    public function LoadingProgress(stage:Stage, inLoadingMovie:MovieClip = null) {
        this._stage = stage;
        this._stage.addEventListener(Event.RESIZE, resizeHandler);
        this._stage.align = StageAlign.TOP_LEFT;
        this._stage.scaleMode = StageScaleMode.NO_SCALE;

        if (inLoadingMovie) {
            this.loadingMovie = inLoadingMovie;
            this.loadingLabel = inLoadingMovie["txtLabel"];
        } else {
            loadingMovie = new LoadingMovieDefault();
            loadingLabel = loadingMovie["txtLabel"];
        }
        
        background = new Sprite();
        background.graphics.beginFill(0x663300, 0.6);
        background.graphics.drawRect(0, 0, Main.APP_WIDTH, Main.APP_HEIGHT);
        background.graphics.endFill();
        this.addChild(background);
		

        this.addChild(loadingMovie);
        handleStage();
    }

    public function handleStage():void {
		
		var stW:Number = Main.instance.getStage().stageWidth;
		var stH:Number = Main.instance.getStage().stageHeight;
		
        background.width = stW;		
        background.height = stH;
		
		loadingMovie.x = stW/2;
		loadingMovie.y = stH/2;
		
    }

    public function setVisible(visible:Boolean):void {
        if (visible) {
            if (!isVisible) {
                this._stage.addChild(this);
                isVisible = true;
            }
        } else {
            if (isVisible) {
                this._stage.removeChild(this);
                isVisible = false;
            }
        }
        handleStage();
    }

    public function setTextLabel(inTxt:String):void {
        loadingLabel.text = inTxt;
		loadingLabel.autoSize = TextFieldAutoSize.LEFT;
    }

    //Listener´s
    private function resizeHandler(e:Event):void {
        handleStage();
    }
}
}