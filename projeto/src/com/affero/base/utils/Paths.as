package com.affero.base.utils {



public class Paths {
    private static var _savePath:String = "";
    private static var _dataPath:String = "";
    private static var _assetsPath:String = "";
    private static var _imgsPath:String = "";
    private static var _soundsPath:String = "";

    private static var _rootPath:String = "";

    private static var _hasInicialized:Boolean = false;

    public static function initialize(rootPath:String = ""):void {
        _hasInicialized = true;
        rootPath = rootPath.split("\\").join("/");
        if (((Paths.getLastCharInString(rootPath) != "/")) && (rootPath.length > 0)) {
            rootPath += "/";
        }
    }


    private static function getLastCharInString(s:String):String {

        return s.substr(s.length - 1, s.length);
    }

    static public function get savePath():String {
        if (! _hasInicialized) {
            throwError();
        }
        return _savePath;
    }

    static public function get dataPath():String {
        if (! _hasInicialized) {
            throwError();
        }
        return _dataPath;
    }

    static public function get assetsPath():String {
        if (! _hasInicialized) {
            throwError();
        }
        return _assetsPath;
    }

    static public function get imgsPath():String {
        if (! _hasInicialized) {
            throwError();
        }
        return _imgsPath;
    }

    static public function get soundsPath():String {
        if (! _hasInicialized) {
            throwError();
        }
        return _soundsPath;
    }

    private static function throwError():void {
        throw new Error("Class not initialized. Use Paths.initialize(..args)");
    }
}
}
