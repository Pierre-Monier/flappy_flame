import 'package:flame/game.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';
import './my_game.dart';

class SplashScreenGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {'/game': (context) => GameWidget(game: MyGame())},
        home: FlameSplashScreen(
          theme: FlameSplashTheme.white,
          onFinish: (BuildContext context) =>
              Navigator.pushNamed(context, '/game'),
        ));
  }
}
