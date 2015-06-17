package collisionhaxe.example;

import pixi.core.textures.Texture;
import pixi.core.sprites.Sprite;
import pixi.core.display.Container;

class BunnyLogic {

    public function new() {}

    var bunnySprite1 : Sprite;
    var bunny1 = new Actor(new BoundingBox(100, 100, 40, 40), 1, 0);
    var grid = new SparseGrid<Actor>(200, 200);

    public function init(stage : Container) {
        bunnySprite1 = new Sprite(Texture.fromImage("../assets/bunny.png"));
        bunnySprite1.anchor.set(0.5, 0.5);
        stage.addChild(bunnySprite1);
        grid.insert(bunny1.boundingBox, bunny1);
    }

    public function update(elapsedTime : Float, stage : Container) {
        bunny1.move(grid, elapsedTime);
        bunnySprite1.position.set(bunny1.boundingBox.x, bunny1.boundingBox.y);
   	}

}
