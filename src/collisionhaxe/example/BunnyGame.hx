package collisionhaxe.example;

import pixi.interaction.EventTarget;
import pixi.core.graphics.Graphics;
import pixi.plugins.app.Application;
import js.Browser;

class BunnyGame extends Application {

    private var logic = new BunnyLogic();

   	public function new() {
   		super();
   		_init();
   	}

   	function _init() {
   		backgroundColor = 0x003366;
   		antialias = true;
   		onUpdate = function(dt) {logic.update(dt / 1000, _stage);};
   		super.start();
        logic.init(_stage);

        Browser.document.onkeydown = function(event) { logic.onKey(true, event); }
        Browser.document.onkeyup = function(event) { logic.onKey(false, event); }
   	}


   	static function main() {
   		new BunnyGame();
   	}

}
