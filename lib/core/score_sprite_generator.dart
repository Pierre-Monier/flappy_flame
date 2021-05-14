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

  void updateScore(int score) {
    final scoreLength = score.toString().split('').length;
    _displayedScore = score
        .toString()
        .split('')
        .reversed
        .toList()
        .asMap()
        .entries
        .map((element) {
      final scoreElementImage = _scoreElementImages[int.parse(element.value)];
      final scoreElement = ScoreElement(
          scoreElementImage, _defaultScoreElementSize, _defaultPosition);

      final xPosition = _defaultPosition.x -
          ((scoreElement.spriteToCollisionRect().width * element.key) -
              (scoreElement.spriteToCollisionRect().width / 2) *
                  (scoreLength - 1));

      // we reset the sprite x position because we need the sprite size in order to center the displayed score
      scoreElement.sprite.position = Vector2(xPosition, _defaultPosition.y);

      _displayerScoreStream.sink.add(scoreElement.sprite);
      return scoreElement.sprite;
    }).toList();
  }

  Stream<SpriteComponent> getDisplayedScore() {
    return _displayerScoreStream.stream;
  }

  List<SpriteComponent> get scoreElementSprites => _displayedScore;
}
