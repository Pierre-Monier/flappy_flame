import 'dart:ui';
import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart' hide Timer;
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/animation.dart';
import 'game_component.dart';

class Blanchon extends GameComponent {
  Vector2 _defaultPosition;
  bool _isFluttering;
  Timer _currentFlutteringTimer;
  // representing millisecond
  static const FLUTTERING_DELAY = 250;

  Blanchon(Image image, Vector2 size, Vector2 position) {
    _isFluttering = false;
    // we create a new Vector2 to avoid object reference issues
    _defaultPosition = Vector2(position.x, position.y);
    sprite = SpriteComponent.fromImage(image, size: size, position: position);
    sprite.anchor = Anchor.center;
  }

  void reloadDefaultPosition() {
    // we create a new Vector2 to avoid object reference issues
    sprite.position = Vector2(_defaultPosition.x, _defaultPosition.y);

    final defaultRotate =
        RotateEffect(angle: 0, duration: 0, curve: Curves.linear);

    sprite.addEffect(defaultRotate);
  }

  void flutter() {
    _clearFlutteringTimer();
    _isFluttering = true;

    final moveUp = MoveEffect(
        path: [Vector2(sprite.position.x, (sprite.position.y - 85))],
        duration: FLUTTERING_DELAY / 1000,
        curve: Curves.linear);

    final rotateUp =
        RotateEffect(angle: (-pi / 4), duration: 0.25, curve: Curves.easeOut);

    final flutterEffect = CombinedEffect(effects: [moveUp, rotateUp]);

    sprite.addEffect(flutterEffect);
    _currentFlutteringTimer = Timer(
        Duration(milliseconds: FLUTTERING_DELAY), () => _isFluttering = false);
  }

  void fall() {
    if (!_isFluttering) {
      final moveDown = MoveEffect(
          path: [Vector2(sprite.position.x, (sprite.position.y + 85))],
          duration: FLUTTERING_DELAY / 1000,
          curve: Curves.linear);

      final rotateDown = RotateEffect(
          angle: (pi / 2), duration: 0.25, curve: Curves.bounceInOut);

      final fallEffect = CombinedEffect(effects: [moveDown, rotateDown]);

      sprite.addEffect(fallEffect);
    }
  }

  void die(double groundTopPosition) {
    final moveToGround = MoveEffect(path: [
      Vector2(sprite.position.x, groundTopPosition + spriteHeight / 2)
    ], duration: 0.5);

    // It might be optional if it looks weird with blanchon rotation
    final funkyRotation =
        RotateEffect(angle: pi / 2, duration: 0.5, curve: Curves.linear);

    final combination = CombinedEffect(effects: [moveToGround, funkyRotation]);

    sprite.addEffect(combination);
  }

  void _clearFlutteringTimer() {
    if (_currentFlutteringTimer != null) {
      _currentFlutteringTimer.cancel();
    }
  }

  double get bottomYPosition => sprite.position.y + spriteHeight / 2;
  double get spriteHeight => sprite.size.y;
  double get spriteWidth => sprite.size.x;
}
