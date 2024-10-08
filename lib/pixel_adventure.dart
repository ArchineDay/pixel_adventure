import 'dart:async';
import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/component/player.dart';
import 'package:pixel_adventure/component/level.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xff211f30);
  late JoystickComponent joystick;
  late SpriteButtonComponent jumpButton;
  Player player = Player(character: 'Ninja Frog');

  bool showJoystick = true;

  @override
  FutureOr<void> onLoad() async {
    world = Level(player: player, levelName: 'level-01');
    camera = CameraComponent.withFixedResolution(
      width: 640,
      height: 360,
      viewfinder: Viewfinder()
        ..anchor = Anchor.topLeft,
    );

    await images.loadAllImages();
    if (showJoystick) {
      addJoyStick();
      addButton();
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
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;

      default:
      //idle
        player.horizontalMovement = 0;
        break;
    }
  }

  void addButton() {
    jumpButton = SpriteButtonComponent(
      button: Sprite(images.fromCache('HUD/Joystick.png')),
      buttonDown: Sprite(images.fromCache('HUD/Knob.png')),
      position: Vector2(468, 276),
      size: Vector2(64, 64),
      onPressed: () {
        player.toJumped = true;
        print('Button pressed!');
      },
    );
    camera.viewport.add(jumpButton);

  }
}
