import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class GameState extends ChangeNotifier {
  final String gameName = 'Tap Madness';
  final nameController = TextEditingController();
  String get playerName => nameController.text;
  static const gameDuration = 5.0;
  double gameTimeLeft = gameDuration;
  bool isPlaying = false;
  bool isStarting = false;
  int taps = 0;
  final confettiController =
      ConfettiController(duration: const Duration(milliseconds: 1));

  //TODO Step 8: Replace with finishedGames initialization
  final Stream<QuerySnapshot> finishedGames = FirebaseFirestore.instance
      .collection('games')
      .orderBy('taps', descending: true)
      .limit(30)
      .snapshots();

  GameState() {
    nameController.addListener(notifyListeners);
  }

  @override
  void dispose() {
    nameController.dispose();
    confettiController.dispose();
    super.dispose();
  }

  Future<void> startGame() async {
    if (nameController.text.isEmpty) {
      return;
    }
    gameTimeLeft = gameDuration;
    taps = 0;
    isStarting = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 3));
    isStarting = false;
    isPlaying = true;
    notifyListeners();
    Timer.periodic(const Duration(milliseconds: 10), _gameTick);
  }

  void _gameTick(Timer timer) {
    gameTimeLeft = gameDuration - timer.tick * 10 / 1000;
    if (timer.tick >= gameDuration * 100) {
      _endGame(timer);
    }
    notifyListeners();
  }

  void _endGame(Timer timer) {
    isPlaying = false;
    timer.cancel();
    notifyListeners();
    final docRef = FirebaseFirestore.instance.collection('games').doc();
    docRef.set({
      'taps': taps,
      'name': nameController.text,
    });
  }

  void tap() {
    if (!isPlaying) return;
    ++taps;
    confettiController.play();
    notifyListeners();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
