import 'dart:async';
import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/actors/player.dart';
import 'package:pixel_adventure/levels/level.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xff211f30);
  late JoystickComponent joystick;
  Player player = Player(character: 'Ninja Frog');

  bool showJoystick = false;

  @override
  FutureOr<void> onLoad() async {
    world = Level(player: player, levelName: 'level-02');
    camera = CameraComponent.withFixedResolution(
      width: 640,
      height: 360,
      viewfinder: Viewfinder()..anchor = Anchor.topLeft,
    );

    await images.loadAllImages();
    if (showJoystick) {
      addJoyStick();
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoyStick() {
    joystick = JoystickComponent(
      position: Vector2(64, 296),
      size: 32,
      knob: SpriteComponent(sprite: Sprite(images.fromCache('HUD/Knob.png'))),
      background:
          SpriteComponent(sprite: Sprite(images.fromCache('HUD/Joystick.png'))),
    );
    camera.viewport.add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.playerDirection = PlayerDirection.left;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.playerDirection = PlayerDirection.right;
        break;

      default:
        //idle
        player.playerDirection = PlayerDirection.none;
        break;
    }
  }
}
