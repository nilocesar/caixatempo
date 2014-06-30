package {
	import com.affero.base.utils.AssetsLoader;
	import com.affero.base.utils.BaseScroll;
	import com.affero.base.utils.cronometro.Tempo;
	import com.affero.base.utils.LoadingProgress;
	import com.affero.base.utils.SoundController;
	import com.affero.controller.AppController;
	import com.affero.controller.StateController;
	import com.affero.stageAlign.StageAlignTool;
	import com.affero.fluidLayout.*;
	import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.TweenMax;	
    import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.LoaderInfo;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
	import flash.events.Event;
    import flash.net.NetConnection;
	import flash.events.NetStatusEvent;
	import flash.net.ObjectEncoding;
    import flash.net.Responder;
	import flash.external.ExternalInterface;
    import flash.text.Font;

public class Main extends MovieClip {

	private static var _instance:Main = new Main(SingletonLock);
    public var _preLoader:LoadingProgress;
    public var assetsLoader:AssetsLoader;
    public var _soundController:SoundController;
    public var _AppController:AppController;
    public var _mapLayer:MovieClip;
    public var _hudLayer:MovieClip;
    public var _popUpLayer:MovieClip;
	public var _molduraLayer:MovieClip;
    public var _stateController:StateController;
    public var hasCustomPreloader:Boolean = true;
	public var swf_width:int = 0;
    public var swf_height:int = 0;
	private var layersCreated:Boolean = false;
	private var monsterActive:Boolean = true;
	private var _loaderInfo : LoaderInfo;
	
	
	
	//AMFPHP
    private var connection:NetConnection;
	
	/* Access of the Main instance */
    public static function get instance():Main {
        return _instance;
    }
	
	public static function get APP_WIDTH():Number {
		return instance.stage.stageWidth;
	}
	
	public static function get APP_HEIGHT():Number {
		return instance.stage.stageHeight;
	}

    public function Main(theLock:Class):void {
        if (theLock != SingletonLock) throw new Error("It's impossible to instantiate a singleton. Use Main.instance");
        addEventListener(Event.ADDED_TO_STAGE, init);	
    }

    private function init(e:Event = null):void {
		
		//
		 _loaderInfo = this.loaderInfo;
         _loaderInfo.addEventListener(Event.COMPLETE, loaded );
		
		
		removeEventListener(Event.ADDED_TO_STAGE, init);
		
		//TODO:DESATIVAR MONSTER NA APP FINAL.
       if(monsterActive){ 
		   MonsterDebugger.initialize(this);
		   MonsterDebugger.clear();
	   }         
       if (hasCustomPreloader) {
           loadPreLoader();
       }else {
           setDefaultPreloader();
       }	  
    }
	
	private function loaded( e : Event ) : void {
		swf_width = e.currentTarget.width;
		swf_height = e.currentTarget.height;
    }
	
	///NILO
	public function resizeHandler( _this:* = null , _componente:Boolean = false ):void
	{
		if (_this != null)
		{
			
			var _params:Object;
			if (_componente )
			{
				_params = {
					x:.5,
					y:.5,
					offsetX: -_this.width/2 ,
					offsetY: -_this.height/2
				};
			}
			else
			{
				_params = {
					x:.5,
					y:.5,
					offsetX: -swf_width/2 ,
					offsetY: -swf_height/2
				};
			}
		
			
			//Alin Center			
			new FluidObject(_this,_params);

		}
		
        
		//if(layersCreated){			
            //_molduraLayer.x = 0;
            //_molduraLayer.y = 0;
			//
			//
			//_popUpLayer.x = (this.stage.stageWidth / 2) - (_popUpLayer.width / 2);
            //_popUpLayer.y = (this.stage.stageHeight / 2) - (_popUpLayer.height / 2);			
			//
			//
			///NILO
			///*_mapLayer.x = (this.stage.stageWidth / 2) - (_mapLayer.width / 2);
			//_mapLayer.y = (this.stage.stageHeight / 2) - (_mapLayer.height / 2);
			//
			//if (_mapLayer.y < _AppController.moldura.headerMc.y + _AppController.moldura.headerMc.height) {
				//_mapLayer.y = _AppController.moldura.headerMc.y;
			//}		
			//
			//_hudLayer.x = -40;
            //_hudLayer.y = this.stage.stageHeight;*/
			//
			///Nilo
			//
        //}	
    }
	///NILO
	
	
	private function loadPreLoader():void {
        assetsLoader = new AssetsLoader();
        var path:String = computePath("data/assets/preloader.swf" + "?" + new Date().getTime());
        assetsLoader.loadSWFAsset(path , { name:"preloader", estimatedBytes:4800, onComplete:onLoadPreloader }, false);
    }

    private function onLoadPreloader(loaderEvent:LoaderEvent):void {
        _preLoader = new LoadingProgress(this.stage, LoaderMax.getContent("preloader").rawContent["preLoader"]);
        loadXMLAssets();
    }

    private function setDefaultPreloader():void {
        _preLoader = new LoadingProgress(this.stage, null);
        loadXMLAssets();
    }

    private function loadXMLAssets():void {
        _preLoader.setTextLabel("CARREGANDO");
        _preLoader.setVisible(true);
        var path:String = computePath("data/assets.xml" + "?" + new Date().getTime());
        assetsLoader.loadXMLAssets(path, { name:"xmlAssets", onComplete:onLoadXMLAssets, estimatedBytes: 50000000 }, true);
    }

    private function onLoadXMLAssets(loaderEvent:LoaderEvent):void {
        _soundController = new SoundController();
        registerXMLSounds();
    }

    private function registerXMLSounds():void {
        var xmlAssets:XML = LoaderMax.getContent("xmlAssets");
        for (var i:int = 0; i < xmlAssets.child(0).children().length(); i++) {
            if (xmlAssets.child(0).children()[i].name() == "MP3Loader") {
                var _name:String = String(xmlAssets.child(0).children()[i].@name);
                _soundController.registerXMLSoundInLibrary(_name);
            }
        }
        _preLoader.setVisible(false);
        initApp();
    }
	
	public function clearLoadedChildren(mc:MovieClip):void {
		 if(mc != null){
			   while (mc.numChildren > 0) {
				mc.removeChildAt(0);
			  }
		 }	  
	}

    private function initApp():void {
        //PopUpLayer
        _popUpLayer = new MovieClip();
        this.addChild(_popUpLayer);	
		
		
		//MapLayer
        _mapLayer = new MovieClip();
		this.addChild(_mapLayer);
		
        //HudLayer
        _hudLayer = new MovieClip();
		this.addChild(_hudLayer);

       
		
		//infosLayer
		_molduraLayer = new MovieClip();
		this.addChild(_molduraLayer);
		
		//AppController
        _AppController = new AppController();
        layersCreated = true;
        initStateMachine();
    }

    private function initStateMachine():void {
        _stateController = new StateController();
        _AppController.initialize(_stateController);
        _stateController.addEventListener("dataLoaded", iniApp);
        _stateController.initialize();
    }

    private function iniApp(e:Event):void {
       	_AppController.startApp();
    }

    public function debug(msg:String, obj:*, person:String = "", label:String = "", color:uint = 0x000000):void {
        MonsterDebugger.trace(msg, obj, person, label, color);
    }

    public function getStage():Stage {
        return this.stage
    }


    public function computePath(path:String):String{
       return path;
    }



    //CRIANDO CONEXÕES COM O AMFPHP
    public function conectToAMFPHP(gateway:String):void{
       connection = new NetConnection();
	   connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
	   connection.objectEncoding = ObjectEncoding.AMF3;
	   connection.connect(gateway);	  
    }
	
	
	public function netStatusHandler(event:NetStatusEvent):void {
		    //debug('STATUS AMFPPHP CONNECTION', event.info.code);		   
    }
	
	
	public function CALL_AMF_FUNCTION(onResultIn:Function, AMF_CALL:String, ...rest):void {
		//debug('CALL AMF',AMF_CALL);
		var responder:Responder = new Responder(onResultIn, onFault);
		
		if (rest.length > 0) {
			connection.call(AMF_CALL, responder, rest);
		}else {
			connection.call(AMF_CALL, responder);
		}	
	}
	

	
	private function onFault(obj:Object):void{			
		//debug('AMFPHP CALL FAULT', obj);
	}	
	
	
}

}

class SingletonLock {
}
