import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:gdgflutter_demo/game_state.dart';
import 'package:provider/provider.dart';

class Game extends StatelessWidget {
  const Game({super.key});
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _GameSetup(),
        SizedBox(height: 16),
        _PlayArea(),
      ],
    );
  }
}

class _GameSetup extends StatelessWidget {
  const _GameSetup();
  // TODO STEP 3: Replace with _GameSetup build method
  @override
  Widget build(BuildContext context) {
    return const Placeholder(fallbackHeight: 200);
  }
}

class _NameAndGoRow extends StatelessWidget {
  const _NameAndGoRow();
  // TODO STEP 4: Replace with _NameAndGoRow build method
  @override
  Widget build(BuildContext context) {
    return const Placeholder(fallbackHeight: 200);
  }
}

class _NameTextField extends StatelessWidget {
  const _NameTextField();
  @override
  Widget build(BuildContext context) {
    final isPlaying = context.select((GameState s) => s.isPlaying);
    return TextField(
      controller: context.read<GameState>().nameController,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      enabled: !isPlaying,
      decoration: const InputDecoration(
        labelText: 'Enter your name',
        isDense: true,
        border: OutlineInputBorder(),
      ),
    );
  }
}

class _GoButton extends StatelessWidget {
  const _GoButton();
  @override
  Widget build(BuildContext context) {
    final isPlaying = context.select((GameState s) => s.isPlaying);
    return FilledButton(
      onPressed: isPlaying ? null : context.read<GameState>().startGame,
      child: const Text('Go!'),
    );
  }
}

class _PlayArea extends StatelessWidget {
  const _PlayArea();
  // TODO STEP 5: Replace with _PlayArea build method
  @override
  Widget build(BuildContext context) {
    return const Placeholder(fallbackHeight: 200);
  }
}

class _Countdown extends StatelessWidget {
  const _Countdown();
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 90),
      child: AnimatedTextKit(
        isRepeatingAnimation: true,
        repeatForever: true,
        pause: Duration.zero,
        animatedTexts: [
          ScaleAnimatedText('3', duration: const Duration(milliseconds: 750)),
          ScaleAnimatedText('2', duration: const Duration(milliseconds: 750)),
          ScaleAnimatedText('1', duration: const Duration(milliseconds: 750)),
          ScaleAnimatedText('Go!', duration: const Duration(milliseconds: 750)),
        ],
      ),
    );
  }
}

class _TapTapTap extends StatelessWidget {
  const _TapTapTap();
  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _TimeLeftAndTaps(),
        SizedBox(height: 16),
        _TapButton(),
      ],
    );
  }
}

class _TimeLeftAndTaps extends StatelessWidget {
  const _TimeLeftAndTaps();
  @override
  Widget build(BuildContext context) {
    final gameTimeLeft = context.select((GameState s) => s.gameTimeLeft);
    final taps = context.select((GameState s) => s.taps);
    return Row(
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
    );
  }
}

class _TapButton extends StatelessWidget {
  const _TapButton();
  // TODO STEP 6: Replace with _TapButton build method
  @override
  Widget build(BuildContext context) {
    return const Placeholder(fallbackHeight: 44);
  }
}
