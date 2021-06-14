import 'dart:ui';

import 'package:battleship/game.dart';
import 'package:battleship/models/quadrant_plane_data.dart';
import 'package:flame/components.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'ship.dart';

/// Defines a single quadrant square tile for [MyGame]
class Quadrant extends PositionComponent with Tapable, HasGameRef<MyGame> {
  /// Defines position of quadrant on screen
  late Vector2 position;

  /// Defines size of the quadrant
  late Vector2 size;

  /// Defines the decoration of quadrant plane
  late QuadrantPlaneData decoration;

  /// Defines area that this quadrant will occupies.
  late Rect area;

  /// Defines the id of this quadrant
  late int? id;

  Ship? _ship;

  /// Defines whether a ship is placed on this quadrant or not.
  bool get hasShip => _ship != null;

  /// If there is a ship on this quadrant then this will return reference to that ship object.
  Ship? get ship => _ship;

  /// Background color to display for quadrant
  /// Background color will be [Colors.red] when there is a destroyed ship or user
  /// is trying to place ship on quadrant that already has a ship.
  /// Background color will be [Colors.green] when user can place ship on hovering
  /// quadrant or during game play user hits the quadrant that does not have any ships.
  Color _backGroundColor = Colors.transparent;

  /// Defines the background color of quadrant.
  Color get backgroundColor => _backGroundColor;

  bool _shipDestroyed = false;

  /// Defines whether ship part on this quadrant is destroyed or not.
  bool get shipDestroyed => this.hasShip && _shipDestroyed;

  /// Constructor for [Quadrant]
  Quadrant({
    @required this.id,
    @required Vector2? position,
    QuadrantPlaneData? decoration,
  }) {
    id!;
    this.decoration = decoration ?? QuadrantPlaneData();
    this.position = position ?? Vector2.zero();
    this.size = Vector2.all(this.decoration.quadrantSize);
    this.area = this.position & this.size;
  }

  /// Creates a [Quadrant] with no data.
  factory Quadrant.empty() => Quadrant(id: -1, position: Vector2.zero());

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    area = this.position & this.size;
  }

  /// runs every time when [BaseGame.render] runs.
  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draws the background for quadrant only if it has a proper background color.
    if (this._backGroundColor != Colors.transparent) {
      canvas.drawRect(
        area,
        Paint()
          ..color = _backGroundColor
          ..style = PaintingStyle.fill,
      );
    }

    canvas.drawRect(
      area,
      Paint()
        ..strokeWidth = decoration.border.width
        ..color = decoration.border.color
        ..style = PaintingStyle.stroke,
    );
  }

  String coordinate() =>
      "${String.fromCharCode(id! % gameRef.planeData.mainAxisCount + 65)}"
      "${id! ~/ gameRef.planeData.mainAxisCount + 1}";

  /// Runs when user taps on quadrant this won't allows users to tap on already tapped quadrants.
  @override
  bool onTapUp(TapUpInfo event) {
    // Allows tap only if game is started or not already been tapped or explosion animation is not running.
    if (gameRef.gameStarted &&
        !gameRef.boomInProgress &&
        this._backGroundColor == Colors.transparent) {
      print(
          "Tapped on: ${String.fromCharCode(id! % gameRef.planeData.mainAxisCount + 65)}"
          "${id! ~/ gameRef.planeData.mainAxisCount + 1}, Game Started: ${gameRef.gameStarted}, "
          "Has Ship: $hasShip, Ship Data: ${this.ship?.id}");

      if (_ship == null) {
        _backGroundColor = Colors.green;
      } else if (!_shipDestroyed) {
        _shipDestroyed = true;
        _ship?.deriveDestroyed();
        gameRef.showBoomAnimation(this.position);
        _backGroundColor = Colors.red;
        gameRef.showResetButton();
      }
    }

    return false;
  }

  /// Change quadrant background to [Colors.green] to indicate user can place the ship or they have missed the ship during game play.
  void allowShip() => _backGroundColor = Colors.green;

  /// Change quadrant background to [Colors.red] to indicate user can not place ship on this quadrant or ship on this quadrant is destroyed.
  void rejectShip() => _backGroundColor = Colors.red;

  /// Change background back to [Colors.transparent].
  void setNeutral() => _backGroundColor = Colors.transparent;

  /// Place the ship on this quadrant
  void placeShip(Ship ship) => _ship = ship;

  /// Remove the ship from this quadrant
  void moveShip() => _ship = null;

  /// Destroy the ship if there is any.
  void destroyShip() {
    if (_ship != null) _shipDestroyed = true;
  }

  /// Resets the quadrant
  void reset() {
    _shipDestroyed = false;
    this.setNeutral();
    this.moveShip();
  }

  @override
  bool operator ==(Object other) =>
      other is Quadrant && this.id == other.id && this.area == other.area;

  @override
  int get hashCode => super.hashCode;
}
