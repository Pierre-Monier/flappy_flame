import 'package:flame/components.dart';

abstract class GameComponent {
  SpriteComponent sprite;
  SpriteComponent get getSprite => sprite;
}
