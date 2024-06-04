import 'package:runner/src/services/build_job/workflow/workflow_model.dart';

class FlavorService {
  static String flavorArgument(
    WorkflowFlutterConfig flutterConfig,
  ) {
    final flavor = flutterConfig.flavor;
    final entryPoint = flutterConfig.entryPoint;

    var flavorArgument = '';
    if (flavor != 'none') {
      if (entryPoint != null) {
        flavorArgument = '--flavor $flavor --target=$entryPoint';
      } else {
        flavorArgument = '--flavor $flavor';
      }
    }
    return flavorArgument;
  }
}
