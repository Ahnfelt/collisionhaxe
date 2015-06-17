package collisionhaxe.example;

import pixi.interaction.EventTarget;
import pixi.core.graphics.Graphics;
import pixi.plugins.app.Application;
import js.Browser;

class PixiTest extends Application {

    var graphics:Graphics;
   	var thing:Graphics;
   	var count:Float;

   	public function new() {
   		super();
   		_init();
   	}

   	function _init() {
   		backgroundColor = 0x003366;
   		antialias = true;
   		onUpdate = _onUpdate;
   		super.start(Application.CANVAS);

   		graphics = new Graphics();
   		graphics.beginFill(0xFF3300);
   		graphics.lineStyle(10, 0xffd900, 1);

   		graphics.moveTo(50, 50);
   		graphics.lineTo(250, 50);
   		graphics.lineTo(100, 100);
   		graphics.lineTo(250, 220);
   		graphics.lineTo(50, 220);
   		graphics.lineTo(50, 50);
   		graphics.endFill();

   		graphics.lineStyle(10, 0xFF0000, 0.8);
   		graphics.beginFill(0xFF700B, 1);

   		graphics.moveTo(210, 300);
   		graphics.lineTo(450, 320);
   		graphics.lineTo(570, 350);
   		graphics.lineTo(580, 20);
   		graphics.lineTo(330, 120);
   		graphics.lineTo(410, 200);
   		graphics.lineTo(210, 300);
   		graphics.endFill();

   		graphics.lineStyle(2, 0x0000FF, 1);
   		graphics.drawRect(50, 250, 100, 100);

   		graphics.lineStyle(0);
   		graphics.beginFill(0xFFFF0B, 0.5);
   		graphics.drawCircle(470, 200, 100);

   		graphics.lineStyle(20, 0x33FF00);
   		graphics.moveTo(30, 30);
   		graphics.lineTo(600, 300);

   		_stage.addChild(graphics);

   		thing = new Graphics();
   		_stage.addChild(thing);
   		thing.position.x = Browser.window.innerWidth / 2;
   		thing.position.y = Browser.window.innerHeight / 2;

   		count = 0;

   		_stage.interactive = true;
   		_stage.on("click", _onStageClick);
   		_stage.on("tap", _onStageClick);
   	}

   	function _onUpdate(elapsedTime:Float) {
   		count += 0.1;

   		thing.clear();
   		thing.lineStyle(30, 0xFF0000, 1);
   		thing.beginFill(0xFF0000, 0.5);

   		thing.moveTo(-120 + Math.sin(count) * 20, -100 + Math.cos(count) * 20);
   		thing.lineTo(120 + Math.cos(count) * 20, -100 + Math.sin(count) * 20);
   		thing.lineTo(120 + Math.sin(count) * 20, 100 + Math.cos(count) * 20);
   		thing.lineTo(-120 + Math.cos(count) * 20, 100 + Math.sin(count) * 20);
   		thing.lineTo(-120 + Math.sin(count) * 20, -100 + Math.cos(count) * 20);

   		thing.rotation = count * 0.1;
   	}

   	function _onStageClick(target:EventTarget) {
   		graphics.lineStyle(Math.random() * 30, Std.int(Math.random() * 0xFFFFFF), 1);
   		graphics.moveTo(Math.random() * 620, Math.random() * 380);
   		graphics.lineTo(Math.random() * 620, Math.random() * 380);
   	}

   	static function main() {
   		new PixiTest();
   	}

}
