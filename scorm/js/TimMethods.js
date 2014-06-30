/*
Conexão Tin Can
*/

//Clone do obj "data/engineConfig.txt" contendo as conigurações da aplicação
var engineConfig;

$(document).ready(function(){
	$.getJSON("data/engineConfig.txt",
	  function(data){			 
			engineConfig = data;
			//Iniciar aplicação após ler os arquivos de configuração 
			initTinCanApp();			
		 });
});

//Variáveis TinCan
var myTinCan;
var myLRS;
var myActor;
var myVerb;

/*
function Config() {
        "use strict";
}
Config.endpoint = "https://cloud.scorm.com/ScormEngineInterface/TCAPI/public/";
Config.authUser = "<account id>";
Config.authPassword = "<password>";
Config.actor = { "mbox":["mailto:tincanapicouk@example.com"], "name":["Tin Can"] };
*/

function initTinCanApp(){   
 	myTinCan = new TinCan();
	
	//Conectando a um LRS	
	if(engineConfig.hasLRS){
		myLRS = new TinCan.LRS({
			endpoint:"https://cloud.scorm.com/ScormEngineInterface/TCAPI/UJB2A4YL5K/", 
			version: "0.95",
			auth: ""
		});		
		myTinCan.recordStores[0] = myLRS;
	}else{
		myLRS = new TinCan.LRS({
			endpoint: Config.endpoint, 
			version: "0.95",
			auth: ""
		});		
		
		myTinCan.recordStores[0] = myLRS;		
	}
	
	/*endpoint:"https://cloud.scorm.com/ScormEngineInterface/TCAPI/public/", 
	version: "0.95",
	auth: 'Basic ' + Base64.encode("<account id>" + ':' + "<password>")*/
	
	myActor = new TinCan.Agent({
		name : "Luiz Felipe",
		mbox : "mailto:lfelipecoelho@gmail.com"
	});	
	myTinCan.actor = myActor;
	
	myVerb = new TinCan.Verb({
		id : "http://tincanapi.com/JsTetris_TCAPI",
		display : {
			"en-US":"read"		
		}
	});
	
	sendActivityDefinition('Aplicação Iniciada', 'Aplicação Iniciada');	
	
	
	//Adicionando uma nova interação
	addQuestionInteraction("Pergunta 1", "choice", ["opc1", "opc2", "opc3", "opc4"], "opc2", "opc2", "Q1", "grupo1");
	addQuestionInteraction("Pergunta 2", "choice", ["opc1", "opc2", "opc3", "opc4"], "opc2", "opc3", "Q2", "grupo1");
	addQuestionInteraction("Pergunta 3", "choice", ["opc1", "opc2", "opc3", "opc4"], "opc2", "opc3", "Q3", "grupo1");
	addQuestionInteraction("Pergunta 4", "choice", ["opc1", "opc2", "opc3", "opc4"], "opc2", "opc3", "Q4", "grupo1");
	SubmitAnswersToTinCan("grupo1");
	
	addQuestionInteraction("Pergunta gp2", "choice", ["opc1", "opc2", "opc3", "opc4"], "opc2", "opc2", "Q1", "grupo2");
	SubmitAnswersToTinCan("grupo2");
}


/*  
  lrsEndPoints:[]
  lrsVersions:[]
  lrsUserNames:[]
  lrsPassWords:[]
  actorName:
  actorMail:
*/

//################ Gravando Activitys ##############################
function sendActivityDefinition(name, description){
    var myActivityDefinition = new TinCan.ActivityDefinition({
		name : {
			"en-US":name			
		},
		description : {
			"en-US":description		
		}
	});
	
	var myActivity = new TinCan.Activity({
		id : "http://tincanapi.com/JsTetris_TCAPI",
		definition : myActivityDefinition
	});	
	
	var stmt = new TinCan.Statement({
		actor : myActor,
		verb :  myVerb,
		target : myActivity,
		
	},false);
	
	//Enviando o Statement
	myTinCan.sendStatement(stmt, function() {
		alert('SEND');
	});	
}

//################## Criando Interações ###########################
//Criando o objeto Questão
function Question(id, text, type, answers, correctAnswer, objectiveId){
	this.Id = id;
	this.Text = text;
	this.Type = type;
	this.Answers = answers;
	this.CorrectAnswer = correctAnswer;
	this.ObjectiveId = objectiveId;
}

//Criando o objeto para gravar um grupo de interações
var arrInteractionsObjects = [];

function InteractionObj(_id, _correctCount, _answerStatements){
	this.id = _id;
	this.correctCount = _correctCount;
	this.answerStatements = _answerStatements;	
}


/*
*enunciado
*qType ["choice", "true-false", "numeric"]
*alternativas [array contendo as alternativas]
*ObjectiveId 
*/

 /**
	@method addQuestionInteraction
	@param {String} enunciado Enunciado da questão
	//@param {Object} [cfg] Configuration for request		
	//String, String, Array, String, String, String, String
	*/
function addQuestionInteraction(enunciado, qType, alternativas, gabarito, resposta, objectiveId, grupo){
	var question = new Question (
		engineConfig.id,
		enunciado,
		qType,
		alternativas,
		gabarito,
		objectiveId
	)		
	
	//Gravando resposta	
	if(indexOfId(grupo) == -1){
		var itGp = new InteractionObj(
		    grupo, 
			0, 
			[]
		);
		
		arrInteractionsObjects.push(itGp);
	}
	
	SubmitAnswer(question, resposta, grupo);
}

   
function SubmitAnswer(question, learnerResponse, grupo){	
	var wasCorrect = false;
	var correctAnswer = question.CorrectAnswer;
	var interactionObjAtual = arrInteractionsObjects[indexOfId(grupo)];
	
	switch (question.Type){
		case "choice":
		   wasCorrect = (correctAnswer == learnerResponse);
		break;			
	}
	
	if (wasCorrect) {
		interactionObjAtual.correctCount++;
	}
	
	//Adiciona elemento ao array para enviar os status no final de todas as interações.
	interactionObjAtual.answerStatements.unshift(
		GetQuestionAnswerStatement(
			question.Id,
			question.Text,
			question.Answers,
			question.Type,
			learnerResponse,
			correctAnswer,
			wasCorrect,
			'http://activitystrea.ms/specs/json/schema/activity-schema.html#read'
		)				
	);	
}



function SubmitAnswersToTinCan(grupo){	
	var interactionObjAtual = arrInteractionsObjects[indexOfId(grupo)];
	var totalQuestions = interactionObjAtual.answerStatements.length;	
	
	//enviando o score do grupo
	var score = Math.round(interactionObjAtual.correctCount * 100 / totalQuestions);	
	interactionObjAtual.answerStatements.push(GetRecordTestStatement(score, "http://tincanapi.com/JsTetris_TCAPI"));
	
	myTinCan.sendStatements(interactionObjAtual.answerStatements, function() {
		alert('Interações ' + grupo + ' enviadas.');
	});
}



 //passes in score as a percentage
function GetRecordTestStatement(score, activityId){
	// send score	
	var scaledScore = score / 100,
		success = (scaledScore >= 0.8);

	var stmt = {
		verb: "http://adlnet.gov/expapi/verbs/completed",
		object: {
			id: activityId
		},
		result: {
			score: {
				scaled: scaledScore,
				raw: score,
				min: 0,
				max: 100
			},
			success: success
		},
		context: engineConfig.contextual
	};

	return stmt;
}


function indexOfId(searchGp){
  	var bl = -1;	
	for(var i = 0; i < arrInteractionsObjects.length; i++){
	    if(arrInteractionsObjects[i].id == searchGp){
			 bl = i;
		}
	}	
	return bl;
}


function GetQuestionAnswerStatement(id, questionText, questionChoices, questionType, learnerResponse, correctAnswer, wasCorrect, activityId){
	if (typeof console !== 'undefined') {
		console.log("GetQuestionAnswerStatement");
	}

	//send question info
	var qObj = {
		id: id,
		definition: {
			type: "http://adlnet.gov/expapi/activities/cmi.interaction",
			description: {
				"en-US": questionText
			},
			interactionType: questionType,
			correctResponsesPattern: [
				String(correctAnswer)
			]
		}
	};

	if(questionChoices !== null && questionChoices.length > 0){
		var choices = [];
		for(var i = 0; i < questionChoices.length; i++){
			var choice = questionChoices[i];
			choices.push(
				{
					id: choice,
					description: {
						"en-US": choice
					}
				}
			);
		}
		if (typeof console !== 'undefined') {
			console.log(qObj);
		}
		qObj.definition.choices = choices;
	}

	return {
		verb: "http://adlnet.gov/expapi/verbs/answered",
		object: qObj,
		result: {
			response: learnerResponse,
			success: wasCorrect
		},
		context: engineConfig.contextual
	}
}

function FormatChoiceResponse(value){
	var newValue = new String(value);
	//replace all whitespace
	newValue = newValue.replace(/\W/g, "_");

	return newValue;
}



//********************* Book Mark *****************************
function setCurrentPage(currentPage){	
	myTinCan.setState("location", currentPage, function () {});
}

function getCurrentPage(){
    var stateResult = myTinCan.getState("location");
   
    if (stateResult.err === null && stateResult.state !== null && stateResult.state.contents !== "") {
		currentPage = parseInt(stateResult.state.contents, 10);		
	}else {
		currentPage = 0;
	}
	
	return currentPage;
}


//******************** xxxxx ****************************** 




