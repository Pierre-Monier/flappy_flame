import 'dart:async';
import 'dart:ui';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';
import 'package:flame/gestures.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../component/index.dart';
import './pipe_generator.dart';

class FlappyGame extends BaseGame with TapDetector {
  GameState gameState = GameState.Stagging;
  Blanchon _blanchon;
  Bg _bg;
  Ground _ground;
  PipeGenerator _pipeGenerator;
  StreamSubscription<SpriteComponent> _pipesSubscription;
  int score;
  var isTaped = false;

  void getPipes() {
    _pipesSubscription = _pipeGenerator.startPipeGeneration().listen((pipe) {
      add(pipe);
    });
  }

  @override
  Future<void> onLoad() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    score = 0;

    final blanchonImage = await images.load('blanchon.png');
    final blanchonSize = Vector2(64, 64);
    final bgImage = await images.load('bg.png');
    final groundImage = await images.load('ground.png');
    final topPipeImage = await images.load('top-pipe.png');
    final bottomPipeImage = await images.load('bottom-pipe.png');

    _blanchon =
        Blanchon(blanchonImage, blanchonSize, this.getDefaultBlanchonPosition);
    _bg = Bg(bgImage, Vector2(size.x, size.y));
    _ground =
        Ground(groundImage, Vector2(size.x, 150), Vector2(0, (size.y - 150)));

    final topPipePosition = Vector2(size.x, 0);
    final bottomPipePosition = Vector2(size.x, (size.y - 150));

    _pipeGenerator = PipeGenerator(topPipeImage, bottomPipeImage,
        topPipePosition, bottomPipePosition, blanchonSize.y * 2);

    add(_bg.getSprite);
    add(_ground.getSprite);
    add(_blanchon.getSprite);
  }

  @override
  void onTapDown(TapDownDetails details) {
    switch (gameState) {
      case GameState.Playing:
        isTaped = true;
        break;
      case GameState.Stagging:
        // topfuncion startGame
        gameState = GameState.Playing;
        getPipes();
        break;
      case GameState.DeadMenu:
        // tofunction toStagging
        gameState = GameState.Stagging;
        _blanchon.reloadDefaultPosition();
        removeAll(_pipeGenerator.getPipesSprites);
        _pipeGenerator.cleanUpPipes();
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
        _blanchon.flutter();
        // I really don't get how this one is supposed to work :/
        // blanchon.addEffect(RotateEffect(angle: 0.1, speed: 1));
        isTaped = false;
      }

      _blanchon.fall();
      _pipeGenerator.updatePipes();
      checkCollision();
      updateScore();
      print(score.toString());
    }
    super.update(dt);
  }

  void checkCollision() {
    // blanchon/ground collision
    if ((_blanchon.bottomYPosition) > _ground.topYPosition ||
        isBlanchonHitingPipes()) {
      handleEndGame();
    }
  }

  void updateScore() {
    final pipes = _pipeGenerator.getPipes;
    final blanchonRect = _blanchon.spriteToCollisionRect();

    // we iterate with an offset of 2 because pipe comes by two
    // the score is update if blanchon pass 2 pipe (bottom-pipe and top-pipe)
    for (var i = 0; i < pipes.length; i += 2) {
      if (!pipes[i].isBlanchonBehing &&
          blanchonRect.left > pipes[i].spriteToCollisionRect().right) {
        pipes[i].blanchonPassThePipe();
        score++;
      }
    }
  }

  void handleEndGame() {
    print('Dead');
    gameState = GameState.DeadMenu;
    _pipesSubscription.cancel();
    // close setInterval of pipegenerator
  }

  // render the UI
  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  bool isBlanchonHitingPipes() {
    var isCollision = false;
    final pipes = _pipeGenerator.getPipes;
    final blanchonRect = _blanchon.spriteToCollisionRect();

    pipes.forEach((pipeSprite) {
      final pipeRect = pipeSprite.spriteToCollisionRect();

      if (blanchonRect.left <
              pipeRect.left + (pipeRect.right - pipeRect.left) &&
          blanchonRect.left + (blanchonRect.right - blanchonRect.left) >
              pipeRect.left &&
          blanchonRect.top < pipeRect.top + (pipeRect.bottom - pipeRect.top) &&
          blanchonRect.top + (blanchonRect.bottom - blanchonRect.top) >
              pipeRect.top) {
        isCollision = true;
      } else {
        isCollision = false;
      }
    });

    return isCollision;
  }

  Vector2 get getDefaultBlanchonPosition => Vector2((size.x / 2), (size.y / 2));
}

enum GameState { Playing, Stagging, DeadMenu }
