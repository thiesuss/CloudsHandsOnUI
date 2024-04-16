import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void run(VoidCallback action) {
    // Cancel the timer if it's already running
    _timer?.cancel();
    // Restart the timer with a new duration
    _timer = Timer(delay, action);
  }
}