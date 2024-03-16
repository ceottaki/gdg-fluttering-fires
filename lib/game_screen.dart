import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:gdgflutter_demo/game_state.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final name = context.select((GameState s) => s.name);
    return Stack(
      children: [
        Image.asset(
          'assets/images/background.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('🎉 $name 🎉'),
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
          ),
          body: const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                _Game(),
                Divider(height: 64, thickness: 2),
                Expanded(child: _LeaderBoard()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Game extends StatelessWidget {
  const _Game();
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _WhoIsPlaying(),
        SizedBox(height: 16),
        _GameArea(),
      ],
    );
  }
}

class _WhoIsPlaying extends StatelessWidget {
  const _WhoIsPlaying();
  @override
  Widget build(BuildContext context) {
    final isPlaying = context.select((GameState s) => s.isPlaying);
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white.withOpacity(0.7),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Who\'s playing?',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: context.read<GameState>().nameController,
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    enabled: !isPlaying,
                    decoration: const InputDecoration(
                      labelText: 'Enter your name',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed:
                      isPlaying ? null : context.read<GameState>().startGame,
                  child: const Text('Go!'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GameArea extends StatelessWidget {
  const _GameArea();
  @override
  Widget build(BuildContext context) {
    final isPlaying = context.select((GameState s) => s.isPlaying);
    final isStarting = context.select((GameState s) => s.isStarting);
    final gameTimeLeft = context.select((GameState s) => s.gameTimeLeft);
    final taps = context.select((GameState s) => s.taps);
    return SizedBox(
      height: 150,
      child: isStarting
          ? DefaultTextStyle(
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(fontSize: 90),
              child: AnimatedTextKit(
                isRepeatingAnimation: true,
                repeatForever: true,
                pause: Duration.zero,
                animatedTexts: [
                  ScaleAnimatedText('3', duration: Duration(milliseconds: 750)),
                  ScaleAnimatedText('2', duration: Duration(milliseconds: 750)),
                  ScaleAnimatedText('1', duration: Duration(milliseconds: 750)),
                  ScaleAnimatedText('Go!',
                      duration: Duration(milliseconds: 750)),
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Time: ',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      gameTimeLeft.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Taps: $taps',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ConfettiWidget(
                      confettiController:
                          context.read<GameState>().confettiController,
                      blastDirectionality: BlastDirectionality.explosive,
                      emissionFrequency: 1.0,
                      shouldLoop: false,
                      colors: const [
                        Colors.green,
                        Colors.blue,
                        Colors.pink,
                        Colors.orange,
                        Colors.purple
                      ], // manually specify the colors to be used
                      createParticlePath: context
                          .read<GameState>()
                          .drawStar, // define a custom shape/path.
                    ),
                    FilledButton(
                      onPressed:
                          isPlaying ? context.read<GameState>().tap : null,
                      style: FilledButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                      ),
                      child: const Icon(Icons.plus_one, size: 44),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class _LeaderBoard extends StatelessWidget {
  const _LeaderBoard();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: context.read<GameState>().finishedGames,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Align(
            alignment: Alignment.center,
            child: LinearProgressIndicator(),
          );
        }
        final listViewChildren = <Widget>[];
        final games = snapshot.data!.docs;
        for (var i = 0; i < games.length; ++i) {
          Map<String, dynamic> data = games[i].data()! as Map<String, dynamic>;
          final Widget leading;
          switch (i) {
            case 0:
              leading =
                  Text('🥇', style: Theme.of(context).textTheme.displaySmall);
              break;
            case 1:
              leading =
                  Text('🥈', style: Theme.of(context).textTheme.displaySmall);
              break;
            case 2:
              leading =
                  Text('🥉', style: Theme.of(context).textTheme.displaySmall);
              break;
            default:
              leading = Text('  ${i + 1}. ',
                  style: Theme.of(context).textTheme.titleLarge);
          }
          listViewChildren.add(Card(
            elevation: 0,
            color: Colors.white.withOpacity(0.7),
            margin: const EdgeInsets.only(bottom: 4),
            child: ListTile(
              leading: leading,
              title: Text('${data['name']} has tapped ${data['taps']} times'),
            ),
          ));
        }
        return Column(
          children: [
            Text(
              '🏆 Leaderboard 🏆',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(children: listViewChildren),
            ),
          ],
        );
      },
    );
  }
}
