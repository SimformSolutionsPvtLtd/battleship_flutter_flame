import 'dart:ui';

import 'package:battleship/components/quadrant.dart';
import 'package:battleship/components/ship.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

class QuadrantPlaneData {
  /// Number of quadrants in single row.
  ///
  final int mainAxisCount;

  /// Total quadrants to display on this plane.
  ///
  final int totalQuadrants;

  /// Border of the quadrants.
  ///
  final BorderSide border;

  /// Size of the quadrant.
  /// Quadrant will be a square shape so height and width will be same.
  ///
  final double quadrantSize;

  /// TextStyle for coordinates
  ///
  final TextStyle coordinatesTextStyle;

  /// Defines the position of the quadrant plane
  /// excluding coordinates.
  ///
  late final Vector2 position;

  /// Size of the quadrant plane.
  /// excluding coordinates.
  ///
  late final Vector2 size;

  /// Returns the area of the quadrant plane as [Rect] object.
  Rect get area => position & size;

  /// List of Object of quadrants.
  ///
  List<Quadrant> quadrants = [];

  /// List of ships to put on this quadrant plane.
  ///
  List<Ship> ships = [];

  /// Defines the quadrant plane data.
  ///
  QuadrantPlaneData({
    this.coordinatesTextStyle = const TextStyle(),
    this.mainAxisCount = 0,
    this.totalQuadrants = 0,
    this.border = const BorderSide(),
    this.quadrantSize = 0,
    Vector2? position,
    Vector2? size,
  }) {
    this.position = position ?? Vector2.zero();
    this.size = size ?? Vector2.zero();
  }

  /// returns the quadrant containing [coordinate].
  ///
  Quadrant getQuadrantWithCoordinate(Vector2 coordinate) {
    if (!this.area.contains(coordinate.toOffset())) return Quadrant.empty();
    print(
        "Column: ${((coordinate.x - this.position.x) / this.quadrantSize).round()} Row: ${((coordinate.y - this.position.y) / this.quadrantSize).round()}");
    int index = (this.mainAxisCount *
            ((coordinate.y - this.position.y) / this.quadrantSize).floor()) +
        ((coordinate.x - this.position.x) / this.quadrantSize).floor();

    if (index >= this.quadrants.length) return Quadrant.empty();

    return index < this.quadrants.length
        ? this.quadrants[index]
        : Quadrant.empty();
  }

  /// Returns new [QuadrantPlaneData] with updated data.
  ///
  QuadrantPlaneData copyWith({
    int? mainAxisCount,
    int? totalQuadrants,
    BorderSide? border,
    Vector2? size,
    TextStyle? coordinatesTextStyle,
    Vector2? position,
    double? quadrantSize,
  }) =>
      QuadrantPlaneData(
        coordinatesTextStyle: coordinatesTextStyle ?? this.coordinatesTextStyle,
        size: size ?? this.size,
        border: border ?? this.border,
        mainAxisCount: mainAxisCount ?? this.mainAxisCount,
        totalQuadrants: totalQuadrants ?? this.totalQuadrants,
        position: position ?? this.position,
        quadrantSize: quadrantSize ?? this.quadrantSize,
      )
        ..quadrants = this.quadrants
        ..ships = this.ships;
}
