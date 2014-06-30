package com.affero.scorm 
{
	import flash.external.ExternalInterface;
	/**
	 * ...
	 * @author luiz.coelho
	 */
	public class TinCanControl 
	{
		public function TinCanControl() 
		{
			
		}
		
		public function sendActivityDefinition(activityName:String, activityDesc:String):void {
			if (ExternalInterface.available){
				ExternalInterface.call("sendActivityDefinition", activityName, activityDesc);
			}
		}
		
		public function addQuestionInteraction(enunciado:String, qType:String, alternativas:Array, gabarito:String, resposta:String, objectiveId:String, grupo:String):void {
		  	if (ExternalInterface.available){
			   ExternalInterface.call("addQuestionInteraction", enunciado, qType, alternativas, gabarito, resposta, objectiveId, grupo);
		    }
		}
		
		public function SubmitAnswersToTinCan(grupoId:String):void {
			if (ExternalInterface.available) {
				ExternalInterface.call("SubmitAnswersToTinCan", grupoId);
			}
		}
		
		
		//BOOK MARKS
		public function set currentPage(currentPage:String) {
			if (ExternalInterface.available) {
				ExternalInterface.call("setCurrentPage", currentPage);
			}
		}
		
		
		public function get currentPage():String {
			var pageAtual:* = "0";
			
			if (ExternalInterface.available) {
				pageAtual = ExternalInterface.call("getCurrentPage");
			}			
			return pageAtual;
		}
		
		
	}

}