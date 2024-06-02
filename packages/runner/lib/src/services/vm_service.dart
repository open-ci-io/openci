import 'package:runner/src/services/tart/tart_service.dart';

class VMService {
  VMService(this._tartService);

  final TartService _tartService;

  Future<void> stopVM(String workingVMName) async {
    await _tartService.stop(workingVMName);
    await _tartService.delete(workingVMName);
  }
}
