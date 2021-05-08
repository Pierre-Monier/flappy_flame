import 'dart:ui';
import 'dart:async';
import 'package:flame/components.dart' hide Timer;
import 'package:flappy_blanchon/component/pipe.dart';
import '../component/pipe.dart';

class PipeGenerator {
  Image _topPipeImage;
  Vector2 _topPipePosition;
  Image _bottomPipeImage;
  Vector2 _bottomPipePosition;
  double _gapSize;
  List<Pipe> _pipes;

  PipeGenerator(Image topPipeImage, Image bottomPipeImage,
      Vector2 topPipePosition, Vector2 bottomPipePosition, double gapSize) {
    _topPipeImage = topPipeImage;
    _bottomPipeImage = bottomPipeImage;
    // create a new Vector2 to avoid position issues
    _topPipePosition = Vector2(topPipePosition.x, topPipePosition.y);
    // create a new Vector2 to avoid position issues
    _bottomPipePosition = Vector2(bottomPipePosition.x, bottomPipePosition.y);
    _gapSize = gapSize;
    _pipes = [];
  }

  void cleanUpPipes() {
    _pipes = [];
  }

  Stream<SpriteComponent> startPipeGeneration() {
    StreamController<SpriteComponent> controller;
    Timer timer;
    final interval = Duration(seconds: 2);

    void tick(_) {
      final topPipeSize = Vector2(64, _bottomPipePosition.y / 2);
      final bottomPipeSize = Vector2(64, _bottomPipePosition.y / 2 - _gapSize);
      // create new Vector2 to avoid position issues
      final topPipePosition = Vector2(_topPipePosition.x, _topPipePosition.y);
      final bottomPipePosition = Vector2(
          _bottomPipePosition.x, (_bottomPipePosition.y - bottomPipeSize.y));

      final topPipe = Pipe(_topPipeImage, topPipeSize, topPipePosition);
      final bottomPipe =
          Pipe(_bottomPipeImage, bottomPipeSize, bottomPipePosition);

      _pipes.addAll([topPipe, bottomPipe]);

      controller.add(topPipe.getSprite);
      controller.add(bottomPipe.getSprite);
    }

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
      }
      controller.close();
    }

    void startTimer() {
      timer = Timer.periodic(interval, tick);
    }

    controller = StreamController<SpriteComponent>(
        onListen: startTimer,
        onPause: stopTimer,
        onResume: startTimer,
        onCancel: stopTimer);

    return controller.stream;
  }

  void updatePipes() {
    final newPipes = _pipes.map((pipe) {
      if (pipe.getSprite.position.x + pipe.getSprite.size.x > 0) {
        pipe.getSprite.position.x -= 2;
        return pipe;
      }
    }).toList();

    // map set item to null if it's not return by callback
    // so we need to remove null item from _pipes
    _pipes = newPipes.where((pipe) => pipe != null).toList();
  }

  List<Pipe> get getPipes => _pipes;

  List<SpriteComponent> get getPipesSprites =>
      _pipes.map((pipe) => pipe.sprite).toList();
}
