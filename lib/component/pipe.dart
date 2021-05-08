import 'package:flame/components.dart';

import 'dart:ui';
import 'package:flame/effects.dart';
import './game_component.dart';
import 'package:flame/game.dart';

class Pipe extends GameComponent {
  bool isBlanchonBehing;

  Pipe(Image image, Vector2 size, Vector2 position) {
    isBlanchonBehing = false;
    sprite = SpriteComponent.fromImage(image, size: size, position: position);
  }

  void blanchonPassThePipe() {
    isBlanchonBehing = true;
  }
}
