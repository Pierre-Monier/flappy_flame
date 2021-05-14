import 'package:flame/components.dart';

import 'dart:ui';

class PrioritySpriteComponent extends SpriteComponent {
  @override
  int priority;

  PrioritySpriteComponent(int priority, Image image,
      {Vector2 position, Vector2 size})
      : this.priority = priority,
        super(sprite: Sprite(image), position: position, size: size);
}
