import 'dart:async';
import 'dart:ui';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';
import 'package:flame/gestures.dart';
import 'package:flame/components.dart' hide Timer;
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../component/index.dart';
import './pipe_generator.dart';
import 'score_sprite_generator.dart';

enum GameState { Playing, Stagging, DeadMenu }

class FlappyGame extends BaseGame with TapDetector {
  static const BOX_KEY = 'flappy_blanchon';
  static const BEST_SCORE_KEY = 'best_score';
  GameState gameState = GameState.Stagging;
  Blanchon _blanchon;
  Bg _bg;
  Ground _ground;
  ScoreSpriteGenerator _scoreDisplayer;
  PipeGenerator _pipeGenerator;
  StreamSubscription<SpriteComponent> _pipesSubscription;
  int _score;
  // TODO create a BoxWrapper class
  Box _hiveBox;
  bool _isTaped;
  bool _isStaggingReady;

  @override
  Future<void> onLoad() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _isTaped = false;
    _isStaggingReady = true;

    await Hive.initFlutter();
    _hiveBox = await Hive.openBox(BOX_KEY);

    final topPipePosition = Vector2(size.x, 0);
    final bottomPipePosition = Vector2(size.x, (size.y - 150));
    final blanchonPosition = Vector2((size.x / 2), (size.y / 2));

    // Loading all game images
    final blanchonImage = await images.load('blanchon.png');
    final bgImage = await images.load('bg.png');
    final groundImage = await images.load('ground.png');
    final topPipeImage = await images.load('top-pipe.png');
    final bottomPipeImage = await images.load('bottom-pipe.png');
    final image0 = await images.load('0.png');
    final image1 = await images.load('1.png');
    final image2 = await images.load('2.png');
    final image3 = await images.load('3.png');
    final image4 = await images.load('4.png');
    final image5 = await images.load('5.png');
    final image6 = await images.load('6.png');
    final image7 = await images.load('7.png');
    final image8 = await images.load('8.png');
    final image9 = await images.load('9.png');
    final scoreElementImages = [
      image0,
      image1,
      image2,
      image3,
      image4,
      image5,
      image6,
      image7,
      image8,
      image9
    ];

    final blanchonSize = Vector2(64, 64);

    // Init core
    _pipeGenerator = PipeGenerator(topPipeImage, bottomPipeImage,
        topPipePosition, bottomPipePosition, blanchonSize.y * 3);
    _scoreDisplayer =
        ScoreSpriteGenerator(Vector2((size.x / 2), 50), scoreElementImages);

    // Init components
    _blanchon = Blanchon(blanchonImage, blanchonSize, blanchonPosition);
    _bg = Bg(bgImage, Vector2(size.x, size.y));
    _ground =
        Ground(groundImage, Vector2(size.x, 150), Vector2(0, (size.y - 150)));

    add(_bg.getSprite);
    add(_ground.getSprite);
    add(_blanchon.getSprite);

    // Init displayed score
    getDisplayedScore();
    _score = 0;
  }

  @override
  void onTapDown(TapDownDetails details) {
    switch (gameState) {
      case GameState.Playing:
        _isTaped = true;
        break;
      case GameState.Stagging:
        _startGame();
        break;
      case GameState.DeadMenu:
        if (_isStaggingReady) {
          _startStagging();
        }
        break;
      default:
        break;
    }
  }

  void _startGame() {
    gameState = GameState.Playing;
    getPipes();
    _updateDisplayedScore(_score);
    _isTaped = true;
  }

  void _startStagging() {
    gameState = GameState.Stagging;
    _blanchon.reloadDefaultPosition();
    removeAll(_pipeGenerator.getPipesSprites);
    _pipeGenerator.cleanUpPipes();
    _score = 0;
    removeAll(_scoreDisplayer.scoreElementSprites);
  }

  @override
  void update(double dt) {
    if (gameState == GameState.Playing) {
      if (_isTaped) {
        _blanchon.flutter();
        _isTaped = false;
      }

      _blanchon.fall();
      _pipeGenerator.updatePipes();
      _checkCollision();
      _updateScore();
    }
    super.update(dt);
  }

  void _checkCollision() {
    if (_isBlanchonHitingGround() || _isBlanchonHitingPipes()) {
      _handleEndGame();
    }
  }

  bool _isBlanchonHitingGround() =>
      (_blanchon.bottomYPosition > _ground.topYPosition);

  bool _isBlanchonHitingPipes() {
    var isCollision = false;
    final pipesSprite = _pipeGenerator.getPipes;
    final blanchonRect = _blanchon.spriteToCollisionRect();

    for (final pipeSprite in pipesSprite) {
      final pipeRect = pipeSprite.spriteToCollisionRect();

      if (_isRectCollision(blanchonRect, pipeRect)) {
        isCollision = true;
        break;
      }
    }

    return isCollision;
  }

  bool _isRectCollision(Rect rect1, Rect rect2) =>
      (rect1.left < rect2.right + rect1.size.width / 2 &&
          rect1.right > rect2.left + rect1.size.width / 2 &&
          rect1.top < rect2.bottom + rect1.size.height / 2 &&
          rect1.bottom > rect2.top + rect1.size.height / 2);

  void _updateScore() {
    final pipes = _pipeGenerator.getPipes;
    final blanchonRect = _blanchon.spriteToCollisionRect();

    // we check if pipe is a top pipe because we only want to update score
    // if blanchon pass 2 pipe (bottom-pipe and top-pipe), so we remove bottom from this equation
    pipes.forEach((pipe) {
      if (!pipe.isBlanchonBehing &&
          pipe.isATopPipe &&
          blanchonRect.left > pipe.spriteToCollisionRect().right) {
        pipe.blanchonPassThePipe();
        _score++;
        _updateDisplayedScore(_score);
      }
    });
  }

  void _updateDisplayedScore(int score,
      {double customYPosition, bool shouldCleanUp = true}) {
    removeAll(_scoreDisplayer.scoreElementSprites);
    _scoreDisplayer.generateScoreSprites(score,
        customYPosition: customYPosition, shouldCleanUp: shouldCleanUp);
  }

  void _updateEndGameDisplayedScore() {
    final bestScore = _getBestScore();

    _updateDisplayedScore(_score, customYPosition: 250, shouldCleanUp: false);
    _updateDisplayedScore(bestScore,
        customYPosition: 350, shouldCleanUp: false);
  }

  void _handleEndGame() {
    _isStaggingReady = false;
    final deathBlanchonYPosition =
        _ground.topYPosition - _blanchon.sprite.size.y;
    _blanchon.die(deathBlanchonYPosition);
    gameState = GameState.DeadMenu;
    _pipesSubscription.cancel();
    removeAll(_scoreDisplayer.scoreElementSprites);
    _updateBestScore();
    _updateEndGameDisplayedScore();

    Timer(Duration(seconds: 1), () {
      _isStaggingReady = true;
    });
  }

  void _updateBestScore() {
    final currentBestScore = _getBestScore();

    if (_score > currentBestScore) {
      _hiveBox.put(BEST_SCORE_KEY, _score);
    }
  }

  void getPipes() {
    _pipesSubscription = _pipeGenerator.startPipeGeneration().listen((pipe) {
      add(pipe);
    });
  }

  void getDisplayedScore() {
    _scoreDisplayer.getDisplayedScore().listen((scoreSprites) {
      add(scoreSprites);
    });
  }

  // TODO refacto in BoxWrapper
  int _getBestScore() {
    if (_hiveBox != null) {
      final bestScore = _hiveBox.get(BEST_SCORE_KEY) as int;
      return bestScore ?? 0;
    }
    return 0;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
