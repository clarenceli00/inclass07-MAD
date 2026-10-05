import 'package:flutter/material.dart';

void main() => runApp(const PetApp());

class PetApp extends StatelessWidget {
  const PetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Pet App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const PetCareApp(),
    );
  }
}

class PetCareApp extends StatefulWidget {
  const PetCareApp({super.key});

  @override
  State<PetCareApp> createState() => _PetAppState();
}

class _PetAppState extends State<PetCareApp> {
  int _happiness = 50; // all states from 0 to 100
  int _hunger = 50; // 0 means full; 100 means starving.
  int _energy = 70;
  int _clampMeter(int value) => value.clamp(0, 100).toInt();
  Timer? _hungerTimer;
  Timer? _highMoodTimer;
  bool _gameOver = false;
  bool _hasWon = false;

  void _updateOutcome() {
    if (_gameOver || _hasWon) return;

    if (_hunger == 100 && _happiness <= 10) {
      _highMoodTimer?.cancel();
      _hungerTimer?.cancel();
      setState(() => _gameOver = true);
      return;
    }

    if (_happiness <= 80) {
      _highMoodTimer?.cancel();
      _highMoodTimer = null;
      return;
    }

    _highMoodTimer ??= Timer(const Duration(seconds: 20), () {
      _highMoodTimer = null;
      if (!mounted || _gameOver || _happiness <= 80) return;
      setState(() => _hasWon = true);
      _hungerTimer?.cancel();
    });
  }

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
  }

  void _startHungerTimer() {
    _hungerTimer?.cancel();
    _hungerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted || _gameOver || _hasWon) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_hunger + 5 > 100) {
          _hunger = 100;
          _happiness = _clampMeter(_happiness - 20);
        } else {
          _hunger += 5;
        }
      });
      _updateOutcome();
    });
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    _highMoodTimer?.cancel();
    super.dispose();
  }

  void _feedPet() {
    if (_gameOver || _hasWon) return;

    final nextHunger = _clampMeter(_hunger - 10);
    final happinessChange = nextHunger < 30 ? -20 : 10;
    final nextHappiness = _clampMeter(_happiness + happinessChange);

    setState(() {
      _hunger = nextHunger;
      _happiness = nextHappiness;
    });
    _updateOutcome();
  }

  void _playPet() {
    if (_gameOver || _hasWon) return;
    setState(() {
      _happiness = _clampMeter(_happiness + 10);
      _hunger = _clampMeter(_hunger + 5);
      _energy = _clampMeter(_energy - 10);
    });
    _updateOutcome();
  }

  void _restPet() {
    if (_gameOver || _hasWon) return;
    setState(() {
      _energy = _clampMeter(_energy + 20);
    });
    _updateOutcome();
  }

  void _resetStats() {
    _highMoodTimer?.cancel();
    _highMoodTimer = null;
    setState(() {
      _happiness = 50;
      _hunger = 50;
      _energy = 70;
      _gameOver = false;
      _hasWon = false;
    });
    _startHungerTimer();
  }

  Widget _levelBar(String label, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: $value/100'),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: value / 100,
            semanticsLabel: label,
            semanticsValue: '$value',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Digital Pet App')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: CustomPaint(
                    painter: PetPresenter(
                      //THIS IS THE WIDGET WHERE THE PET IS CREATED
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _levelBar('Happiness', _happiness),
                _levelBar('Hunger', _hunger),
                _levelBar('Energy', _energy),
                if (_gameOver) const Text('Game over! Reset to try again.'),
                if (_hasWon) const Text('You won! Reset to play again.'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: _gameOver || _hasWon ? null : _playPet,
                      child: const Text('Play'),
                    ),
                    ElevatedButton(
                      onPressed: _gameOver || _hasWon ? null : _feedPet,
                      child: const Text('Feed'),
                    ),
                    ElevatedButton(
                      onPressed: _gameOver || _hasWon ? null : _restPet,
                      child: const Text('Rest'),
                    ),
                    ElevatedButton(
                      onPressed: _resetStats,
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PetPresenter extends CustomPainter {
  PetPresenter(); // required variables to "paint" the pet

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
