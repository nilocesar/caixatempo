//You can specify the SCORM version manually if needed
pipwerks.SCORM.version = "1.2";

//This function will be invoked by the SWF via ExternalInterface
function closeCourseWindow(){
	top.close();			    
}

//Ensure we handle window closing properly
var unloaded = false;
function unloadHandler(){
   if(!unloaded){
	  pipwerks.SCORM.save(); //save all data that has already been sent
	  pipwerks.SCORM.quit(); //close the SCORM API connection properly
	  unloaded = true;
   }
}

window.onbeforeunload = unloadHandler;
window.onunload = unloadHandler;