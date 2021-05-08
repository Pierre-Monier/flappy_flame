import 'dart:ui';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';
import 'package:flame/gestures.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'component/index.dart';

class FlappyGame extends BaseGame with TapDetector {
  GameState gameState = GameState.Stagging;
  Blanchon blanchon;
  Bg bg;
  Ground ground;
  var isTaped = false;

  @override
  Future<void> onLoad() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    final blanchonImage = await images.load('blanchon.png');
    final bgImage = await images.load('bg.png');
    final groundImage = await images.load('ground.png');

    blanchon = Blanchon(
        blanchonImage, Vector2(64, 64), this.getDefaultBlanchonPosition);
    bg = Bg(bgImage, Vector2(size.x, size.y));
    ground =
        Ground(groundImage, Vector2(size.x, 150), Vector2(0, (size.y - 150)));

    add(bg.getSprite);
    add(ground.getSprite);
    add(blanchon.getSprite);
  }

  @override
  void onTapDown(TapDownDetails details) {
    switch (gameState) {
      case GameState.Playing:
        isTaped = true;
        break;
      case GameState.Stagging:
        gameState = GameState.Playing;
        break;
      case GameState.DeadMenu:
        gameState = GameState.Stagging;
        blanchon.reloadDefaultPosition();
        break;
      default:
        break;
    }
  }

  // process the game logic
  @override
  void update(double dt) {
    if (gameState == GameState.Playing) {
      if (isTaped) {
        blanchon.flutter();
        // I really don't get how this one is supposed to work :/
        // blanchon.addEffect(RotateEffect(angle: 0.1, speed: 1));
        isTaped = false;
      }

      blanchon.fall();
      this.checkCollision();
    }
    super.update(dt);
  }

  void checkCollision() {
    // blanchon/ground collision
    if ((blanchon.bottomYPosition) > ground.topYPosition) {
      print('Dead');
      gameState = GameState.DeadMenu;
    }
  }

  Vector2 get getDefaultBlanchonPosition => Vector2((size.x / 2), (size.y / 2));

  // render the UI
  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}

enum GameState { Playing, Stagging, DeadMenu }
