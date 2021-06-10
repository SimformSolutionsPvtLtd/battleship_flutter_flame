import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

extension TextDrawUtility on Canvas {
  /// Utility function that paints the text on canvas.
  ///
  void drawText(
    String text,
    Offset offset,
    TextStyle style, {
    TextAlign textAlign = TextAlign.center,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    TextPainter(
      text: TextSpan(
        text: text,
        style: style,
      ),
      textAlign: textAlign,
      textDirection: textDirection,
    )
      ..layout()
      ..paint(this, offset);
  }
}

extension VectorExtension on Offset {
  /// Get [Vector2] object from [Offset] value.
  ///
  Vector2 getVector() => Vector2(this.dx, this.dy);
}
