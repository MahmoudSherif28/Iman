import 'package:flutter/material.dart';

/// Represents a single prayer time entry for display purposes.
class PrayerTime {
  final String name;
  final IconData icon;
  final String time;
  final bool isCurrent;

  const PrayerTime({
    required this.name,
    required this.icon,
    required this.time,
    this.isCurrent = false,
  });
}

