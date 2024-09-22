bool checkCollision(player, block) {
  final hitBox = player.hitBox;

  final playerWidth = hitBox.width;
  final playerHeigth = hitBox.height;
  final blockWidth = block.width;
  final blockHeigth = block.height;

  final playerX = player.scale.x > 0
      ? player.position.x + hitBox.offsetX
      : player.position.x - playerWidth - hitBox.offsetX; //左边的x

  final playerY = block.isPlatform
      ? player.position.y + hitBox.offsetY + playerHeigth
      : player.position.y + hitBox.offsetY;

  final blockX = block.position.x;
  final blockY = block.position.y;

  return (playerX + playerWidth > blockX && //右边
      playerX < blockWidth + blockX && //左边
      playerY < blockHeigth + blockY && //角色头部
      playerY + playerHeigth > blockY); //角色脚下
}
