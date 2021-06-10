import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:battleship/components/coordinate.dart';
import 'package:battleship/components/quadrant.dart';
import 'package:battleship/components/ship.dart';
import 'package:battleship/components/start_button.dart';
import 'package:battleship/components/title.dart';
import 'package:battleship/components/user_guide.dart';
import 'package:battleship/models/quadrant_plane_data.dart';
import 'package:battleship/resources/images.dart';
import 'package:flame/components.dart' hide Timer;
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

/// [MyGame] is a core class of this project. It will be used as soon as application is started.
/// This will render all the required components of game.
class MyGame extends BaseGame
    with HasDraggableComponents, HasTapableComponents {
  /// Defines the game object.
  MyGame();

  /// Count of the numbers of quadrants in one row.
  int _horizontalQuadrantCount = 10;

  /// Defines the data of plane like starting offset number of quadrants, size of single quadrant etc.
  ///
  QuadrantPlaneData planeData = QuadrantPlaneData();

  /// Defines whether the game is started or not. When user presses on [StartButton()] this flag will be set to true.
  ///
  bool gameStarted = false;

  /// Stores the size of the screen.
  Vector2 screenSize = Vector2.zero();

  /// This variable stores the value of [math.min(screenSize.x, screenSize.y)]
  ///
  double referenceSize = 0;

  /// This variable stores the value of [math.max(screenSize.x, screenSize.y)]
  ///
  double complementSize = 0;

  /// Size of coordinates markings that are starting from A for horizontal and 1 for vertical.
  ///
  double coordinateSize = 0;

  late Sprite title;

  /// Defines the explosion animation displayed when user taps on quadrant which contains a ship.
  ///
  late SpriteAnimation _boomAnimation;

  /// Offset of the animation
  ///
  ///
  Vector2 _animationOffset = Vector2.zero();

  /// Defines that explosion animation is in progress or not.
  ///
  bool boomInProgress = false;

  /// Animation duration in seconds.
  ///
  double animationDuration = 1.5;

  /// Defines extra size that animation will take
  /// final animation size will be [QuadrantPlaneData.quadrantSize + MyGame._animationExtraSize]
  ///
  double _animationExtraSize = 0;

  /// final animation size of animation
  ///
  Vector2 _animationSize = Vector2.zero();

  /// Runs every time when game resize.
  ///
  @override
  void onResize(Vector2 size) {
    super.onResize(size);

    this.screenSize = size;

    this.referenceSize = math.min(size.x, size.y);
    this.complementSize = math.max(size.x, size.y);

    double tileSize = referenceSize / 100;

    double referenceOffsetBack = tileSize * 5;
    coordinateSize = tileSize * 6.5;
    double referenceOffsetFront = referenceOffsetBack + coordinateSize;
    double quadrantPlaneSize =
        referenceSize - referenceOffsetBack - referenceOffsetFront;

    double quadrantSize = quadrantPlaneSize / _horizontalQuadrantCount;

    // Set Quadrant size.
    planeData = planeData.copyWith(
      quadrantSize: quadrantSize,
      position: Vector2((size.x - quadrantPlaneSize + coordinateSize) / 2,
          (size.y - quadrantPlaneSize + coordinateSize) / 2),
      size: Vector2(_horizontalQuadrantCount * quadrantSize,
          _horizontalQuadrantCount * quadrantSize),
    );

    _animationExtraSize = planeData.quadrantSize / 2;
    _animationSize = Vector2.all(planeData.quadrantSize + _animationExtraSize);
  }

  /// Runs when game is first loaded.
  /// This methods defines all the components displayed in this game.
  ///
  /// This method will add quadrants, coordinates, start button, user guide and ships in game and place then at their default place.
  ///
  @override
  Future<void> onLoad() async {
    title = await Sprite.load(
      "title.png",
      srcPosition: Vector2.zero(),
      srcSize: Vector2(683, 262),
    );

    _boomAnimation = await _getBoomAnimation();

    planeData = planeData.copyWith(
      totalQuadrants: 100,
      mainAxisCount: _horizontalQuadrantCount,
      border: BorderSide(
        color: Colors.white,
        width: 1.0,
      ),
      coordinatesTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
      ),
    );

    _drawQuadrantSquares();

    _addShips();

    add(GameTitle());
    add(StartButton());
    add(UserGuide());
  }

  /// This method will run continuously after certain interval of time.
  /// This method will call [SpriteAnimation.update()] method if [boomInProgress] is true.
  ///
  @override
  void update(double dt) {
    super.update(dt);
    if (boomInProgress) {
      _boomAnimation.update(dt);
    }
  }

  /// This method will render [_boomAnimation] if [boomInProgress] is true.
  /// Same method will also render all the components that are added in this [Game] using [BaseGame.add] method.
  ///
  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (boomInProgress) {
      _boomAnimation.getSprite().render(
            canvas,
            position: _animationOffset,
            size: _animationSize,
          );
    }
  }

  /// This method will add all four types of ships into game.
  ///
  void _addShips() {
    Ship ship = Ship(
      id: "2",
      imageUrl: ImagePaths.ship2,
      imageSize: Vector2(60, 120),
      position: Vector2(planeData.area.left * 4,
          screenSize.y - 20 - planeData.quadrantSize * 2),
    );

    add(ship);
    planeData.ships.add(ship);
    ship = Ship(
      id: "3",
      imageUrl: ImagePaths.ship3,
      imageSize: Vector2(60, 180),
      position: Vector2(planeData.area.left * 3,
          screenSize.y - 20 - planeData.quadrantSize * 3),
    );
    add(ship);
    planeData.ships.add(ship);

    ship = Ship(
      id: "4",
      imageUrl: ImagePaths.ship4,
      imageSize: Vector2(60, 240),
      position: Vector2(planeData.area.left * 2,
          screenSize.y - 20 - planeData.quadrantSize * 4),
    );
    add(ship);
    planeData.ships.add(ship);

    ship = Ship(
      id: "5",
      imageUrl: ImagePaths.ship5,
      imageSize: Vector2(60, 300),
      position: Vector2(
          planeData.area.left, screenSize.y - 20 - planeData.quadrantSize * 5),
    );
    add(ship);
    planeData.ships.add(ship);
  }

  /// This method will draw quadrant on game.
  ///
  void _drawQuadrantSquares() {
    for (int i = 0; i < planeData.totalQuadrants; i++) {
      int row = i % planeData.mainAxisCount;
      int column = i ~/ planeData.mainAxisCount;

      Rect rect = Rect.fromLTWH(
          planeData.area.left + row * planeData.quadrantSize,
          planeData.area.top + column * planeData.quadrantSize,
          planeData.quadrantSize,
          planeData.quadrantSize);

      Quadrant quadrant = Quadrant(
        position: Vector2(rect.left, rect.top),
        decoration: planeData,
        id: i,
      );
      planeData.quadrants.add(quadrant);
      add(quadrant);
    }

    double horizontalAlphabetsOffset = planeData.area.left - (coordinateSize);
    double verticalAlphabetsOffset =
        planeData.area.top + (planeData.quadrantSize * 0.35);

    for (int i = 0; i < planeData.mainAxisCount; i++) {
      int row = i % planeData.mainAxisCount;

      add(
        Coordinate(
          position: Vector2(horizontalAlphabetsOffset,
              verticalAlphabetsOffset + row * planeData.quadrantSize),
          coordinate: "${i + 1}",
          style: planeData.coordinatesTextStyle,
        ),
      );
    }

    double horizontalNumbersOffset =
        planeData.area.left + (planeData.quadrantSize * 0.35);
    double verticalNumbersOffset = planeData.area.top - coordinateSize;

    for (int i = 0; i < planeData.mainAxisCount; i++) {
      int row = i % planeData.mainAxisCount;

      add(
        Coordinate(
          position: Vector2(
              horizontalNumbersOffset + row * planeData.quadrantSize,
              verticalNumbersOffset),
          coordinate: String.fromCharCode(i + 65),
          style: planeData.coordinatesTextStyle,
        ),
      );
    }
  }

  /// Return explosion animation object.
  ///
  Future<SpriteAnimation> _getBoomAnimation() async {
    const columns = 8;
    const rows = 8;
    const frames = columns * rows;
    final spriteImage = await Sprite.load(ImagePaths.boom);
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: spriteImage.image,
      columns: columns,
      rows: rows,
    );
    final sprites = List<Sprite>.generate(frames, spriteSheet.getSpriteById);
    return SpriteAnimation.spriteList(sprites,
        stepTime: animationDuration / frames);
  }

  /// Will display explosion animation in game.
  /// This method will set [_boomInProgress] flag to true. so, [this.render] can
  /// render the animation and [this.update] can update animation state.
  /// this method will be called by quadrants when it is tapped and there is ship on that quadrant.
  ///
  void showBoomAnimation(Vector2 offset) {
    _animationOffset = offset - Vector2.all(_animationExtraSize / 2);
    boomInProgress = true;
    Timer(
        Duration(
          milliseconds: (animationDuration * 1000).toInt(),
        ), () {
      boomInProgress = false;
    });
  }
}
