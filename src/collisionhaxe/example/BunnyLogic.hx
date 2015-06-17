package collisionhaxe.example;

import pixi.extras.TilingSprite;
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
    var bunny1 : Bunny;
    var bunny2 : Bunny;

    var grid = new SparseGrid<Actor>(200, 200);

    public function init(stage : Container) {
        bunny1 = new Bunny(100, 100, new Sprite(Texture.fromImage("../assets/bunny1.png")));
        bunny2 = new Bunny(800, 100, new Sprite(Texture.fromImage("../assets/bunny2.png")));

        var wallSprite = new TilingSprite(Texture.fromImage("../assets/wall.jpg"), 1000, 40);
        var wall1 = new Wall(400, 800, 1000, 40, wallSprite);

        stage.addChild(bunny1.sprite);
        stage.addChild(bunny2.sprite);
        stage.addChild(wall1.sprite);

        grid.insert(bunny1.boundingBox, bunny1);
        grid.insert(bunny2.boundingBox, bunny2);
        grid.insert(wall1.boundingBox, wall1);
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

        else if(event.keyCode == 65) bunny2.keys.left = pressed;
        else if(event.keyCode == 68) bunny2.keys.right = pressed;
        else if(event.keyCode == 87) {
            if(pressed && !bunny2.keys.up) bunny2.onJump();
            bunny2.keys.up = pressed;
        }

        else return;
        event.preventDefault();
   	}

}

private class Bunny extends Actor {
    var gravitationalForce = 1000;
    var startX : Float;
    var startY : Float;


    public var sprite : Sprite;

    public function new(x : Float, y : Float, sprite : Sprite) {
        super(new BoundingBox(x, y, 30, 30), 0, -30, true);
        this.sprite = sprite;
        sprite.anchor.set(0.5, 0.64);
        this.startX = x;
        this.startY = y;
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

    override function onCollisionBy(that : Actor, incomingVelocityX : Float, incomingVelocityY : Float) {
        if(that.boundingBox.y < boundingBox.y && velocityY + incomingVelocityY > 0) {
            that.velocityY = -200;
            boundingBox.x = startX;
            boundingBox.y = startY;
        }
    }
}

private class Wall extends Actor {
    public var sprite : Sprite;

    public function new(x : Float, y : Float, width : Float, height : Float, sprite : Sprite) {
        super(new BoundingBox(x, y, width, height), 0, 0, true);
        this.sprite = sprite;
        sprite.anchor.set(0.5, 0.5);
        sprite.position.set(boundingBox.x, boundingBox.y);
    }
}
