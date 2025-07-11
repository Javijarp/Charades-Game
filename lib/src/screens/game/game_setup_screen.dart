import 'package:flutter/material.dart';
import 'package:what/src/services/unlocked_orientation_mixin.dart';
import 'package:what/src/widgets/tempo_button.dart';
import 'package:what/src/services/game_settings.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';

// --- 4. Game Setup Screen ---
class GameSetupScreen extends StatefulWidget {
  const GameSetupScreen({super.key});

  @override
  _GameSetupScreenState createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen>
    with UnlockedOrientationMixin {
  Duration _selectedLocalDuration = const Duration(minutes: 1, seconds: 30);

  @override
  void initState() {
    super.initState();
    // Initialize local duration from global state on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectedLocalDuration = Provider.of<GameSettings>(
        context,
        listen: false,
      ).gameDuration;
      setState(() {}); // Rebuild to show initial duration
    });
  }

  void _showTimePicker(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: const Text(
          'CONFIRM',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        cancel: const Text('CANCEL', style: TextStyle(color: Colors.white70)),
        itemTextStyle: Theme.of(
          context,
        ).textTheme.headlineMedium!.copyWith(fontSize: 35),
        backgroundColor: Theme.of(context).cardColor,
      ),
      dateFormat: 'mm:ss',
      initialDateTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        0,
        _selectedLocalDuration.inMinutes,
        _selectedLocalDuration.inSeconds % 60,
      ),
      minDateTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        0,
        0,
        10,
      ), // Min 10 seconds
      maxDateTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        0,
        5,
        0,
      ), // Max 5 minutes
      onConfirm: (dateTime, List<int> selectedIndex) {
        setState(() {
          _selectedLocalDuration = Duration(
            minutes: dateTime.minute,
            seconds: dateTime.second,
          );
        });
        Provider.of<GameSettings>(
          context,
          listen: false,
        ).setGameDuration(_selectedLocalDuration);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Time set to ${_selectedLocalDuration.inMinutes}m ${_selectedLocalDuration.inSeconds % 60}s.',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameSettings = Provider.of<GameSettings>(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Setup'),
        backgroundColor: Theme.of(context).colorScheme.primary, // Blue
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isLandscape ? 20.0 : 40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Selected Category:',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.black87),
              ),
              SizedBox(height: isLandscape ? 8 : 10),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Go back to category selection
                },
                child: Text(
                  gameSettings.selectedCategory?.name ?? 'No Category Selected',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: isLandscape ? 32 : 40,
                    color: Theme.of(context).colorScheme.primary, // Blue
                    decoration: TextDecoration.underline,
                    decorationColor: Theme.of(
                      context,
                    ).colorScheme.tertiary, // Blue
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: isLandscape ? 20 : 30),
              Text(
                'Time per Round:',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.black87),
              ),
              SizedBox(height: isLandscape ? 8 : 10),
              GestureDetector(
                onTap: () => _showTimePicker(context),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isLandscape ? 20 : 25,
                    vertical: isLandscape ? 12 : 15,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    '${_selectedLocalDuration.inMinutes.toString().padLeft(2, '0')}:${(_selectedLocalDuration.inSeconds % 60).toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: isLandscape ? 48 : 60,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: isLandscape ? 30 : 40),
              TempoButton(
                text: 'START GAME',
                onPressed: gameSettings.selectedCategory != null
                    ? () {
                        gameSettings
                            .resetScore(); // Reset scores for a new game
                        Navigator.pushNamed(context, '/countdown');
                      }
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please select a category first.',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      },
                backgroundColor: gameSettings.selectedCategory != null
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey, // Red, disable if no category
              ),
            ],
          ),
        ),
      ),
    );
  }
}
