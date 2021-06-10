# Battleship Game ([Flutter Flame](https://pub.dev/packages/flame/versions/1.0.0-releasecandidate.11))

This is a two player game. You can learn more about rules and how to play this game on
[wikipedia](https://en.wikipedia.org/wiki/Battleship_(game)). In this game you will place given 4 types
of ships on desired positions and then start the game. You and your opponent will have turns one by one.
You have to destroy your opponent's all ships before he do. If you manage to destroy all the ships then you won.

This app include null safety support as well.

## Requirements

Make sure that you have all the requirements fulfilled and properly set for project execution.

- IDE: [`Android Studio 3.4+`](https://developer.android.com/studio) or [`VSCode`](https://code.visualstudio.com/download)
- [Flutter SDK (Master): 2.2.0+](https://flutter.dev/docs/get-started/install)
- Dart SDK: 2.12+ (flutter sdk will also provide dart sdk so no need to download it manually. just make sure version matches.)
- Working device or emulator (only if you want to execute [step 3](#3-run-app)).
- Working Internet Connection

## Build project

### 1. Install dependencies

```shell
flutter packages get
```

### 2. Build apk

```shell
# run this step only if you want to create an apk file and install it to multiple device else you can go for step 3.

flutter build apk
```

### 3. Run app

```shell
# run this step if you do not want to create apk and install app on device or emulator directly.

flutter run 
```

## Usage

``` shell
1. Install and Open game.
2. Place the ships on quadrants you choose.
3. Start the game.
4. Tap on the quadrants to destroy the ships.
5. If you manage to destroy all 4 ships, you won.
```

Here is an example,

![Demo Image](/readme_assets/demo_play.gif)

## Development

We have used [flame](https://pub.dev/packages/flame/versions/1.0.0-releasecandidate.11) package to develop this app.

### What is flame?

Flame is a modular Flutter game engine that provides a complete set of out-of-the-way solutions for games. It takes advantage of the powerful infrastructure provided by Flutter but simplifies the code you need to build your projects.

Flame provides simple yet effective game loop implementation, and the necessary functionalities that we need in a game. For instance; input, images, sprites, sprite sheets, animations, collision detection and a component system that we call Flame Component System (FCS for short).

you can learn more about flame and how to develop game in flame at [flame documentation](https://flame-engine.org/docs/#/).

### Why flame?

As defined in above section flame provides verity of components and functionalities that we can use to develop a 2D game. If we do the same thing using flutter components there are higher chances that it can become more complicated. Also there might be some performance issues.

Also if you have a prior experience with game engines developing game in flame becomes even easier.
