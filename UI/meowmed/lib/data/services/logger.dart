import 'package:logger/logger.dart';

class LogHandler {
  factory LogHandler() => _instance;
  LogHandler._internal();
  static final LogHandler _instance = LogHandler._internal();

  List<String> logMessages = [];

  log(String log) {
    if (log.length > 2000) {
      logMessages.removeAt(0);
    }
    final dateTimeNow = DateTime.now();
    final newLogMessage =
        "${dateTimeNow.hour}:${dateTimeNow.minute}:${dateTimeNow.second} -> $log";
    logMessages.add(newLogMessage);
    logger.i(log);
  }

  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 0, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: false, // Should each log print contain a timestamp
    ),
  );
}
