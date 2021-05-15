import 'package:flame/components.dart';

import 'dart:ui';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flappy_blanchon/component/game_component.dart';

class ScoreBoard extends GameComponent {
  ScoreBoard(Image image, Vector2 size, Vector2 position) {
    sprite = SpriteComponent.fromImage(image, size: size, position: position);
    sprite.anchor = Anchor.center;
  }

  double get scoreYPosition =>
      sprite.position.y - (spriteToCollisionRect().height / 8);
  double get bestScoreYPosition =>
      sprite.position.y + (spriteToCollisionRect().height / 4);
}
