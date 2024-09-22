import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure/component/collision_block.dart';
import 'package:pixel_adventure/component/player_hitbox.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/utils.dart';

enum PlayerState { idle, running, jumping, falling }

class Player extends SpriteAnimationGroupComponent
    with HasGameReference<PixelAdventure>, KeyboardHandler {
  String character;

  Player({this.character = 'Ninja Frog', position}) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  final double stepTime = 0.05;

  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  List<CollisionBlock> collisionBlocks = [];
  final double _gravity = 9.8;
  final double _jumpForce = 500;
  final double _terminalVelocity = 300;
  bool isOnGround = false;
  bool toJumped = false;

  PlayerHitbox hitBox =
      PlayerHitbox(offsetX: 10, offsetY: 4, width: 14, height: 28);

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    debugMode = true;
    add(RectangleHitbox(
        position: Vector2(hitBox.offsetX, hitBox.offsetY),
        size: Vector2(hitBox.width, hitBox.height)));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMovement(dt);
    _checkHrizontalCollision();
    _applyGravity(dt);
    _checkVerticalCollision();

    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isKeyLeft = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);

    final isKeyRight = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isKeyRight ? 1 : 0;
    horizontalMovement += isKeyLeft ? -1 : 0;

    print('onKeyEvent $horizontalMovement isKeyRight $isKeyRight');

    toJumped = keysPressed.contains(LogicalKeyboardKey.space);

    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);
    jumpingAnimation = _spriteAnimation('Jump', 1);
    fallingAnimation = _spriteAnimation('Fall', 1);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation
    };

    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amout) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/$character/$state (32x32).png'),
        SpriteAnimationData.sequenced(
            amount: amout, stepTime: stepTime, textureSize: Vector2.all(32)));
  }

  void _updatePlayerMovement(dt) {
    if (toJumped && isOnGround) _playerJump(dt);
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    toJumped = false;
    isOnGround = false;
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    }

    if (velocity.x != 0) playerState = PlayerState.running;
    if (velocity.y > 0) playerState = PlayerState.falling;
    if (velocity.y < 0) playerState = PlayerState.jumping;
    current = playerState;
  }

  void _checkHrizontalCollision() {
    for (var block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitBox.width - hitBox.offsetX;
            break;
          }

          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitBox.width + hitBox.offsetX;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollision() {
    for (var block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitBox.height - hitBox.offsetY;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            //落地
            velocity.y = 0;
            position.y = block.y - hitBox.height - hitBox.offsetY;
            isOnGround = true;
            break;
          }

          if (velocity.y < 0) {
            //跳跃撞头了
            velocity.y = 0;
            position.y = block.y + block.height - hitBox.offsetY;
            isOnGround = false;
            break;
          }
        }
      }
    }
  }
}
