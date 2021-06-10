import 'dart:ui';

import 'package:battleship/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

import '../extensions.dart';

/// [Coordinate] class is for drawing coordinates.
///
/// For [MyGame] vertical coordinates starts from 1 to 10 and horizontal coordinates starts from A to J.
/// This will be used just to create 1 to 10 and A to J markings for quadrant.
class Coordinate extends BaseComponent {
  /// Defines position of coordinate
  late Vector2 position;

  /// Defines size of coordinate
  late Vector2 size;

  /// Defines coordinate string.
  late String coordinate;

  /// Style for coordinate string.
  late TextStyle style;

  /// Constructor for drawing coordinates.
  Coordinate({
    @required Vector2? position,
    this.coordinate = "",
    this.style = const TextStyle(),
  }) {
    this.position = position ?? Vector2.zero();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawText(
      coordinate,
      position.toOffset(),
      style,
    );
  }
}
