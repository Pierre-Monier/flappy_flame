import 'dart:async' as A;
import 'dart:ui';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';

void main() {
  final myGame = MyGame();

  runApp(
    GameWidget(
      game: myGame,
    ),
  );
}

class MyGame extends Game with TapDetector {
  GameState gameState = GameState.Stagging;
  SpriteComponent blanchon;
  final blanchonSize = Vector2(64, 64);
  var isTaped = false;

  @override
  Future<void> onLoad() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    final blanchonImage = await images.load('blanchon.png');
    blanchon = SpriteComponent.fromImage(blanchonImage,
        size: blanchonSize, position: Vector2((size.x / 2), (size.y / 2)));
  }

  @override
  void onTapDown(TapDownDetails details) {
    switch (gameState) {
      case GameState.Playing:
        // timer for a smooth effect, to remove (addEffect)
        A.Timer(Duration(milliseconds: 100), () {
          isTaped = true;
        });
        break;
      case GameState.Stagging:
        gameState = GameState.Playing;
        break;
      case GameState.DeadMenu:
        gameState = GameState.Stagging;
        blanchon.position = Vector2((size.x / 2), (size.y / 2));
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
        blanchon.position.y =
            (blanchon.position.y > 116) ? (blanchon.position.y - 116) : 0;

        // doesn't works, looking for a discord response
        // blanchon.addEffect(ScaleEffect(
        //   size: Vector2(300, 300),
        //   speed: 250.0,
        //   curve: Curves.bounceInOut,
        // ));
        isTaped = false;
      } else if (blanchon.position.y < size.y) {
        blanchon.position.y += 4;
      } else {
        print('Im dead');
        gameState = GameState.DeadMenu;
      }
    }
  }

  // render the UI
  @override
  void render(Canvas canvas) {
    if (gameState == GameState.Playing) {
      blanchon.render(canvas);
    }
  }
}

enum GameState { Playing, Stagging, DeadMenu }
