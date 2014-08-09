package codes.extend{

	import flash.events.MouseEvent;
	import flash.events.Event;

	public class EventArg {


		public function EventArg() {


		}
		public static function createMouseEvent(f:Function,...args):Function {

			return function(e:MouseEvent):void { f.apply(null,args); };
		}

	}
}