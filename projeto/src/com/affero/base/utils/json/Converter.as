package com.affero.base.utils.json
{
	import com.affero.base.utils.Tooltip;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	import com.maccherone.json.JSON;
	
	import mx.utils.ObjectUtil;

	public class Converter
	{
		
		private static var jsonDataTextOut:Object;
		
		/**
		 *O metodo contendo todos os objetos de referencia da aplicação(VO) deve ser chamado antes de qualquer metodo da classe, para que a aplicação crie uma instancia de cada objeto automaticamente e set o json contendo o codigo dos textos da aplicação.
		 */
		public static function setJsonReferences(arrVO:Array, jsonDataText:Object):void {
			jsonDataTextOut = jsonDataText;			
			for each (var objectClass:* in arrVO) {				
				new objectClass();
			}
		}
		
		/**
		 *Importa para o flash os objetos contidos no json.
		 */		 
		public static function createObject(obj:Object):* {            
			var classRef:Class = getDefinitionByName(obj._classReference) as Class;
			var ref:* = new classRef();
			
                for (var name:String in obj){                        
					    try {							
							if (getQualifiedClassName(obj[name]) != "Object" && getQualifiedClassName(obj[name]) != "Array") {
							  ref[name] = obj[name];
							}else if(getQualifiedClassName(obj[name]) == "Object"){
							  ref[name] = createObject(obj[name]);
							}else if(getQualifiedClassName(obj[name]) == "Array"){
							    for each (var objectClass:* in obj[name] as Array) {									
									if (getQualifiedClassName(objectClass) == "Object") {
									  	(ref[name] as Array).push(createObject(objectClass));
									}else {
										(ref[name] as Array).push(objectClass);
									}																	
								}						
							}
                        }
                        catch (e:Error) {
							Main.instance.debug('Converter ERROR*:',obj[name] + " Propiedade não encontrada " + name + " em " + ref + " .");
                            //throw new Error(obj[name] + " Propiedade não encontrada " + name + " em " + ref + " .");						
                        }						
				}				
			return ref;		
        }
		
		
		/**
		 *Altera o valor da propriedade de um objeto já instanciado.
		 */	
		public static function changeObjectProperty(obj:Object, dbRef:String, property:String, changeTo:* , pushArray:Boolean = true):void {
			var varList:XML = flash.utils.describeType(obj);			
            var node:XML;
			
			for each (node in varList.elements("variable"))
			{
				if (node.@type != "String") {
				  changeObjectProperty(obj[node.@name], dbRef, property, changeTo);
				  
				  if (node.@type == "Array" && node.@name == property) {
					// Main.instance.debug("Array: ", node.@name);
					if (pushArray) {
						obj[node.@name].push(changeTo);
					}else if (!pushArray) {
					    obj[node.@name] = changeTo;
					}
					
				  }
				  
				}else {				
					
				  if(obj["_classReference"]  == dbRef && node.@name != '_classReference' && node.@name == property){ 
				     obj[node.@name] = changeTo;	
					 break;
				  }				  
				}				
			}						
		}	
		
		
				  
				  
		
		/**
		 *Resgata o valor da propriedade.
		 */	
		public static function getObjectProperty(obj:Object, dbRef:String, property:String):* {
			var varList:XML = flash.utils.describeType(obj);			
            var node:XML;
			
			for each (node in varList.elements("variable"))
			{
				if (node.@type != "String") {
				 
				  if (node.@type == "Array" && node.@name == property) {
					return obj[node.@name];
				  }
					
				  if (getObjectProperty(obj[node.@name], dbRef, property) != "" && getObjectProperty(obj[node.@name], dbRef, property) != null) {
					 return getObjectProperty(obj[node.@name], dbRef, property);
				  }				  
				  
				}else {						
				  if(obj["_classReference"]  == dbRef && node.@name != '_classReference' && node.@name == property){ 
				   	return obj[node.@name];					
				  }				  
				}				
			}					
		}
		
		
		
		 
		 
		
		/**
		 *Retorna os textos do json pelo código.
		 */	
		public static function callHTMLText(codeText:String):String {		 
			var text:String;			
			if (jsonDataTextOut[codeText] == undefined || jsonDataTextOut[codeText] == null) {
				text = "[CONTEÚDO NÃO LOCALIZADO]";
			}else {
				text = jsonDataTextOut[codeText];
			}
			
			return text;		  
		}
		
	}
}