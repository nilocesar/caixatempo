package com.affero.base.utils.listenerParans 
{
	public class ListenerParans{
		public static function create(handler:Function,...args):Function{
			return function(...innerArgs):void{
				handler.apply(this,innerArgs.concat(args));
			}
		}
	}

}