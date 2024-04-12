import 'dart:async';

import 'package:meowmed/data/models/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RefreshTimer implements StatefullObj {
  Timer? refreshTimer;

  final Function() refreshFunction;

  RefreshTimer(this.refreshFunction);

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? refreshTimerActivated = prefs.getBool("refreshTimerActivated");
    int? refreshTimeSec = prefs.getInt("refreshTimeSec");
    if (refreshTimerActivated == null) {
      await prefs.setBool("refreshTimerActivated", false);
      refreshTimerActivated = false;
    }
    if (refreshTimeSec == null) {
      await prefs.setInt("refreshTimeSec", 30);
      refreshTimeSec = 30;
    }
    if (refreshTimerActivated) {
      refreshTimer = Timer.periodic(Duration(seconds: refreshTimeSec), (timer) {
        refreshFunction();
      });
    }
  }

  Future<void> dispose() async {
    refreshTimer?.cancel();
  }
}
