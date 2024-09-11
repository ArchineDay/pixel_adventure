import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum playerState { idle, running }

class Player extends SpriteAnimationGroupComponent
    with HasGameReference<PixelAdventure> {
  String character;

  Player({required this.character, required Vector2 position})
      : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.05;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);

    animations = {
      playerState.idle: idleAnimation,
      playerState.running: runningAnimation
    };

    current = playerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amout) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/$character/$state (32x32).png'),
        SpriteAnimationData.sequenced(
            amount: amout, stepTime: stepTime, textureSize: Vector2.all(32)));
  }
}
