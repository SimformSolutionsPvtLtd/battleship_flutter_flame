import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/assets.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/foundation.dart';

import '../game.dart';
import 'quadrant.dart';

/// Defines the ship component.
/// use [BaseGame.add()] method in class overriding [BaseGame] class to add ship into Game.
class Ship extends PositionComponent
    with Tapable, Draggable, HasGameRef<MyGame> {
  /// Id of the ship
  late String id;

  /// List of the images
  /// This list will be populated from single image provided.
  /// There will be four image in this list. Each defining rotation 0,90,180,270 degree with respect to x axis.
  List<Sprite> images = [];

  /// Defines previous quadrants to remove background paint of quadrants when ship is moved.
  List<Quadrant> _previousVariableQuadrants = [];

  /// Defines previous quadrants to check ships are overlapping or not.
  /// This will help to change colors of quadrants based on when ships are overlapped or not.
  List<Quadrant> _previousQuadrants = [];

  /// Defines current sprite.
  /// value of this variable will range from 0 to 3 defining image rotation 0, 90, 180 and 360 respectively.
  int currentSprite = 0;

  /// Defines whether ship is placed on this quadrants or not.
  /// If ship is placed [_previousQuadrants] will contains the list of quadrants on which current ship is placed.
  bool placed = false;

  /// Defines aspect ratio of image.
  double _imageRatio = 0;

  /// Defines the previous position of ship
  /// This will help to snap back ship if user is not allowed to put any place.
  Vector2 _previousPosition = Vector2.zero();

  Vector2 _initialPosition = Vector2.zero();

  Vector2 _initialSize = Vector2.zero();

  /// Returns the area of this ship with position of this ship.
  Rect get area => this.position & this.size;

  /// Defines the size of source image.
  late Vector2 imageSize;

  /// Path to source image.
  late String imageUrl;

  /// Previous size of the image. this will help to re appear ship when entire ship is destroyed.
  /// This will store size of the ship when game starts and then we will make size of this component to [Vector2.zero()] so this ship
  /// does not overlaps the containing quadrant and user can tap on that.
  Vector2 _shipPreviousSize = Vector2.zero();

  /// Defines the position of this ship
  @override
  Vector2 position = Vector2.zero();

  /// Defines the size of the ship
  /// value of this variable will be stored in _shipPreviousSize and set this variable to 0 when game starts.
  @override
  Vector2 size = Vector2.zero();

  /// Defines whether entire ship is destroyed or not.
  bool _destroyed = false;

  /// Defines whether entire ship is destroyed or not.
  bool get destroyed => _destroyed;

  /// Defines the ship component.
  /// use [BaseGame.add()] method in class overriding [BaseGame] class to add ship into Game.
  Ship({
    @required String? id,
    @required String? imageUrl,
    @required Vector2? imageSize,
    Vector2? position,
  }) {
    if (id == null)
      throw "Null id provided.";
    else
      this.id = id;
    this.imageUrl = imageUrl!;
    this.imageSize = imageSize!;
    this.position = position ?? this.position;
    this._initialPosition = this.position;
    this._imageRatio = imageSize.x / imageSize.y;
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);

    this.size = Vector2(gameRef.planeData.quadrantSize,
        gameRef.planeData.quadrantSize / _imageRatio);

    this._initialSize = this.size;
  }

  /// Populates [images] and set initial ship to display.
  @override
  Future<void> onLoad() async {
    List<Vector2> shipSizes = [
      Vector2(imageSize.x, imageSize.y),
      Vector2(imageSize.y, imageSize.x)
    ];
    images.addAll([
      await Sprite.load(
        imageUrl,
        srcPosition: Vector2.zero(),
        srcSize: shipSizes[0],
        images: Images(),
      ),
      await Sprite.load(
        imageUrl,
        srcPosition: Vector2(imageSize.x, imageSize.x),
        srcSize: shipSizes[1],
        images: Images(),
      ),
      await Sprite.load(
        imageUrl,
        srcPosition: Vector2(imageSize.x + imageSize.y, 0),
        srcSize: shipSizes[0],
        images: Images(),
      ),
      await Sprite.load(
        imageUrl,
        srcPosition: Vector2(imageSize.x, 0),
        srcSize: shipSizes[1],
        images: Images(),
      )
    ]);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (!gameRef.gameStarted || _destroyed) {
      images[currentSprite].render(
        canvas,
        position: position,
        size: this.size,
      );
    }
  }

  /// Rotates the ship by 90 degree when ship is tapped.
  /// This will not work when game is started.
  @override
  bool onTapUp(TapUpInfo event) {
    // Do nothing if game is started.
    // This will not allow user to rotate ship when game is started or ship is not placed.
    if (!placed || gameRef.gameStarted) return false;

    int newSprite = (currentSprite + 1) % 4;
    Vector2 oldSize = this.size;
    Vector2 oldPosition = this.position;

    this.size = Vector2(this.size.y, this.size.x);

    switch (newSprite) {
      case 0:
        this.position = Vector2(this.position.x, this.position.y);
        break;
      case 1:
        this.position = Vector2(
            this.position.x - this.size.x + gameRef.planeData.quadrantSize,
            this.position.y);
        break;
      case 2:
        this.position = Vector2(
            this.position.x + this.size.y - gameRef.planeData.quadrantSize,
            this.position.y - this.size.y + gameRef.planeData.quadrantSize);
        break;
      case 3:
        this.position = Vector2(this.position.x,
            this.position.y + this.size.x - gameRef.planeData.quadrantSize);
        break;
    }

    _arrangeShip();
    if (_isOverlapping()) {
      size = oldSize;
      position = oldPosition;
    } else {
      currentSprite = newSprite;
    }
    return false;
  }

  @override
  bool onDragStart(int pointerId, DragStartInfo info) {
    if (gameRef.gameStarted) return false;

    _previousPosition = position;

    return false;
  }

  @override
  bool onDragUpdate(int pointerId, DragUpdateInfo info) {
    if (gameRef.gameStarted) return false;
    position = Vector2(math.max(0, position.x + info.delta.global.x),
        math.max(0, position.y + info.delta.global.y));

    _paintQuadrants();
    return false;
  }

  @override
  bool onDragEnd(int pointerId, DragEndInfo info) {
    if (gameRef.gameStarted) return false;

    gameRef.planeData.quadrants.forEach((coordinate) {
      Vector2 referencePoint = Vector2.zero();
      if (currentSprite % 2 == 0)
        referencePoint = this.area.topCenter.toVector2();
      else
        referencePoint = this.area.centerLeft.toVector2();

      if (coordinate.area.containsPoint(referencePoint)) {
        this.position = coordinate.area.topLeft.toVector2();
        _arrangeShip();
        if (!_isOverlapping()) {
          placed = true;
        }
      }
    });

    if (placed) {
      printCoordinates();
      gameRef.showStartButton();
    } else {
      this.position = _previousPosition;
    }

    _previousVariableQuadrants.forEach((element) => element.setNeutral());

    return false;
  }

  void printCoordinates() {
    String placedQuadrant = "";
    _previousQuadrants.forEach((element) {
      placedQuadrant += (element.coordinate() + ": ${element.ship?.id}, ");
    });
    print("Placed Ships: $placedQuadrant");
  }

  /// Defines whether ship is overlapping on other ship or not
  /// This will check list of quadrant this ship occupies and check for [Quadrant().hasShip] flag.
  /// If event single flag is true then this function will return true else return false.
  bool _isOverlapping() {
    double top = this.area.top + 1;
    double bottom = this.area.bottom - 1;
    double left = this.area.left + 1;
    double right = this.area.right - 1;

    List<Quadrant> data = [];

    for (double i = top; i < bottom; i += gameRef.planeData.quadrantSize) {
      for (double j = left; j < right; j += gameRef.planeData.quadrantSize) {
        Quadrant quadrant =
            gameRef.planeData.getQuadrantWithCoordinate(Vector2(j, i));

        if (quadrant == Quadrant.empty()) {
          continue;
        }
        if (quadrant.hasShip && quadrant.ship != this) {
          return true;
        } else {
          data.add(quadrant);
        }
      }
    }

    _previousQuadrants.forEach((element) => element.moveShip());
    data.forEach((element) => element.placeShip(this));
    _previousQuadrants = data;

    return false;
  }

  /// This will arrange the ship on plane
  /// This function will rearrange ship when ship gets out size of plane.
  void _arrangeShip() {
    Offset topLeft = area.topLeft;
    Offset bottomRight = area.bottomRight;

    Offset minPositions = gameRef.planeData.area.topLeft;
    Offset maxPositions = gameRef.planeData.area.bottomRight;

    if (topLeft.dx < minPositions.dx) {
      this.position = Vector2(
          this.position.x + minPositions.dx - topLeft.dx, this.position.y);
    }

    if (topLeft.dy < minPositions.dy) {
      this.position = Vector2(
          this.position.x, this.position.y + minPositions.dy - topLeft.dy);
    }

    if (bottomRight.dx > maxPositions.dx) {
      this.position = Vector2(
          this.position.x - (bottomRight.dx - maxPositions.dx),
          this.position.y);
    }

    if (bottomRight.dy > maxPositions.dy) {
      this.position = Vector2(this.position.x,
          this.position.y - (bottomRight.dy - maxPositions.dy));
    }
  }

  /// This will paint quadrant background when ship is moved.
  /// This will paint quadrants with one of [Colors.red], [Colors.green] or [Colors.transparent] color.
  void _paintQuadrants() {
    double top = 0;
    double bottom = 0;
    double left = 0;
    double right = 0;

    if (currentSprite % 2 == 0) {
      top = this.area.topCenter.dy;
      bottom = this.area.bottomCenter.dy - 1;
      left = this.area.center.dx;
      right = this.area.centerRight.dx - 1;
    } else {
      top = this.area.centerLeft.dy;
      bottom = this.area.bottomCenter.dy - 1;
      left = this.area.centerLeft.dx;
      right = this.area.centerRight.dx - 1;
    }

    _previousVariableQuadrants.forEach((element) => element.setNeutral());

    _previousVariableQuadrants.clear();

    bool allowed = true;

    for (double i = top; i < bottom; i += gameRef.planeData.quadrantSize) {
      for (double j = left; j < right; j += gameRef.planeData.quadrantSize) {
        Quadrant quadrant =
            gameRef.planeData.getQuadrantWithCoordinate(Vector2(j, i));
        if (quadrant == Quadrant.empty()) {
          continue;
        }
        _previousVariableQuadrants.add(quadrant);
        if (quadrant.hasShip && quadrant.ship != this) {
          allowed = false;
        }
      }
    }

    if (allowed)
      _previousVariableQuadrants.forEach((element) => element.allowShip());
    else
      _previousVariableQuadrants.forEach((element) => element.rejectShip());
  }

  /// This function will check whether all the parts of the ship are destroyed or not.
  /// If all the part is destroyed then display the ship.
  void deriveDestroyed() {
    bool destroyed = true;
    _previousQuadrants.forEach((element) {
      destroyed &= element.shipDestroyed;
    });
    _destroyed = destroyed;
    if (_destroyed) {
      this.size = _shipPreviousSize;
    }
  }

  /// This will set size of the ship area to 0 so that user can tap on quadrants to destroy ship.
  void startGame() {
    _shipPreviousSize = this.size;
    this.size = Vector2.zero();
  }

  void reset() {
    position = _initialPosition;
    size = _initialSize;

    _previousQuadrants = [];
    _previousVariableQuadrants = [];

    placed = false;
    _destroyed = false;
    currentSprite = 0;
  }

  @override
  bool operator ==(Object other) {
    return other is Ship && this.id == other.id;
  }

  @override
  int get hashCode => super.hashCode;
}
