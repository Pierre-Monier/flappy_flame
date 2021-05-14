import 'package:flame/components.dart';
import 'dart:ui';
import 'package:flame/effects.dart';
import './game_component.dart';
import 'package:flame/game.dart';

class ScoreElement extends GameComponent {
  ScoreElement(Image image, Vector2 size, Vector2 position) {
    sprite = SpriteComponent.fromImage(image, size: size, position: position);
    sprite.anchor = Anchor.center;
  }
}
