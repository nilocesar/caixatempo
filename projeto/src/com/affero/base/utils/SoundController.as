package com.affero.base.utils {


import com.greensock.events.LoaderEvent;
import com.greensock.loading.LoaderMax;
import com.greensock.loading.MP3Loader;
import com.reintroducing.events.SoundManagerEvent;
import com.reintroducing.sound.SoundManager;

import flash.display.MovieClip;
import flash.media.Sound;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import flash.utils.setTimeout;

public class SoundController extends MovieClip {

    private var _channels:Dictionary = new Dictionary();
    private var _sm:SoundManager;
    private var _mp3Loader:MP3Loader;
    private var _loadList:Dictionary = new Dictionary();

    public function SoundController():void {
        _sm = SoundManager.getInstance();
        _sm.addEventListener(SoundManagerEvent.SOUND_ITEM_ADDED, onSoundAdded);
        _sm.addEventListener(SoundManagerEvent.SOUND_ITEM_LOAD_PROGRESS, onSoundProgress);
        _sm.addEventListener(SoundManagerEvent.SOUND_ITEM_LOAD_COMPLETE, onSoundLoadComplete);
        _sm.addEventListener(SoundManagerEvent.SOUND_ITEM_FADE_COMPLETE, onFadeComplete);
        _sm.addEventListener(SoundManagerEvent.SOUND_ITEM_PLAY_COMPLETE, onPlayComplete);
    }

    public function addSountToLibrary(path:String, name:String, onLoad:Function):void {
        var soundElement:Object = new Object();
        soundElement.onLoad = onLoad;
        soundElement.onComplete = null;
        soundElement.args = null;
        _loadList[name] = soundElement;
        _mp3Loader = new MP3Loader(path, {name:name, autoPlay:false, onComplete:registerSoundInLibrary});
        _mp3Loader.load();
    }

    public function registerSoundInLibrary(e:LoaderEvent):void {
        var _sound:Sound = LoaderMax.getContent(e.target.name);
        _sm.addPreloadedSound(_sound, e.target.name);
        var _f:Function = _loadList[e.target.name].onLoad;
        _f.apply(null, null);
    }

    public function registerXMLSoundInLibrary(name:String):void {
        var soundElement:Object = new Object();
        soundElement.onLoad = null;
        soundElement.onComplete = null;
        soundElement.args = null;
        _loadList[name] = soundElement;
        var _sound:Sound = LoaderMax.getContent(name);
        _sm.addPreloadedSound(_sound, name);
    }

    public function playLibrarySound(name:String, volume:Number, pan:Number, onComplete:Function, ...args):void {
        _loadList[name].onComplete = onComplete;
        _loadList[name].args = args;
        _sm.playSound(name);
        _sm.setSoundVolume(name, volume);
        _sm.setSoundPan(name, pan);
    }

    public function copySoundFromMainToLibrary(libName:String, name:String):void {
        var soundElement:Object = new Object();
        soundElement.onLoad = null;
        soundElement.onComplete = null;
        soundElement.args = null;
        _loadList[name] = soundElement;
        var _sound:Class = (getDefinitionByName(libName) as Class);
        _sm.addLibrarySound(_sound, name);
    }

    public function addSoundToQeue(channel:String, path:String, name:String, volume:Number, pan:Number, wait:int, onInit:Function, onComplete:Function, ...args):void {
        if (!_channels[channel]) {
            _channels[channel] = new Array();
        }
        var soundElement:Object = new Object();
        soundElement.channel = channel;
        soundElement.path = path;
        soundElement.name = channel + '_track_' + name;
        soundElement.volume = volume;
        soundElement.pan = pan;
        soundElement.wait = wait;
        soundElement.onInit = onInit;
        soundElement.onComplete = onComplete;
        soundElement.args = args;
        _channels[channel].push(soundElement);
        if (_channels[channel].length == 1) {
            playSoundOnQeue(channel);
        }
    }

    public function playFromStream(channel:String, path:String, name:String, volume:Number, pan:Number, wait:int, onInit:Function, onComplete:Function, ...args):void {
        _channels[channel] = new Array();
        var soundElement:Object = new Object();
        soundElement.channel = channel;
        soundElement.path = path;
        soundElement.name = channel + '_track_' + name;
        soundElement.volume = volume;
        soundElement.pan = pan;
        soundElement.wait = wait;
        soundElement.onInit = onInit;
        soundElement.onComplete = onComplete;
        soundElement.args = args;
        _channels[channel].push(soundElement);
        if (_channels[channel].length == 1) {
            playSoundOnQeue(channel);
        }
    }

    private function playSoundOnQeue(channel:String):void {
        if (_channels[channel].length > 0) {
            var soundElement:Object = new Object();
            soundElement = _channels[channel][0];
            if (soundElement.wait == 0) {
                _sm.addExternalSound(String(soundElement.path), soundElement.name);
                _sm.playSound(soundElement.name);
                _sm.setSoundVolume(soundElement.name, soundElement.volume);
                _sm.setSoundPan(soundElement.name, soundElement.pan);
            } else {
                setTimeout(waitBeforeSound, soundElement.wait, channel);
                soundElement.wait = 0;
            }
        }
    }

    public function stopSound(channel:String, name:String):void {
        _channels[channel] = new Array();
        var _name:String = channel + '_track_' + name;
        try {
            _sm.stopSound(_name);
            //_sm.fadeSound(name);
        }
        catch (erro:Error) {
            trace(erro.message);
        }
    }

    private function waitBeforeSound(channel:String):void {
        playSoundOnQeue(channel);
    }

    private function onSoundAdded(evt:SoundManagerEvent):void {
        //trace("SOUND: " + evt.soundItem.name);
    }

    private function onSoundProgress(evt:SoundManagerEvent):void {
        //trace("SOUND: " + evt.soundItem.name + " & PROGRESS: " + evt.percent);
    }

    private function onSoundLoadComplete(evt:SoundManagerEvent):void {
        if(evt.soundItem){
            var soundData:Array = evt.soundItem.name.split("_track_");
            var channel:String = soundData[0];
            var soundElement:Object = new Object();
            soundElement = _channels[channel][0];
            if(soundElement.onInit) {
                if (soundElement.onInit != null && soundElement.onInit != "null") {
                    var _f:Function = soundElement.onInit;
                    _f.apply(null, null);
                }
            }
        }
    }

    private function onFadeComplete(evt:SoundManagerEvent):void {
        //trace("SOUND: " + evt.soundItem.name + " FADE COMPLETE");
    }

    private function onPlayComplete(evt:SoundManagerEvent):void {
        var soundData:Array = evt.soundItem.name.split("_track_");
        var soundElement:Object = new Object();
        var _f:Function;
        if (soundData.length == 1) {
            soundElement = _loadList[evt.soundItem.name];
            if (soundElement.onComplete != null) {
                _f = soundElement.onComplete
                if (soundElement.args.length > 0) {
                    _f.apply(null, [soundElement.args]);
                } else {
                    _f.apply(null, null);
                }
            }
        } else if (soundData.length == 2) {
            var channel:String = soundData[0];
            soundElement = _channels[channel][0];
            if (soundElement.onComplete != null) {
                _f = soundElement.onComplete
                if (soundElement.args.length > 0) {
                    _f.apply(null, [soundElement.args]);
                } else {
                    _f.apply(null, null);
                }
            }
            _channels[channel].splice(0, 1);
            if (_channels[channel].length > 0) {
                playSoundOnQeue(channel);
            }
        }
    }

    override public function toString():String {
        return getQualifiedClassName(this);
    }

}
}