package com.affero.quiz.model 
{
	import com.affero.model.application.AppObject;
	/**
	 * ...
	 * @author luiz.coelho
	 */
	public class CaseVO extends AppObject
	{
		public var caseId:String = "";
		public var arrQuiz:Array = [];//Array de objetos QuizVO		
		public var pctCorte:uint;
	}

}