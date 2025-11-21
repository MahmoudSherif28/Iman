import 'package:flutter/material.dart';
import 'package:iman/generated/l10n.dart';
import '../../data/models/azkar_model.dart';

class AzkarDetailScreen extends StatefulWidget {
  final AzkarItem azkarItem;

  const AzkarDetailScreen({Key? key, required this.azkarItem}) : super(key: key);

  @override
  State<AzkarDetailScreen> createState() => _AzkarDetailScreenState();
}

class _AzkarDetailScreenState extends State<AzkarDetailScreen> {
  late AzkarItem _azkarItem;

  @override
  void initState() {
    super.initState();
    _azkarItem = widget.azkarItem;
  }

  void _incrementCounter() {
    setState(() {
      _azkarItem.incrementCount();
    });
  }

  void _resetCounter() {
    setState(() {
      _azkarItem.resetCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    final isCompleted = _azkarItem.isCompleted();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.azkar_title),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Text(
                  _azkarItem.textKey,
                  style: const TextStyle(
                    fontSize: 24,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    '${_azkarItem.currentCount} / ${_azkarItem.count}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _resetCounter,
                        icon: const Icon(Icons.refresh),
                        label: Text(localizations.azkar_reset),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: isCompleted ? null : _incrementCounter,
                        icon: isCompleted
                            ? const Icon(Icons.check)
                            : const Icon(Icons.add),
                        label: Text(
                          isCompleted
                              ? localizations.azkar_complete
                              : localizations.azkar_counter,
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          backgroundColor:
                              isCompleted ? Colors.green : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}