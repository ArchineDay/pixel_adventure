import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/actors/player.dart';

class Level extends World {
  late TiledComponent level;
  final String levelName;
  final Player player;
  Level({required this.levelName, required this.player});

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    final spwanPointLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    for (final spawnpoint in spwanPointLayer!.objects) {
      switch (spawnpoint.class_) {
        case 'Player':
          player.position = Vector2(spawnpoint.x, spawnpoint.y);
          add(player);
          break;
        default:
      }
    }
    add(level);

    return super.onLoad();
  }
}
