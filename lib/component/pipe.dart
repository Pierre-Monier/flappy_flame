import 'package:flame/components.dart';
import 'dart:ui';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';

class Pipe extends SpriteComponent {
  bool _isBlanchonBehing;
  bool _isATopPipe;

  Pipe(Image image, Vector2 size, Vector2 position, bool isATopPipe)
      : super(sprite: Sprite(image), position: position, size: size) {
    _isBlanchonBehing = false;
    _isATopPipe = isATopPipe;
  }

  void blanchonPassThePipe() {
    _isBlanchonBehing = true;
  }

  bool get isBlanchonBehing => _isBlanchonBehing;
  bool get isATopPipe => _isATopPipe;
}
