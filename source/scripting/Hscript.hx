package scripting;

import hscript.Parser;
import hscript.Interp;

using StringTools;

class Hscript extends Interp
{
    override public function new(scriptThing:String){
        super();
        setVariables();

        var parser = new Parser();

        execute(parser.parseString(scriptThing));
    }

    //call Function in Interp
    public function callFunc(func:String, ?args:Array<Dynamic>):Dynamic {
		if (variables.exists(func)) {
			if (args == null){ args = []; }

			try {
				return Reflect.callMethod(null, variables.get(func), args);
			}
			catch(e){
				trace(e.message);
            }
		}
		return null;
	}

    //import some default classes
    private function setVariables(){
		variables.set('CoolUtil', CoolUtil);
		variables.set('Paths', Paths);
		variables.set('PlayState', PlayState);

        variables.set('add', flixel.FlxG.state.add);
		variables.set('insert', flixel.FlxG.state.insert);
		variables.set('remove', flixel.FlxG.state.remove);
    }
}