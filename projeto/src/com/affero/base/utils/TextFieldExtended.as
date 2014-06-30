package com.affero.base.utils
{
	
	import com.view.componentes.InfoIco;
	import flash.display.MovieClip;
	import flash.display.Sprite;
    import flash.events.Event;
	import flash.geom.Rectangle;
    import flash.text.TextField;
	import com.affero.base.utils.json.Converter;
	import com.greensock.TweenMax;

    public class TextFieldExtended extends MovieClip
    {
        /**
		 * ...
		 * @author luiz.coelho
		 */
		
		private static var countHw:int;
		private static var _objectHW:Object;
		public static var _arrayWords:Array;
		private static var ignoreArray:Array = ["!", "?", ".", ","];
		public static var arrLoaded:Array = [];
		
		public function TextFieldExtended()
        {
           // 
        }
		
		
		public static function setHotWords(objHW:Object):void {
			_objectHW = objHW;
			_arrayWords = new Array();
			
			for (var i:String in objHW) {			
			  _arrayWords.push(i);
		    }			
		}
		
        public static function renderHotWord(textIn:TextField):void
        {            
			
			var hw:String = "";
			var hwTemp:String = "";
			
			for (var i:int; i < _arrayWords.length; i++)
			 {					
					 arrLoaded.push(_arrayWords[i]);					
					 var replaceText:String = strReplace(textIn.htmlText, _arrayWords[i], "<i><font color='#4CA13E'>         " + _arrayWords[i] + "</font></i>");
					 
					 if (replaceText != textIn.htmlText) {						 
						 hwTemp = String(_arrayWords[i]);
						 hw = String(_arrayWords[i]);
						 textIn.htmlText = replaceText;
						 TweenMax.delayedCall(0.1, criaIcone, [textIn, hw, hwTemp]);
					 }
				 
				}
				 	
		}					
        
		
		
		public static function strReplace(str:String, search:String, replace:String):String {	 
		 return  str.replace(search, replace);	 
		}
		
		
		
		private static function criaIcone(textIn:TextField, hw:String, hwTemp:String):void {
			    var r:Rectangle = textIn.getCharBoundaries(textIn.text.search(hwTemp));
				var newText:String = textIn.htmlText.replace(hwTemp, hw);
				textIn.htmlText = newText;
				var infoIco:InfoIco = new InfoIco();
				
				if (r != null) {
					infoIco.x = r.x - infoIco.width + textIn.x;
					infoIco.y = r.y + textIn.y;
				}
				
				var hotInfo:String = compareString(hw, ignoreArray);				
				
				infoIco.setMethods('open', { } );
				infoIco.setMethods('over', {infoBox:_objectHW[hotInfo], acao:onAbaOver} );
				infoIco.setMethods('out', {});
				infoIco.effectLabel('open');
				
				textIn.parent.addChild(infoIco);				
				
		}
		
		
		public static function compareString(str:String, subsArr:Array):String {
			var srtReturn:String = str;
			var verifica:String = str.substr(str.length-1, str.length-1);
			
			for (var k:int; k < subsArr.length; k++)
			{					
				
				if (verifica == subsArr[k]) {
					srtReturn = str.substr(0, str.length - 1);					
				}		
				
			}
			
			return srtReturn;
		}
		
		
		private static function onAbaOver(obj:BaseButton):void {
			obj.parent.setChildIndex(obj, obj.parent.numChildren - 1);		
		}
		
		
    }

}

