package com.affero.base.utils.cronometro.events 
{
	import flash.events.Event;
	
	
	/**
	 * ...
	 * @author LF Coelho
	 */
	public class PercentEvent extends Event
	{
		
		public static const TYPE:String = "com.aennova.base.utils.cronometro.events.PercentEvent";
		public var percent : int;
		
		
		
		public function PercentEvent(inPct : int) 
		{			
			super(PercentEvent.TYPE, false, false)
			this.percent = inPct;
			
		}
		
	}

}