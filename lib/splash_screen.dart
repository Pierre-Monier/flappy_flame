import 'package:flame/game.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';
import 'core/game.dart';

class SplashScreenGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {'/game': (context) => GameWidget(game: FlappyGame())},
        home: FlameSplashScreen(
          theme: FlameSplashTheme.white,
          onFinish: (BuildContext context) =>
              Navigator.pushNamed(context, '/game'),
        ));
  }
}
