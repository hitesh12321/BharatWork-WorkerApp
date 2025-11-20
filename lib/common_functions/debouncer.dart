import 'dart:async';

import 'package:flutter/material.dart';

class Debounce {
  final int milliseconds;
  // VoidCallback? action;
  Timer? timer;

  Debounce({required this.milliseconds, this.timer});

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
