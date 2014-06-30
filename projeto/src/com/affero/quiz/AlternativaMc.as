package com.affero.quiz 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author luiz.coelho
	 */
	public class AlternativaMc extends MovieClip
	{
		
		public var txt:TextField;
		public var checkBt:MovieClip;
		public var id:String = "";
		
		public function AlternativaMc() 
		{
			txt.autoSize = TextFieldAutoSize.LEFT;		
		}
		
	}

}