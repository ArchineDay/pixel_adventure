import 'dart:async';
import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:pixel_adventure/levels/level.dart';

class PixelAdventure extends FlameGame<Level> {
  PixelAdventure()
      : super(
            camera: CameraComponent.withFixedResolution(
                width: 640,
                height: 360,
                viewfinder: Viewfinder()..anchor = Anchor.topLeft),
            world: Level(levelName: 'level-02'));

  @override
  Color backgroundColor() => const Color(0xff211f30);

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    return super.onLoad();
  }
}
