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
   		onUpdate = function(dt) {logic.update(dt, _stage);};
   		super.start(Application.CANVAS);
        logic.init(_stage);
   	}


   	static function main() {
   		new BunnyGame();
   	}

}
