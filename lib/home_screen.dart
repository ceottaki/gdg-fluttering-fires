import 'package:flutter/material.dart';
import 'package:gdgflutter_demo/game_state.dart';
import 'package:gdgflutter_demo/game_widget.dart';
import 'package:gdgflutter_demo/leaderboard_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameName = context.select((GameState s) => s.gameName);
    return Stack(
      children: [
        const _BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('🎉 $gameName 🎉'),
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
          ),
          body: const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Game(),
                Divider(height: 64, thickness: 2),
                Expanded(child: LeaderBoard()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage();
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/background.png',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}