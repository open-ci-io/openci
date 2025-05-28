import 'package:flutter/widgets.dart';

class ChangeIndexIntent extends Intent {
  const ChangeIndexIntent(this.index);
  final int index;
}

class LogoutIntent extends Intent {
  const LogoutIntent();
}

class PopIntent extends Intent {
  const PopIntent();
}
