package collisionhaxe.example;

import pixi.core.graphics.Graphics;
import pixi.core.display.Container;

class BunnyLogic {

    public function new() {}

    var bunny : Graphics;

    public function init(stage : Container) {
        bunny = new Graphics();
        stage.addChild(bunny);
    }

    public function update(elapsedTime : Float, stage : Container) {
        bunny.clear();
        bunny.lineStyle(30, 0xFF0000, 1);
        bunny.beginFill(0xFF0000, 0.5);

        bunny.moveTo(-120 + Math.sin(elapsedTime) * 20, -100 + Math.cos(elapsedTime) * 20);
        bunny.lineTo(120 + Math.cos(elapsedTime) * 20, -100 + Math.sin(elapsedTime) * 20);
        bunny.lineTo(120 + Math.sin(elapsedTime) * 20, 100 + Math.cos(elapsedTime) * 20);
        bunny.lineTo(-120 + Math.cos(elapsedTime) * 20, 100 + Math.sin(elapsedTime) * 20);
        bunny.lineTo(-120 + Math.sin(elapsedTime) * 20, -100 + Math.cos(elapsedTime) * 20);

        bunny.rotation = elapsedTime * 0.1;
   	}

}
