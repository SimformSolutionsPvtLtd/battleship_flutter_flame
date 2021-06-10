import 'dart:ui';

import 'package:battleship/resources/images.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game.dart';

void main() async {
  runApp(GameWidget<MyGame>(
    // main game object that defines game.
    game: MyGame(),
    textDirection: TextDirection.ltr,
    backgroundBuilder: (context) {
      // Draws the background of game.
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/${ImagePaths.background}"),
            fit: BoxFit.fill,
          ),
        ),
      );
    },
  ));
  await Flame.device.fullScreen();
}
