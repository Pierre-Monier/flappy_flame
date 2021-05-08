import 'package:flame/components.dart';
import 'dart:ui';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'game_component.dart';

class Blanchon extends GameComponent {
  Vector2 _defaultPosition;

  Blanchon(Image image, Vector2 size, Vector2 position) {
    // we create a new Vector2 to avoid object reference issues
    _defaultPosition = Vector2(position.x, position.y);
    sprite = SpriteComponent.fromImage(image, size: size, position: position);
  }

  void reloadDefaultPosition() {
    // we create a new Vector2 to avoid object reference issues
    sprite.position = Vector2(_defaultPosition.x, _defaultPosition.y);
  }

  void flutter() {
    sprite.addEffect(MoveEffect(
      path: [Vector2(sprite.position.x, (sprite.position.y - 110))],
      speed: 600.0,
    ));
  }

  void fall() {
    sprite.position.y += 6;
  }

  double get bottomYPosition => sprite.position.y + sprite.size.y;
}
