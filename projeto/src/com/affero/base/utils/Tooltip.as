
package com.affero.base.utils {
	import flash.display.DisplayObject;

	public interface Tooltip {

		function display(target:DisplayObject, text:String):void;
		function hide():void;

	}

}
