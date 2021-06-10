import 'package:battleship/components/image_component.dart';
import 'package:battleship/resources/images.dart';
import 'package:flame/components.dart';

class GameTitle extends ImageComponent {
  /// Title of the game.
  ///
  /// ![Title](../../assets/images/title.png)
  GameTitle()
      : super(
          image: ImagePaths.title,
          srcSize: Vector2(683, 262),
          imageSize: Vector2(683, 262),
        );

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);

    double width =
        (gameRef.planeData.mainAxisCount - 2) * gameRef.planeData.quadrantSize;

    size = Vector2(width, width / aspectRatio);

    position = Vector2((gameSize.x - width) / 2, gameSize.y * 0.1);
  }
}
