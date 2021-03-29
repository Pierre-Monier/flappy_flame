import 'dart:ui';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';
import 'package:flame/gestures.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class MyGame extends BaseGame with TapDetector {
  GameState gameState = GameState.Stagging;
  SpriteComponent blanchon;
  SpriteComponent bg;
  SpriteComponent ground;
  var isTaped = false;

  @override
  Future<void> onLoad() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    final blanchonImage = await images.load('blanchon.png');
    final bgImage = await images.load('bg.png');
    final groundImage = await images.load('ground.png');

    add(bg = SpriteComponent.fromImage(bgImage, size: Vector2(size.x, size.y)));
    add(ground = SpriteComponent.fromImage(groundImage,
        size: Vector2(size.x, 150), position: Vector2(0, (size.y - 150))));
    add(
      blanchon = SpriteComponent.fromImage(blanchonImage,
          size: Vector2(64, 64), position: this.getDefaultBlanchonPosition),
    );
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
        blanchon.position = this.getDefaultBlanchonPosition;
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
        blanchon.addEffect(MoveEffect(
          path: [Vector2(blanchon.position.x, (blanchon.position.y - 116))],
          speed: 600.0,
        ));
        // I really don't get how this one is supposed to work :/
        // blanchon.addEffect(RotateEffect(angle: 0.1, speed: 1));
        isTaped = false;
      }

      blanchon.position.y += 6;
      this.checkCollision();
    }
    super.update(dt);
  }

  void checkCollision() {
    // blanchon/ground collision
    if ((blanchon.position.y + blanchon.size.y) > ground.position.y) {
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
