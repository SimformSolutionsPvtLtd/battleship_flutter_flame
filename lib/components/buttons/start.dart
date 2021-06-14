part of 'buttons.dart';

class StartButton extends ImageButton {
  /// Start button of the app
  ///
  /// ![Start Button](../../assets/images/start.png)
  StartButton()
      : super(
          srcSize: Vector2(204, 59),
          imageSize: Vector2(204, 59),
          image: ImagePaths.start,
        );

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);

    double width =
        (gameRef.planeData.mainAxisCount - 5) * gameRef.planeData.quadrantSize;

    size = Vector2(width, width / aspectRatio);
    position = Vector2((gameSize.x - width) / 2, gameSize.y * 0.85);

    initialPosition = position;
    initialSize = size;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    gameRef.gameStarted = true;
    this.hide();
    gameRef.planeData.ships.forEach(
      (element) => element.startGame(),
    );
    return false;
  }
}
