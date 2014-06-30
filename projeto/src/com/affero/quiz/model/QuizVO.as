package com.affero.quiz.model 
{
	import com.affero.model.application.AppObject;
	/**
	 * ...
	 * @author luiz.coelho
	 */
	public class QuizVO extends AppObject 
	{		
	   public var quizId:String;
	   public var indAtual:int;
	   public var enunciado:String;
	   public var feedPositivo:String;
	   public var feedNegativo:String;
	   public var arrGabarito:Array = [];
	   public var arrAlternativas:Array = []; //Array de OBJ AlternativaVO   
	   public var contadorInteraction:String;
	}

}