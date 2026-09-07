import 'dart:convert';

import 'package:openci_shared/openci_shared.dart';
import 'package:test/test.dart';

void main() {
  test(
    'UserDevice preserves ownership, device identifiers, and timestamps',
    () {
      final json = {
        'id': 'device-1',
        'userId': 'user-1',
        'teamId': 'team-1',
        'udid': '00008030-000A1D8A2D3C4E5F',
        'deviceProduct': 'iPhone15,2',
        'deviceOsVersion': '18.0',
        'createdAt': '2026-09-07T00:00:00.000Z',
        'updatedAt': '2026-09-07T00:01:00.000Z',
      };

      final device = UserDevice.fromJson(json);

      expect(device.id, 'device-1');
      expect(device.userId, 'user-1');
      expect(device.teamId, 'team-1');
      expect(device.udid, '00008030-000A1D8A2D3C4E5F');
      expect(device.deviceProduct, 'iPhone15,2');
      expect(device.deviceOsVersion, '18.0');
      expect(device.createdAt, DateTime.utc(2026, 9, 7));
      expect(device.updatedAt, DateTime.utc(2026, 9, 7, 0, 1));
      expect(jsonDecode(jsonEncode(device)), json);
    },
  );
}
