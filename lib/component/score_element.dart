import 'package:flame/components.dart';
import 'dart:ui';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'priority_sprite_component.dart';

class ScoreElement extends PrioritySpriteComponent {
  ScoreElement(Image image, Vector2 size) : super(1, image, size: size) {
    this.anchor = Anchor.center;
  }
}
