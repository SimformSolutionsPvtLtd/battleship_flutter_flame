part of 'buttons.dart';

class ResetButton extends ImageButton {
  /// Start button of the app
  ///
  /// ![Start Button](../../assets/images/start.png)
  ResetButton()
      : super(
          srcSize: Vector2(200, 60),
          imageSize: Vector2(200, 60),
          image: ImagePaths.reset,
        );

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);

    double width =
        (gameRef.planeData.mainAxisCount - 5) * gameRef.planeData.quadrantSize;

    size = Vector2(width, width / aspectRatio);
    initialSize = size;
    position = Vector2((gameSize.x - width) / 2, gameSize.y * 0.85);
    initialPosition = position;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    print("Reset...");
    gameRef.resetGame();
    return false;
  }
}
