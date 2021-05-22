import 'package:flame/components.dart';

class PrioritySpriteAnimationComponent extends SpriteAnimationComponent {
  @override
  int priority;

  PrioritySpriteAnimationComponent(
      int priority, SpriteAnimation spriteAnimation,
      {Vector2 position, Vector2 size})
      : this.priority = priority,
        super(animation: spriteAnimation, position: position, size: size);
}
