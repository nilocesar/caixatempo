package com.affero.model.application 
{
	/**
	 * ...
	 * @author luiz.coelho
	 */
	
	  
	public class ConfigEngineVO extends AppObject
	{
		public var scorm:Boolean;
		public var comments:Boolean;
		public var autoComplete:Boolean;
		
		public var maxScore:Number = 0;
		public var minScore:Number = 0;	
		
		public var controles:Boolean;
		public var moldura:Boolean;
		public var contextual:String;
		
		public var hasLRS:Boolean = false;
	}

}