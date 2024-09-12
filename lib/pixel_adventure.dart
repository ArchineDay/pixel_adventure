import 'dart:async';
import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:pixel_adventure/actors/player.dart';
import 'package:pixel_adventure/levels/level.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xff211f30);
  late JoystickComponent joystick;

  @override
  FutureOr<void> onLoad() async {
    world =
        Level(player: Player(character: 'Mask Dude'), levelName: 'level-02');
    camera = CameraComponent.withFixedResolution(
      width: 640,
      height: 360,
      viewfinder: Viewfinder()..anchor = Anchor.topLeft,
    );

    await images.loadAllImages();

    addJoyStick();
    return super.onLoad();
  }

  void addJoyStick() {
    joystick = JoystickComponent()
  }
}
