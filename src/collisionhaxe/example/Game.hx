package collisionhaxe.example;
import js.html.CanvasRenderingContext2D;
import collisionhaxe.Actor;
import collisionhaxe.SparseGrid;

class Game {
    
    public var actors : Array<Actor>;
    public var grid : SparseGrid<Actor>;
    public var time : Float;

    public function new(actors : Array<Actor>) {
        this.actors = [];
        this.grid = new SparseGrid<Actor>(200, 200);
        this.time = Date.now().getTime();
        if(actors != null) {
            for(i in 0 ... actors.length) {
                this.insert(actors[i]);
            }
        }
    }

    public function insert(actor : Actor) {
        var i = this.actors.indexOf(actor);
        if(i == -1) {
            this.actors.push(actor);
            if(actor.solid) this.grid.insert(actor.boundingBox, actor);
        }
    }

    public function remove(actor : Actor) {
        this.grid.remove(actor.boundingBox, actor);
        var i = this.actors.indexOf(actor);
        if(i != -1) this.actors.splice(i, 1);
    }

    public function tick() {
        var newTime = Date.now().getTime();
        var deltaTimeMs = newTime - this.time;
        this.time = newTime;
        return Math.min(100, deltaTimeMs) / 1000;
    }

    public function update(deltaTime : Float) {
        for(i in 0 ... this.actors.length) {
            var actor = this.actors[i];
            if(actor != null) { // Because we may remove actors during the update
                actor.move(this.grid, deltaTime);
                actor.onTick(deltaTime);
            }
        }
    }

    public function draw(context : CanvasRenderingContext2D) {
        context.save();
        context.clearRect(0, 0, context.canvas.width, context.canvas.height);
        for(i in 0 ... this.actors.length) {
            var actor = this.actors[i];
            actor.draw(context);
        }
        context.fillText("Objects: " + this.actors.length, 10, 10);
        context.restore();
    }

    public function loop(context, callback) {
        var deltaTime = this.tick();
        if(callback != null) callback(this, deltaTime);
        this.update(deltaTime);
        this.draw(context);
        untyped window.requestAnimationFrame(function() { this.loop(context, callback); });
    }
    
}
