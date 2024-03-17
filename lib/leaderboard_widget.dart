import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdgflutter_demo/game_state.dart';
import 'package:provider/provider.dart';

class LeaderBoard extends StatelessWidget {
  const LeaderBoard({super.key});
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
        final listViewChildren = _gamesAsWidgets(snapshot.data!.docs, context);
        return Column(
          children: [
            Text(
              '🏆 Leaderboard 🏆',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Expanded(child: ListView(children: listViewChildren)),
          ],
        );
      },
    );
  }

  List<Widget> _gamesAsWidgets(
      List<QueryDocumentSnapshot<Object?>> games, BuildContext context) {
    final widgets = <Widget>[];
    for (var i = 0; i < games.length; ++i) {
      Map<String, dynamic> data = games[i].data()! as Map<String, dynamic>;
      final Widget leading;
      switch (i) {
        case 0:
          leading = Text('🥇', style: Theme.of(context).textTheme.displaySmall);
          break;
        case 1:
          leading = Text('🥈', style: Theme.of(context).textTheme.displaySmall);
          break;
        case 2:
          leading = Text('🥉', style: Theme.of(context).textTheme.displaySmall);
          break;
        default:
          leading = Text('  ${i + 1}. ',
              style: Theme.of(context).textTheme.titleLarge);
      }
      widgets.add(Card(
        elevation: 0,
        color: Colors.white.withOpacity(0.7),
        margin: const EdgeInsets.only(bottom: 4),
        child: ListTile(
          leading: leading,
          title: Text('${data['name']} has tapped ${data['taps']} times'),
        ),
      ));
    }
    return widgets;
  }
}
