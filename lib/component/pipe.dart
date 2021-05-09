import 'package:flame/components.dart';

import 'dart:ui';
import 'package:flame/effects.dart';
import './game_component.dart';
import 'package:flame/game.dart';

class Pipe extends GameComponent {
  bool _isBlanchonBehing;
  bool _isATopPipe;

  Pipe(Image image, Vector2 size, Vector2 position, bool isATopPipe) {
    _isBlanchonBehing = false;
    _isATopPipe = isATopPipe;
    sprite = SpriteComponent.fromImage(image, size: size, position: position);
  }

  void blanchonPassThePipe() {
    _isBlanchonBehing = true;
  }

  bool get isBlanchonBehing => _isBlanchonBehing;
  bool get isATopPipe => _isATopPipe;
}
