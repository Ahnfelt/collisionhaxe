package collisionhaxe.example;
import collisionhaxe.Actor;
import collisionhaxe.BoundingBox;
import js.html.CanvasRenderingContext2D;

// Just an example of an actor - not essential
class Particle extends Actor {
    
    private var size : Float;
    private var age : Float;
    private var maxAge : Float;
    private var color : String;
    private var oldX : Float;
    private var oldY : Float;
    private var game : Game;

    public function new(boundingBox : BoundingBox, velocityX : Float, velocityY : Float, game : Game) {
        super(boundingBox, velocityX, velocityY, false);
        var k = Math.random();
        this.size = 1.5 - k * k * 0.8;
        this.age = 0;
        var r = Math.random();
        this.maxAge = 10.0 - r * 9.0;
        var c = Math.round(220 - 60 * r);
        this.color = 'rgb(' + c + ', 0, 0)';
        this.oldX = null;
        this.oldY = null;
        this.game = game;
    }

    override function onCollision(that : Actor, bounceVelocityX : Float, bounceVelocityY : Float, bounceX : Float, bounceY : Float) { 
        if(that.solid) {
            if(Math.abs(bounceVelocityX) > Actor.epsilon) this.velocityX = bounceVelocityX * 0.25;
            if(Math.abs(bounceVelocityY) > Actor.epsilon) this.velocityY = bounceVelocityY * 0.25;
            this.applyFriction(that, bounceX, bounceY);
            return true;
        } else {
            return false;
        }
    }

    function applyFriction(that : Actor, bounceX : Float, bounceY : Float) {
        var box = that.boundingBox;
        if(bounceX > box.x - box.halfWidth && bounceX < box.x + box.halfWidth) this.velocityX *= 0.9;
        if(bounceY > box.y - box.halfHeight && bounceY < box.y + box.halfHeight) this.velocityY *= 0.9;
    }

    override function onTick(deltaTime : Float) {
        this.age += deltaTime;
        if(this.age > this.maxAge) game.remove(this);
    }

    override function draw(context : CanvasRenderingContext2D) {
        var box = this.boundingBox;
        // TODO: Better culling (but the culling is very important - this function vastly dominates CPU usage without it)
        if(box.x + box.halfWidth > 0 && box.x - box.halfWidth < 1024 && box.y + box.halfHeight > 0 && box.y - box.halfHeight < 768) {
            var w = Math.min(box.halfWidth, box.halfWidth * (this.maxAge - this.age) * 0.20 + 0.1);
            var h = Math.min(box.halfHeight, box.halfHeight * (this.maxAge - this.age) * 0.20 + 0.1);
            var d = this.size * (w + h);
            var x = box.x;
            var y = box.y + (box.halfHeight - h);
            context.lineWidth = d;
            context.lineCap = 'round';
            context.strokeStyle = this.color;
            context.beginPath();
            context.moveTo(x, y);
            var oX = (this.oldX != null && Math.abs(this.oldX - x) > Actor.epsilon) ? this.oldX : x + Actor.epsilon;
            var oY = (this.oldY != null && Math.abs(this.oldY - y) > Actor.epsilon) ? this.oldY : y + Actor.epsilon;
            /*if(Math.abs(x - oX) > this.resolution || Math.abs(y - oY) > this.resolution) {
                oX = x + this.epsilon;
                oY = y + this.epsilon;
            }*/
            context.lineTo(oX, oY);
            context.stroke();
            this.oldX = x;
            this.oldY = y;
        } else {
            this.oldX = null;
            this.oldY = null;
        }
    }
    
}