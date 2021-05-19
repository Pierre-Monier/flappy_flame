import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';

class Bg extends ParallaxComponent {
  Bg(ParallaxImage image, Vector2 size) : super(size: size) {
    final layer = ParallaxLayer(image, velocityMultiplier: Vector2(1.0, 1.0));
    parallax = Parallax([layer], size, baseVelocity: Vector2(100.0, 0.0));
  }

  stopMovement() {
    parallax.baseVelocity = Vector2(0.0, 0.0);
  }

  restartMovement() {
    parallax.baseVelocity = Vector2(100.0, 0.0);
  }
}
