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
  @override
  Widget build(BuildContext context) {
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
            const _NameAndGoRow(),
          ],
        ),
      ),
    );
  }
}

class _NameAndGoRow extends StatelessWidget {
  const _NameAndGoRow();
  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: _NameTextField()),
        SizedBox(width: 12),
        _GoButton(),
      ],
    );
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
  @override
  Widget build(BuildContext context) {
    final isStarting = context.select((GameState s) => s.isStarting);
    return SizedBox(
      height: 150,
      child: isStarting ? const _Countdown() : const _TapTapTap(),
    );
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
  @override
  Widget build(BuildContext context) {
    final isPlaying = context.select((GameState s) => s.isPlaying);
    return Stack(
      alignment: Alignment.center,
      children: [
        ConfettiWidget(
          confettiController: context.read<GameState>().confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          emissionFrequency: 1.0,
          shouldLoop: false,
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.purple
          ],
          createParticlePath: context.read<GameState>().drawStar,
        ),
        FilledButton(
          onPressed: isPlaying ? context.read<GameState>().tap : null,
          style: FilledButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
          ),
          child: const Icon(Icons.plus_one, size: 44),
        ),
      ],
    );
  }
}
