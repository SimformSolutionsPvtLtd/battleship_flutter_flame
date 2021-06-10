import 'dart:ui';

import 'package:flame/assets.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/foundation.dart';

import '../game.dart';

/// Defines a single image component to display in game.
/// Override this class to create a new Image to display.
///
/// ``` dart
/// class NewImage extends ImageComponent{
///   ImageComponent() : super(
///     image: // path to image,
///   );
/// }
/// ```
class ImageComponent extends PositionComponent with HasGameRef<MyGame> {
  /// Sprite image to display
  late Sprite image;

  /// Defines where image will be displayed on screen.
  late Vector2 position;

  /// Defines the size of image displayed in screen.
  late Vector2 size;

  /// Defines whether image should be rendered or not.
  bool shouldRender = true;

  /// Path to source image.
  String imageSrc = "";

  /// Start position in image from where image will be taken.
  ///
  late Vector2 srcPosition;

  /// Defies the size of source image.
  /// This also defines how many pixels will be taken from source image.
  /// If actual size of image is 500 x 500, and srcPosition is [Vector2.zero()] and srcSize is [Vector2.all(200)]
  /// Then this class will consider 200 x 200 pixels starting from pixel 0.
  /// If you change srcPosition to [Vector2(10,20)] and let size be same, then this class will take 200 x 200 pixels starting from 10th pixes left and 20 pixels top.
  ///
  Vector2 srcSize = Vector2.zero();

  /// aspect ratio of actual image.
  ///
  double _aspectRatio = 0;

  /// returns aspect ratio of actual image.
  ///
  double get aspectRatio => _aspectRatio;

  /// Defines a single image component to display in game.
  /// Override this class to create a new Image to display.
  ///
  /// ``` dart
  /// class NewImage extends ImageComponent{
  ///   ImageComponent() : super(
  ///     image: // path to image,
  ///   );
  /// }
  /// ```
  ImageComponent({
    @required Vector2? srcSize,
    @required Vector2? imageSize,
    @required String? image,
    Vector2? position,
    Vector2? srcPosition,
  }) {
    this.size = imageSize ?? Vector2.zero();
    this.srcPosition = srcPosition ?? Vector2.zero();
    this.imageSrc = image ?? "";
    this.srcSize = srcSize ?? Vector2.zero();
    this.position = position ?? Vector2.zero();
    _aspectRatio = this.srcSize.x / this.srcSize.y;
  }

  @override
  Future<void> onLoad() async {
    image = await Sprite.load(
      imageSrc,
      srcSize: srcSize,
      srcPosition: srcPosition,
      images: Images(),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (shouldRender) {
      image.render(
        canvas,
        position: position,
        size: size,
      );
    }
  }
}

/// [ImageButton] has same functionality as [ImageComponent] with tap gesture detection.
class ImageButton extends ImageComponent with Tapable {
  /// This is constructor for [ImageButton].
  ImageButton({
    @required Vector2? srcSize,
    @required Vector2? imageSize,
    @required String? image,
    Vector2? position,
    Vector2? srcPosition,
  }) : super(
            srcSize: srcSize,
            imageSize: imageSize,
            image: image,
            position: position,
            srcPosition: srcPosition);
}
