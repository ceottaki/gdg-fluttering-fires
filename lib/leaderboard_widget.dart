import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdgflutter_demo/game_state.dart';
import 'package:provider/provider.dart';

class LeaderBoard extends StatelessWidget {
  const LeaderBoard({super.key});
  //TODO STEP 7: Replace with _LeaderBoard build method
  @override
  Widget build(BuildContext context) {
    return const Placeholder(fallbackHeight: 200);
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
