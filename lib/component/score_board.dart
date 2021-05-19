import 'package:flame/components.dart';

import 'dart:ui';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';

class ScoreBoard extends SpriteComponent {
  ScoreBoard(Image image, Vector2 size, Vector2 position)
      : super(sprite: Sprite(image), position: position, size: size) {
    this.anchor = Anchor.center;
  }

  double get scoreYPosition => position.y - (toRect().height / 8);
  double get bestScoreYPosition => position.y + (toRect().height / 4);
}
