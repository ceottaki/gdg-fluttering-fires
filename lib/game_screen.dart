import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdgflutter_demo/game_state.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final name = context.select((GameState s) => s.name);
    return Scaffold(
      appBar: AppBar(
        title: Text('🎉 $name 🎉'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            Flexible(flex: 1, child: _Game()),
            Divider(height: 16, thickness: 2, color: Colors.purple),
            Flexible(flex: 1, child: _LeaderBoard()),
          ],
        ),
      ),
    );
  }
}

class _Game extends StatelessWidget {
  const _Game();
  @override
  Widget build(BuildContext context) {
    final playerName = context.select((GameState s) => s.playerName);
    final isPlaying = context.select((GameState s) => s.isPlaying);
    final gameTimeLeft = context.select((GameState s) => s.gameTimeLeft);
    final taps = context.select((GameState s) => s.taps);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: context.read<GameState>().nameController,
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
              onPressed: isPlaying ? null : context.read<GameState>().playGame,
              child: const Text('Go!'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          gameTimeLeft.toStringAsFixed(2),
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 16),
        Text('$playerName has tapped this many times:'),
        const SizedBox(height: 16),
        Text(
          '$taps',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 16),
        FilledButton(
            onPressed: isPlaying ? context.read<GameState>().tap : null,
            child: const Icon(
              Icons.plus_one,
              size: 70,
            ))
      ],
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
          return const Text("Loading leaderboard");
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text('${data['name']} has tapped ${data['taps']} times'),
            );
          }).toList(),
        );
      },
    );
  }
}
