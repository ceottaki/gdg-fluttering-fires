import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gdgflutter_demo/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GDG Flutter & Firebase Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'GDG Flutter & Firebase Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: const Column(
          children: <Widget>[
            Flexible(child: _Game()),
            SizedBox(height: 16),
            Flexible(child: _LeaderBoard()),
          ],
        ),
      ),
    );
  }
}

class _Game extends StatefulWidget {
  const _Game();
  @override
  State<_Game> createState() => _GameState();
}

class _GameState extends State<_Game> {
  final nameController = TextEditingController();
  static const gameDuration = 5.0;
  double gameTimeLeft = gameDuration;
  bool isPlaying = false;
  int taps = 0;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: nameController,
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
              onPressed: isPlaying ? null : _playGame,
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
        Text('${nameController.text} has tapped this many times:'),
        const SizedBox(height: 16),
        Text(
          '$taps',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 16),
        FilledButton(
            onPressed: isPlaying
                ? () {
                    setState(() {
                      ++taps;
                    });
                  }
                : null,
            child: const Icon(
              Icons.plus_one,
              size: 70,
            ))
      ],
    );
  }

  void _playGame() {
    if (nameController.text.isEmpty) {
      return;
    }
    setState(() {
      gameTimeLeft = gameDuration;
      isPlaying = true;
      taps = 0;
    });
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() => gameTimeLeft = gameDuration - timer.tick * 10 / 1000);
      if (timer.tick == gameDuration * 100) {
        setState(() {
          isPlaying = false;
        });
        timer.cancel();
        final userRef =
            FirebaseFirestore.instance.doc('games/${nameController.text}');
        userRef.set({
          'taps': taps,
          'name': nameController.text,
        });
      }
    });
  }
}

class _LeaderBoard extends StatefulWidget {
  const _LeaderBoard();

  @override
  State<_LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<_LeaderBoard> {
  final Stream<QuerySnapshot> _tapsStream = FirebaseFirestore.instance
      .collection('games')
      .orderBy('taps', descending: true)
      .limit(5)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _tapsStream,
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
