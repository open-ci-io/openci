import 'package:openci_shared/openci_shared.dart';
import 'package:test/test.dart';

class _Timestamp {
  _Timestamp(this.value);

  final DateTime value;

  DateTime toDate() => value;
}

class _BrokenTimestamp {
  DateTime toDate() => throw StateError('Invalid timestamp');
}

void main() {
  const converter = DateTimeConverter();

  test('parses an ISO timestamp with its timezone offset', () {
    expect(
      converter.fromJson('2026-09-07T09:30:00+09:00'),
      DateTime.utc(2026, 9, 7, 0, 30),
    );
  });

  test('supports a legacy Timestamp value', () {
    final value = DateTime.utc(2026, 9, 7, 0, 30);

    expect(converter.fromJson(_Timestamp(value)), value);
  });

  test('rejects an invalid timestamp string', () {
    expect(() => converter.fromJson('not a timestamp'), throwsFormatException);
  });

  for (final value in <Object>[123, <String>[], _BrokenTimestamp()]) {
    test('rejects unsupported or broken ${value.runtimeType}', () {
      expect(() => converter.fromJson(value), throwsArgumentError);
    });
  }

  test('serializes local dates as UTC without losing the instant', () {
    final value = DateTime.utc(2026, 9, 7, 0, 30, 15, 123, 456).toLocal();

    expect(converter.toJson(value), '2026-09-07T00:30:15.123456Z');
    expect(converter.fromJson(converter.toJson(value)), value.toUtc());
  });
}
