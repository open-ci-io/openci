import 'package:dashboard/src/features/intent.dart';
import 'package:flutter/widgets.dart';

class ChangeIndexAction extends Action<ChangeIndexIntent> {
  ChangeIndexAction({required this.onIndexChanged});
  final void Function(int) onIndexChanged;

  @override
  void invoke(ChangeIndexIntent intent) {
    onIndexChanged(intent.index);
  }
}

class LogoutAction extends Action<LogoutIntent> {
  LogoutAction({required this.onLogout});
  final VoidCallback onLogout;

  @override
  Object? invoke(LogoutIntent intent) {
    onLogout();
    return null;
  }
}

class PopAction extends Action<PopIntent> {
  PopAction({required this.onPop});
  final VoidCallback onPop;

  @override
  Object? invoke(PopIntent intent) {
    onPop();
    return null;
  }
}

class CreateWorkflowAction extends Action<CreateWorkflowIntent> {
  CreateWorkflowAction({required this.callback});
  final VoidCallback callback;

  @override
  Object? invoke(CreateWorkflowIntent intent) {
    callback();
    return null;
  }
}
