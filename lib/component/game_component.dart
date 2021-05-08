import 'package:flame/components.dart';
import 'package:flutter/material.dart';

abstract class GameComponent {
  SpriteComponent sprite;

  Rect spriteToCollisionRect() {
    double left = sprite.position.x;
    double right = sprite.position.x + sprite.size.x;
    double top = sprite.position.y;
    double bottom = sprite.position.y + sprite.size.y;

    return Rect.fromLTRB(left, top, right, bottom);
  }

  SpriteComponent get getSprite => sprite;
}
