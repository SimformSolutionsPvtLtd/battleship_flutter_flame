import 'package:battleship/components/image_component.dart';
import 'package:battleship/resources/images.dart';
import 'package:flame/components.dart';
import 'package:flame/gestures.dart';

class StartButton extends ImageButton {
  /// Start button of the app
  ///
  /// ![Start Button](../../assets/images/start.png)
  StartButton()
      : super(
          srcSize: Vector2(204, 59),
          imageSize: Vector2(204, 59),
          image: ImagePaths.start,
        ) {
    this.shouldRender = false;
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);

    double width =
        (gameRef.planeData.mainAxisCount - 5) * gameRef.planeData.quadrantSize;

    size = Vector2(width, width / aspectRatio);
    position = Vector2((gameSize.x - width) / 2, gameSize.y * 0.85);
  }

  @override
  void update(double dt) {
    super.update(dt);

    bool shouldRender = true;

    gameRef.planeData.ships.forEach((element) {
      shouldRender &= element.placed;
    });

    this.shouldRender = shouldRender;
    this.shouldRender &= !gameRef.gameStarted;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    gameRef.gameStarted = true;
    gameRef.planeData.ships.forEach(
      (element) => element.startGame(),
    );
    return false;
  }
}
