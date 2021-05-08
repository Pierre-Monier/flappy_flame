import 'package:flame/components.dart';

import 'dart:ui';
import 'package:flame/effects.dart';
import './game_component.dart';
import 'package:flame/game.dart';

class Bg extends GameComponent {
  Bg(Image image, Vector2 size) {
    sprite = SpriteComponent.fromImage(image, size: size);
  }
}
