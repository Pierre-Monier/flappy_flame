import 'dart:ui';
import 'dart:async';
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
  }

  void reloadDefaultPosition() {
    // we create a new Vector2 to avoid object reference issues
    sprite.position = Vector2(_defaultPosition.x, _defaultPosition.y);
  }

  void flutter() {
    _clearFlutteringTimer();
    _isFluttering = true;
    sprite.addEffect(MoveEffect(
        path: [Vector2(sprite.position.x, (sprite.position.y - 85))],
        duration: FLUTTERING_DELAY / 1000,
        curve: Curves.linear));
    _currentFlutteringTimer = Timer(
        Duration(milliseconds: FLUTTERING_DELAY), () => _isFluttering = false);
  }

  void fall() {
    // sprite
    if (!_isFluttering) {
      sprite.position.y += 6;
    }
  }

  void _clearFlutteringTimer() {
    if (_currentFlutteringTimer != null) {
      _currentFlutteringTimer.cancel();
    }
  }

  double get bottomYPosition => sprite.position.y + sprite.size.y;
}
