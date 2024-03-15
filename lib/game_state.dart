import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GameState extends ChangeNotifier {
  final String name = 'Tap Madness';
  final nameController = TextEditingController();
  String get playerName => nameController.text;
  final Stream<QuerySnapshot> finishedGames = FirebaseFirestore.instance
      .collection('games')
      .orderBy('taps', descending: true)
      .limit(30)
      .snapshots();
  static const gameDuration = 5.0;
  double gameTimeLeft = gameDuration;
  bool isPlaying = false;
  int taps = 0;

  GameState() {
    nameController.addListener(notifyListeners);
  }
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void playGame() {
    if (nameController.text.isEmpty) {
      return;
    }
    gameTimeLeft = gameDuration;
    isPlaying = true;
    taps = 0;
    notifyListeners();
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      gameTimeLeft = gameDuration - timer.tick * 10 / 1000;
      if (timer.tick == gameDuration * 100) {
        isPlaying = false;
        timer.cancel();
        final userRef =
            FirebaseFirestore.instance.doc('games/${nameController.text}');
        userRef.set({
          'taps': taps,
          'name': nameController.text,
        });
      }
      notifyListeners();
    });
  }

  void tap() {
    ++taps;
    notifyListeners();
  }
}
