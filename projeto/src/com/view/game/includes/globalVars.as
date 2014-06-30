package com.view.game.includes
{
	import flash.display.DisplayObject;
	import flash.external.ExternalInterface;
	
	
	public class globalVars
	{
		//=============================================================
		// VARIABLES
		//=============================================================
		
		// URL
		public var urlActual:String;
		private var url:String;
		private var urlLocal:String = "";
		private var urlWeb:String = "";

		// CONTAINER
		private var container:Array = new Array();
		
		//
		private function setVariables()
		{
			// ITENS
			container[ "lengthQuestoes" ] = 4;// valor pego com mais eficiência via Xml, apesar de da pau nas animaçoes 
			container[ "path_xml" ] = "../xmlConteudo/conteudo.xml";
			container[ "path_xml_projeto" ] = "xmlConteudo/conteudo.xml";

		}

		//=============================================================
		// PUBLIC FUNCTIONS
		//=============================================================
		
		//--------------------------------------
		// PUBLIC GET VALUES
		//--------------------------------------
		
		public function get( valor )
		{
			return container[ valor ];
		}
		
		//--------------------------------------
		// PUBLIC DEBUG MESSAGE
		//--------------------------------------
		
		public function debug( text ):void
		{
			if( ExternalInterface.available )
			{
				ExternalInterface.call("alert", text);
				
				trace("DEBUG: " + text);
			}
		}
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		public function globalVars()
		{
			// Get URL
			getUrl();
			
			// Values
			setVariables();
		}

		//=============================================================
		// PRIVATE FUNCTIONS
		//=============================================================
		
		//--------------------------------------
		// GET URL
		//--------------------------------------
		
		private function getUrl()
		{
			if( ExternalInterface.available )
			{
				urlActual = ExternalInterface.call("window.location.href.toString");
			
				urlActual == null ? url = urlLocal : url = urlWeb;
			}
			else
			{
				url = urlWeb;
			}
		}
	}
}