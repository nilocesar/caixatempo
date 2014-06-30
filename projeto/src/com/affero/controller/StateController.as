package com.affero.controller {
import com.affero.model.application.ConfigVO;
import com.affero.model.application.ConfigEngineVO;
import com.affero.model.application.TelasVO;
import com.affero.scorm.ScormControl;
import com.greensock.events.LoaderEvent;
import com.affero.base.utils.AssetsLoader;
import com.maccherone.json.JSON;
import com.demonsters.debugger.MonsterDebugger;
import com.greensock.loading.LoaderMax;
import com.affero.base.utils.json.Converter;
import com.affero.base.utils.TextFieldExtended;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.net.FileReference;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.text.StyleSheet;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.external.ExternalInterface;
import com.greensock.TweenMax;


public class StateController extends EventDispatcher {
    public var glossarioFile : Object;
	private var arrayVO:Array = [];
	//Criando o objeto de configuração
	private var configFile:ConfigVO;
	public var configEngine:ConfigEngineVO;
	public var scormControl:ScormControl;
   	
    public function StateController() {        
		//TODO:Array contendo todos os objetos que vão ser ultilizados no json
		arrayVO = [ConfigVO, ConfigEngineVO, TelasVO];
		
		//Lendo o arquivo de configuração da engine
		var configsEngines : String = LoaderMax.getContent("configsEngine");
		configEngine = Converter.createObject(JSON.decode(configsEngines));
		
		//Loading json references arquivo para configuração do engine
		var configs : String = LoaderMax.getContent("configs");	  
		configFile = Converter.createObject(JSON.decode(configs));
		
		//Caso seja scorm		
		if(configEngine.scorm && ExternalInterface.available){
			scormControl = new ScormControl(configFile);
			configFile = scormControl.jsonConfig;
		}			
    }
	
	public function get couserConfig():ConfigVO {
	  return configFile;
	}
	
	public function saveConfigScorm():void {
	   	
		if (scormControl != null) {
			scormControl.jsonConfigObj = couserConfig;
			scormControl.saveCourseStatus();
			
			scormControl.setCourseToComplete();//nilo
		}
	}
	
	public function initialize() : void {
       dataLoaded();		
	}
	
	public function dataLoaded() : void {
        this.dispatchEvent(new Event("dataLoaded"));	
    }
  	
	

    private function debug(msg : String, obj : *, person : String = "", label : String = "", color : uint = 0x000000) : void {
        Main.instance.debug(msg, obj, person, label, color);

    }	
	
   }
}