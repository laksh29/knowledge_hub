import 'package:flutter/foundation.dart';

void printLog(String message, {bool logInRelease = false}) {
  if (kDebugMode || logInRelease) {
    // ignore: avoid_print
    print("knowledge hub: $message");
  }
}
