import 'dart:ui';
import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart' hide Timer;
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/animation.dart';
import 'priority_sprite_component.dart';

class Bird extends PrioritySpriteComponent {
  Vector2 _defaultPosition;
  bool _isFluttering;
  Timer _currentFlutteringTimer;
  // representing millisecond
  static const FLUTTERING_DELAY = 250;
  static const STAGGING_ANIMATION_DELAY = 750;

  Bird(Image image, Vector2 size, Vector2 position)
      : super(1, image, size: size, position: position) {
    _isFluttering = false;
    // we create a new Vector2 to avoid object reference issues
    _defaultPosition = Vector2(position.x, position.y);
    anchor = Anchor.center;
  }

  void reloadDefaultPosition() {
    // we create a new Vector2 to avoid object reference issues
    position = Vector2(_defaultPosition.x, _defaultPosition.y);

    final defaultRotate =
        RotateEffect(angle: 0, duration: 0, curve: Curves.linear);

    addEffect(defaultRotate);
  }

  void flutter() {
    _clearFlutteringTimer();
    _isFluttering = true;

    final moveUp = MoveEffect(
        path: [Vector2(position.x, (position.y - 85))],
        duration: FLUTTERING_DELAY / 1000,
        curve: Curves.linear);

    final rotateUp =
        RotateEffect(angle: (-pi / 4), duration: 0.25, curve: Curves.easeOut);

    final flutterEffect = CombinedEffect(effects: [moveUp, rotateUp]);

    addEffect(flutterEffect);
    _currentFlutteringTimer = Timer(
        Duration(milliseconds: FLUTTERING_DELAY), () => _isFluttering = false);
  }

  void fall() {
    if (!_isFluttering) {
      final moveDown = MoveEffect(
          path: [Vector2(position.x, (position.y + 85))],
          duration: FLUTTERING_DELAY / 1000,
          curve: Curves.linear);

      final rotateDown = RotateEffect(
          angle: (pi / 2), duration: 0.25, curve: Curves.bounceInOut);

      final fallEffect = CombinedEffect(effects: [moveDown, rotateDown]);

      addEffect(fallEffect);
    }
  }

  void die(double groundTopPosition) {
    final moveToGround = MoveEffect(
        path: [Vector2(position.x, groundTopPosition + spriteHeight / 2)],
        duration: 0.5);

    // It might be optional if it looks weird with blanchon rotation
    final funkyRotation =
        RotateEffect(angle: pi / 2, duration: 0.5, curve: Curves.linear);

    final combination = CombinedEffect(effects: [moveToGround, funkyRotation]);

    addEffect(combination);
  }

  void staggingAnimation() {
    final staggingEffect = MoveEffect(
        path: [
          Vector2(position.x, position.y - 10),
          Vector2(position.x, position.y + 10),
          Vector2(position.x, position.y)
        ],
        duration: STAGGING_ANIMATION_DELAY / 1000,
        curve: Curves.linear,
        isInfinite: true);

    addEffect(staggingEffect);
  }

  void _clearFlutteringTimer() {
    if (_currentFlutteringTimer != null) {
      _currentFlutteringTimer.cancel();
    }
  }

  double get bottomYPosition => position.y + spriteHeight / 2;
  double get spriteHeight => size.y;
  double get spriteWidth => size.x;
}
