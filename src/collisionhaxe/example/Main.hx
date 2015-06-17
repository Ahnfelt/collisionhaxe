package collisionhaxe.example;

import js.Browser;
import js.html.Document;
import js.html.CanvasElement;
import collisionhaxe.example.Game;
import collisionhaxe.example.Particle;

class Main {
	
	static function main() {
		
		var randomActors = [];
		for(i in 0 ... 10000) {
			var x = Math.random() * 10000;
			var y = Math.random() * 10000;
			var w = Math.random() * 200 + 10;
			var h = Math.random() * 15 + 5;
			if(Math.random() < 0.5) {
				var t = w;
				w = h;
				h = t;
			}
			randomActors.push(new collisionhaxe.Actor(new collisionhaxe.BoundingBox(x, y, w, h), 0, 0, true));
		}

		function spawnParticle(game, x, y, velocityX, velocityY) {
			var angle = Math.random() * Math.PI * 2;
			var velocity = 100 + 100 * Math.random();
			var vX = Math.cos(angle) * velocity;
			var vY = Math.sin(angle) * velocity - 100;
			var d = Math.random() * 0.1;
			var actor = new collisionhaxe.example.Particle(new collisionhaxe.BoundingBox(x + vX * d, y + vY * d, 5, 5), velocityX + vX, velocityY + vY, game);
			game.insert(actor);
		}

		var keys = {left: false, right: false, up: false, space: false};

		var canvasElement : CanvasElement = cast Browser.document.getElementById('canvas');
		var context = canvasElement.getContext2d();
		var player = new collisionhaxe.Actor(new collisionhaxe.BoundingBox(120, 100, 20, 30), 0, 0, false);
		var actors = randomActors.concat([
			player
		]);
		var game = new collisionhaxe.example.Game(actors);
		game.loop(context, function(game, deltaTime) {
			if(keys.left) player.velocityX = -200;
			else if(keys.right) player.velocityX = 200;
			else player.velocityX = 0;
			for(i in 0 ... game.actors.length) {
				var actor = game.actors[i];
				if(!actor.solid) {
					if(actor.boundingBox.y < 2000) actor.velocityY += 800 * deltaTime;
					else actor.velocityY = Math.min(0, actor.velocityY);
				}
			}
		});
		
		function onKey(pressed, event) {
			if(event.keyCode == 37) keys.left = pressed;
			else if(event.keyCode == 39) keys.right = pressed;
			else if(event.keyCode == 38) { 
				if(pressed && !keys.up) player.velocityY = -300; 
				keys.up = pressed;
			}
			else if(event.keyCode == 32) { 
				if(pressed && !keys.space) {
					for(i in 0 ... 100) spawnParticle(game, player.boundingBox.x, player.boundingBox.y, player.velocityX, player.velocityY);
					game.remove(player);
				}
				keys.space = pressed;
			}
			else return;
			event.preventDefault();
		}

		Browser.document.onkeydown = function(event) { onKey(true, event); }
		Browser.document.onkeyup = function(event) { onKey(false, event); }
	}
	
}
