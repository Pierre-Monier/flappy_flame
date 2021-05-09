import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flappy_blanchon/component/index.dart';

class ScoreSpriteGenerator {
  Vector2 _defaultPosition;
  final defaultScoreElementSize = Vector2(64, 64);
  List<Image> _scoreElementImages;
  List<SpriteComponent> _displayedScore = [];

  ScoreSpriteGenerator(this._defaultPosition, this._scoreElementImages);

  void updateScore(int score) {
    _displayedScore = score.toString().split('').map((gameScoreNumber) {
      final scoreElementImage = _scoreElementImages[int.parse(gameScoreNumber)];
      final scoreElement = ScoreElement(
          scoreElementImage, defaultScoreElementSize, _defaultPosition);

      return scoreElement.sprite;
    }).toList();
  }

  List<SpriteComponent> get scoreElementSprites => _displayedScore;
}
