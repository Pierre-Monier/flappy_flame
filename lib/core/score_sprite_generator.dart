import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flappy_blanchon/component/index.dart';

class ScoreSpriteGenerator {
  Vector2 _defaultPosition;
  final _defaultScoreElementSize = Vector2(64, 64);
  List<Image> _scoreElementImages;
  List<SpriteComponent> _displayedScore = [];
  StreamController<SpriteComponent> _displayerScoreStream;

  ScoreSpriteGenerator(this._defaultPosition, this._scoreElementImages) {
    void stopStream() {
      _displayerScoreStream.close();
    }

    _displayerScoreStream = StreamController<SpriteComponent>(
        onPause: stopStream, onCancel: stopStream);
  }

  void generateScoreSprites(int score,
      {double customYPosition, bool shouldCleanUp = true}) {
    final scoreLength = score.toString().split('').length;

    if (shouldCleanUp) {
      _displayedScore = [];
    }

    _displayedScore.addAll(score
        .toString()
        .split('')
        .reversed
        .toList()
        .asMap()
        .entries
        .map((element) {
      final scoreElementImage = _scoreElementImages[int.parse(element.value)];
      final scoreElement =
          ScoreElement(scoreElementImage, _defaultScoreElementSize);

      final xPosition = _defaultPosition.x -
          ((scoreElement.spriteToCollisionRect().width * element.key) -
              (scoreElement.spriteToCollisionRect().width / 2) *
                  (scoreLength - 1));

      final yPosition = customYPosition ?? _defaultPosition.y;

      scoreElement.sprite.position = Vector2(xPosition, yPosition);

      _displayerScoreStream.sink.add(scoreElement.sprite);
      return scoreElement.sprite;
    }).toList());
  }

  Stream<SpriteComponent> getDisplayedScore() {
    return _displayerScoreStream.stream;
  }

  List<SpriteComponent> get scoreElementSprites => _displayedScore;
}
