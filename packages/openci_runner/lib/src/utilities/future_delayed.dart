Future<void> wait({int minutes = 2}) async =>
    Future<void>.delayed(Duration(minutes: minutes));
