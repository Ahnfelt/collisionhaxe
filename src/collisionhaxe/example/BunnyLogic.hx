package collisionhaxe.example;

import collisionhaxe.Actor;
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

    static public var gravitationalForce = 1000;


    public function new() {}

    var bunnySprite1 : Sprite;
    var bunny1 : Bunny;
    var bunny2 : Bunny;

    var grid = new SparseGrid<Actor>(200, 200);

    public function init(stage : Container) {
        bunny1 = new Bunny(800, 100, new Sprite(Texture.fromImage("../assets/bunny1.png")));
        bunny2 = new Bunny(200, 100, new Sprite(Texture.fromImage("../assets/bunny2.png")));

        var walls = [
			new Wall(600, 700, 1000, 40),
			new Wall(900, 500, 200, 40),
			new Wall(80, 600, 40, 240)
		];

        stage.addChild(bunny1.sprite);
        stage.addChild(bunny2.sprite);
        stage.addChild(bunny1.partContainer1);
        stage.addChild(bunny2.partContainer1);
        stage.addChild(bunny1.partContainer2);
        stage.addChild(bunny2.partContainer2);
        stage.addChild(bunny1.partContainer3);
        stage.addChild(bunny2.partContainer3);
        for(wall in walls) stage.addChild(wall.sprite);

        grid.insert(bunny1.boundingBox, bunny1);
        grid.insert(bunny2.boundingBox, bunny2);
        for(wall in walls) grid.insert(wall.boundingBox, wall);
    }

    public function update(deltaTime : Float, stage : Container) {
        bunny1.update(grid, deltaTime);
        bunny2.update(grid, deltaTime);
   	}

   	public function onKey(pressed : Bool, event : Dynamic) {
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

    var startX : Float;
    var startY : Float;

    var maxJumps = 2;
    var jumpsLeft : Int;

    public var sprite : Sprite;

    public var partContainer1 = new ParticleContainer(1000, untyped {scale: true, position: true, rotation: true, uvs: true, alpha: true});
    public var partContainer2 = new ParticleContainer(1000, untyped {scale: true, position: true, rotation: true, uvs: true, alpha: true});
    public var partContainer3 = new ParticleContainer(1000, untyped {scale: true, position: true, rotation: true, uvs: true, alpha: true});
    public var parts : Array<BunnyPart> = [];

    public function new(x : Float, y : Float, sprite : Sprite) {
        super(new BoundingBox(x, y, 30, 30), 0, -30, true);
        this.sprite = sprite;
        sprite.anchor.set(0.5, 0.64);
        this.startX = x;
        this.startY = y;
        jumpsLeft = maxJumps;
    }

    public var keys = {
        left: false,
        right: false,
        up: false
    };

    public function update(grid : SparseGrid<Actor>, deltaTime : Float) {
        if(keys.left) { sprite.scale.x = -1;  velocityX = -200; }
        else if(keys.right) { sprite.scale.x = 1;  velocityX = 200; }
        else velocityX *= 0.90;
        if(Math.abs(velocityX) < 5) velocityX = 0;
        velocityY += BunnyLogic.gravitationalForce * deltaTime;
        move(grid, deltaTime);

        sprite.position.set(boundingBox.x, boundingBox.y);

        for(part in parts) {
            if(part.timeToLive < 0) {
				parts.remove(part);
				partContainer1.removeChild(part.sprite);
                partContainer2.removeChild(part.sprite);
                partContainer3.removeChild(part.sprite);
			} else {
				part.update(grid, deltaTime);
			}
        }
    }

    public function onJump() {
        if(jumpsLeft > 0) {
            velocityY = -600;
            jumpsLeft--;
        }
    }

    override function onCollisionBy(that : Actor, incomingVelocityX : Float, incomingVelocityY : Float) {
        if(Std.is(that, Wall)) jumpsLeft = maxJumps;

        if(Std.is(that, Bunny) && that.boundingBox.y < boundingBox.y && velocityY + incomingVelocityY > 0) {
            that.velocityY = -200;

            for(i in 0 ... 100) {
                var container : ParticleContainer;
                var texture : Texture;
                var scale : Float;
                if(i % 3 != 0) {
                    container = partContainer1;
                    texture = Texture.fromImage("../assets/bunny-part1.png");
                    scale = 0.8;
                } else {
                    container = partContainer2;
                    texture = Texture.fromImage("../assets/bunny-part2.png");
                    scale = 1;
                };

                var angle = Math.random() * 2 * Math.PI;
                var magnitute = Math.random() * Math.log(1 + Math.abs(velocityY - incomingVelocityY) / 100) * 400;
                var partVelocityX = velocityX + Math.cos(angle) * magnitute;
                var partVelocityY = velocityY + (Math.sin(angle) - 0.3) * magnitute;
                var sprite = new Sprite(texture);
                var timeToLive = Math.random() * 5 + 5;
                var part = new BunnyPart(boundingBox.x, boundingBox.y, partVelocityX, partVelocityY, timeToLive, scale, sprite);
				parts.push(part);
                container.addChild(part.sprite);
                /*var bloodSprite = Sprite.fromImage("../assets/blood1.png");
				var blood = new BunnyPart(boundingBox.x, boundingBox.y, partVelocityX * 0.95, partVelocityY * 0.95, timeToLive / 2, scale, bloodSprite);
				parts.push(blood);
                partContainer3.addChild(blood.sprite);*/
            }

            boundingBox.x = startX;
            boundingBox.y = startY;
        }
    }
}

private class BunnyPart extends Actor {
    public var sprite : Sprite;
	public var timeToLive : Float;
	public var alive = true;
    var spin : Float;

    public function new(x : Float, y : Float, speedX : Float, speedY : Float, timeToLive : Float, scale : Float, sprite : Sprite) {
        super(new BoundingBox(x, y, 2, 2), speedX, speedY, false);
		this.timeToLive = timeToLive;
        this.sprite = sprite;
        sprite.anchor.set(0.5, 0.5);
        sprite.position.set(boundingBox.x, boundingBox.y);
        sprite.scale.set((Math.random() * 1.5 + 0.5) * scale, (Math.random() * 1.5 + 0.5) * scale);
        spin = (Math.random() - 0.5) * 100;
    }

    public function update(grid : SparseGrid<Actor>, deltaTime : Float) {
        timeToLive -= deltaTime;
		if (timeToLive < 1) {
			sprite.scale.x *= 0.90;
			sprite.scale.y *= 0.90;
		}
		
		if(!alive) return;
		velocityY += BunnyLogic.gravitationalForce * deltaTime;
        move(grid, deltaTime);

        sprite.position.set(boundingBox.x, boundingBox.y);
        sprite.rotation += spin * deltaTime;
    }
	
	override public function canCollideWith(that : Actor) : Bool {
		return Std.is(that, Wall);
	}

    override function onCollision(that : Actor, bounceVelocityX : Float, bounceVelocityY : Float, bounceX : Float, bounceY : Float) {
        if(bounceVelocityY > 0 && velocityY == 0) alive = false;
		velocityX *= 0.5;
        velocityX *= 0.5;
        spin = 0;
        return false;
    }

}

private class Wall extends Actor {
    public var sprite : Sprite;

    public function new(x : Float, y : Float, width : Float, height : Float) {
        super(new BoundingBox(x, y, width, height), 0, 0, true);
        this.sprite = new TilingSprite(Texture.fromImage("../assets/wall.jpg"), width, height);
        sprite.anchor.set(0.5, 0.5);
        sprite.position.set(boundingBox.x, boundingBox.y);
    }
}
