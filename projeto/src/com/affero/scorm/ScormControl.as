package com.affero.scorm 
{
	import com.adobe.serialization.json.JSON;
	import com.affero.base.utils.json.Converter;
	import com.affero.model.application.ConfigVO;
	import com.pipwerks.SCORM;
	/**
	 * ...
	 * @author luiz.coelho
	 */
	public class ScormControl
	{
		
		//Variáveis globais scorm
		public var scorm:SCORM;
		public var lmsConnected:Boolean;
		public var lessonStatus:String;
		public var success:Boolean;
		
		
		public var jsonConfigStr:String = "";
		public var jsonConfigObj:ConfigVO;
		public var countInteractions:int;
		
		
		//Se conecta ao LMS e verifica o status do treinamento 
		public function ScormControl(configRef:ConfigVO) {
			//Initialize SCORM object (pipwerks SCORM class)
			jsonConfigObj = configRef;
			scorm = new SCORM();
             
			//Connect to LMS. Can only be done ONCE.
			lmsConnected = scorm.connect();

			//Ensure connection was successful before continuing.
			if(lmsConnected){

				//Get course status
				lessonStatus = scorm.get("cmi.core.lesson_status");

				//If course has already been completed, kill connection
				//to LMS because there's nothing to report.
				if(lessonStatus == "completed" || lessonStatus == "passed"){
					scorm.disconnect();
				} else {

					//If course has NOT been completed yet, let's
					//ensure the LMS knows the course is incomplete
					//by explicitly setting status to "incomplete"
					success = scorm.set("cmi.core.lesson_status", "incomplete");

					//Perform a save whenever sending vital data to LMS
					//but be careful not to do it too often or risk bogging down the LMS
					scorm.save();
				}
				
				
				//Resgata o config
				resgataSave();				
				//nilo//countInteractions = jsonConfig.interactionCount;

			} else {
				trace("Could not connect to LMS.");
			}
		}
		
		
		public function resgataSave():void
		{
			if(lmsConnected){
				jsonConfigStr = scorm.get("cmi.suspend_data");
				
				//telas = arrayTelas;
				if (jsonConfigStr.length <= 0) {
					//caso o suspend_data esteja vazio
					saveCourseStatus();	
					
				}else {
					//Caso o suspend_data tenha conteúdo.
					jsonConfigObj = Converter.createObject(JSON.decode(jsonConfigStr));
				}
			}
		}		
		
		//Resgata o json do config.
		public function get jsonConfig():ConfigVO {
			return jsonConfigObj;
		}
		
		
		//Salva o json no LMS
		public function saveCourseStatus():void {
			
			if(lmsConnected){
				//Transformando o json em string para ser gravado no sudpend_data
				var suspend_str:String = JSON.encode(this.jsonConfigObj);

				//Enviando o suspend_data para o LMS
				//scorm.set("cmi.core.total_time", "0012:12:16");
				scorm.set("cmi.suspend_data", suspend_str);

				//Salvando as alterações
				scorm.save();
			}
		}
		
		public function setCourseToComplete():void {
			
			trace("complete"); 
			
    		if(lmsConnected){
				//Set lesson status to completed
				success = scorm.set("cmi.core.lesson_status", "completed");
				//Ensure the LMS persists (saves) what was just sent
				scorm.save();
				//Disconnect from LMS
				//scorm.disconnect();
			}
		}
		
		//Lesson Location
		public function set lessonLocation(locationId:String):void{
			if(lmsConnected){
				scorm.set("cmi.core.lesson_location", locationId);
				scorm.save();
			}
		}
		
		public function get lessonLocation():String{
			return scorm.get("cmi.core.lesson_location");			
		}
		
		//Lesson Status
		public function set setLessonStatus(statusId:String):void{
			if(lmsConnected){
				scorm.set("cmi.core.lesson_status", statusId);
				scorm.save();
			}
		}
		
		public function get getLessonStatus():String{
			return scorm.get("cmi.core.lesson_status");
		}
		
		
		//Raw
		public function set raw(pontuation:Number):void{
			scorm.set("cmi.core.score.raw", String(pontuation));
			scorm.save();
		}
		
		public function get raw():Number{
			return Number(scorm.get("cmi.core.score.raw"));
		}
		
		//Student ID
		public function set studentId(stdId:String):void{
			scorm.set("cmi.core.student_id", stdId);
			scorm.save();
		}
		
		public function get studentId():String{
			return scorm.get("cmi.core.student_id");
		}
		
		//Student Name
		public function set studentName(stdName:String):void{
			scorm.set("cmi.core.student_name", stdName);
			scorm.save();
		}
		
		public function get studentName():String{
			return scorm.get("cmi.core.student_name");
		}
		
		//Max Score
		public function set maxScore(pontuation:Number):void{
			scorm.set("cmi.core.score.max", String(pontuation));
			scorm.save();
		}
		
		public function get maxScore():Number{
			return Number(scorm.get("cmi.core.score.max"));
		}
		
		//Min Score
		public function set minScore(pontuation:Number):void{
			scorm.set("cmi.core.score.min", String(pontuation));
			scorm.save();
		}
		
		public function get minScore():Number{
			return Number(scorm.get("cmi.core.score.min"));
		}
		
		//Mastery Score
		public function get masteryScore():Number{
			return Number(scorm.get("cmi.student_data.mastery_score"));
		}
		
		//Metodos de Interactions
		/*				
		cmi.interactions.0.id: myid
		cmi.interactions.0.type: Undefined
		cmi.interactions.0.timestamp:
		cmi.interactions.0.weighting:
		cmi.interactions.0.learner_response:
		cmi.interactions.0.result:
		cmi.interactions.0.latency:
		cmi.interactions.0.description:					
		*/
		 
		public function addInteraction(interactionID:String, interactionType:String):int {
			var countInt:int = countInteractions++;
			//nilo//this.jsonConfigObj.interactionCount = countInt;
			saveCourseStatus();
			
			if (lmsConnected) {
				scorm.set("cmi.interactions." + countInt + ".id", interactionID);				
				scorm.set("cmi.interactions." + countInt + ".type", interactionType);
				scorm.save();				
			}
			
			return countInt;
		}
		
		
		public function salvaResposta(userResp:String, gabarito:String, idCount:String):void {
			if(lmsConnected){
				scorm.set("cmi.interactions." + idCount + ".student_response", userResp);
				scorm.set("cmi.interactions." + idCount + ".correct_responses.0.pattern", gabarito);
				scorm.save();				
			}
		}
		
		
		public function interactionIsCorrect(idCount:String):void {
			if(lmsConnected){
				scorm.set("cmi.interactions." + idCount + ".result", "correct");
				scorm.save();
			}
		}
		
		public function interactionIsWrong(idCount:String):void {
			if(lmsConnected){
				scorm.set("cmi.interactions." + idCount + ".result", "wrong");
				scorm.save();
			}
		}
	}

}