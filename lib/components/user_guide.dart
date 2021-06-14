import 'package:battleship/components/image_component.dart';
import 'package:battleship/resources/images.dart';
import 'package:flame/components.dart';

class UserGuide extends ImageComponent {
  /// Defines the user guide text.
  UserGuide()
      : super(
          image: ImagePaths.userGuide,
          srcSize: Vector2(247, 62),
          imageSize: Vector2(247, 62),
        );

  @override
  void update(double dt) {
    super.update(dt);

    this.shouldRender = gameRef.gameStarted;
    this.size = this.shouldRender ? this.initialSize : Vector2.zero();
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);

    double width =
        (gameRef.planeData.mainAxisCount - 4) * gameRef.planeData.quadrantSize;

    size = Vector2(width, width / aspectRatio);
    position = Vector2((gameSize.x - width) / 2, gameSize.y * 0.83);
    initialPosition = position;
    initialSize = size;
  }
}
