package collisionhaxe.example;

import js.Browser;
import js.Lib;
import js.html.Console;
import js.html.Event;
import pixi.core.particles.ParticleContainer;
import pixi.core.textures.Texture;
import pixi.core.sprites.Sprite;
import pixi.core.display.Container;

class BunnyLogic {

    public function new() {}

    var bunnySprite1 : Sprite;
    var bunny1 = new Bunny(100, 100, new Sprite(Texture.fromImage("../assets/bunny.png")));
    var bunny2 = new Bunny(800, 100, new Sprite(Texture.fromImage("../assets/bunny2.png")));

    var platform1 = new Actor(new BoundingBox(400, 800, 1000, 40), 0, 0, true);
    var grid = new SparseGrid<Actor>(200, 200);

    public function init(stage : Container) {

        var container = new ParticleContainer();
        stage.addChild(container);
        container.addChild(bunny1.sprite);
        container.addChild(bunny2.sprite);

        grid.insert(bunny1.boundingBox, bunny1);
        grid.insert(bunny2.boundingBox, bunny2);
        grid.insert(platform1.boundingBox, platform1);
    }

    public function update(deltaTime : Float, stage : Container) {
        bunny1.update(grid, deltaTime);
        bunny2.update(grid, deltaTime);
   	}

   	public function onKey(pressed : Bool, event : Dynamic) {
   	    Browser.console.dir(event);
        if(event.keyCode == 37) bunny1.keys.left = pressed;
        else if(event.keyCode == 39) bunny1.keys.right = pressed;
        else if(event.keyCode == 38) {
            if(pressed && !bunny1.keys.up) bunny1.onJump();
            bunny1.keys.up = pressed;
        }
        else return;
        event.preventDefault();
   	}

}


private class Bunny extends Actor {
    var gravitationalForce = 800;

    public var sprite : Sprite;

    public function new(x : Float, y : Float, sprite : Sprite) {
        super(new BoundingBox(x, y, 40, 40), 0, -30);
        this.sprite = sprite;
        sprite.anchor.set(0.5, 0.5);
    }

    public var keys = {
        left: false,
        right: false,
        up: false
    };

    public function update(grid : SparseGrid<Actor>, deltaTime : Float) {
        if(keys.left) velocityX = -200;
        else if(keys.right) velocityX = 200;
        else velocityX *= 0.90;
        if(Math.abs(velocityX) < 5) velocityX = 0;
        velocityY += gravitationalForce * deltaTime;
        move(grid, deltaTime);

        sprite.position.set(boundingBox.x, boundingBox.y);
    }

    public function onJump() {
        velocityY = -300;
    }
}
