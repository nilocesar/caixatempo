package com.affero.base.utils {



//import com.demonsters.debugger.MonsterDebugger;
import com.greensock.events.LoaderEvent;
import com.greensock.loading.*;

public class AssetsLoader {

    private var queue:LoaderMax = new LoaderMax({name:"mainQueue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler, maxConnections:1, skipFailed:false, auditSize:true });
    private var loadingProgress:LoadingProgress;
    private var showProgress:Boolean;

    public function AssetsLoader(inLoadingProgress:LoadingProgress = null) {
        LoaderMax.activate([ImageLoader, SWFLoader, DataLoader, MP3Loader]);
        this.loadingProgress = inLoadingProgress;
		//queue.prependURLs(Main.instance.returnPath(), true);
    }

    public function loadSWFAsset(assetPath:String, params:Object, inShowProgress:Boolean = true):void {
        assetPath = Main.instance.computePath(assetPath);
        queue.append(new SWFLoader(assetPath, params));
        startLoad(inShowProgress);
    }

    public function loadXMLAssets(assetPath:String, params:Object, inShowProgress:Boolean = true):void {
        assetPath = Main.instance.computePath(assetPath);
        queue.append(new XMLLoader(assetPath, params));
        startLoad(inShowProgress);
    }

    public function loadDataAssets(assetPath:String, params:Object, inShowProgress:Boolean = true):void {
        assetPath = Main.instance.computePath(assetPath);
        queue.append(new DataLoader(assetPath, params));
        startLoad(inShowProgress);
    }

    public function loadMP3Assets(assetPath:String, params:Object, inShowProgress:Boolean = true):void {
        assetPath = Main.instance.computePath(assetPath);
        queue.append(new MP3Loader(assetPath, params));
        startLoad(inShowProgress);
    }

    public function loadImageAssets(assetPath:String, params:Object, inShowProgress:Boolean = true):void {
        assetPath = Main.instance.computePath(assetPath);
        queue.append(new ImageLoader(assetPath, params));
        startLoad(inShowProgress);
    }

    public function videoImageAssets(assetPath:String, params:Object, inShowProgress:Boolean = true):void {
        assetPath = Main.instance.computePath(assetPath);
        queue.append(new VideoLoader(assetPath, params));
        startLoad(inShowProgress);
    }

    private function startLoad(inShowProgress:Boolean = false):void {
        this.showProgress = inShowProgress;
        if ((this.loadingProgress) && (this.showProgress)) {
            this.loadingProgress.setVisible(true);
        }
        queue.load();
    }

    public function progressHandler(event:LoaderEvent):void {
        if ((this.loadingProgress) && (this.showProgress)) {
            this.loadingProgress.setTextLabel(event.target.progress);
        }
        //trace("progress: " + event.target.progress);
    }

    public function completeHandler(event:LoaderEvent):void {
        if ((this.loadingProgress) && (this.showProgress)) {
            this.loadingProgress.setVisible(false);
        }        
    }

    public function errorHandler(event:LoaderEvent):void {
        trace("error occured with " + event.target + ": " + event.text);
        Main.instance.debug("errorHandler", event);
    }



}

}

