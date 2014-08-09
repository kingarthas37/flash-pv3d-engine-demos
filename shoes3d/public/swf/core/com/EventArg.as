package core.com {
	
	import flash.events.Event;
	
	public class EventArg {
		
		
		public function EventArg() {
			
			
			
			}
			
			
		public static function createEvent(f:Function,...args):Function {
			
			return function(e:Event):void { f.apply(null,args); }
			
			}
		
		}
	
	
	
	}