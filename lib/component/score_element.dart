import 'package:flame/components.dart';
import 'dart:ui';
import 'package:flame/effects.dart';
import './game_component.dart';
import 'package:flame/game.dart';
import 'priority_sprite_component.dart';

class ScoreElement extends GameComponent {
  ScoreElement(Image image, Vector2 size) {
    sprite = PrioritySpriteComponent(1, image, size: size);
    sprite.anchor = Anchor.center;
  }
}
