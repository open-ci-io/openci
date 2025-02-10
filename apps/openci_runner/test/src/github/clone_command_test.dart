import 'package:openci_runner/src/github/git_clone.dart';
import 'package:test/test.dart';

void main() {
  group('cloneCommand', () {
    test('generates correct git clone command', () {
      const repoUrl = 'https://github.com/user/repo.git';
      const branch = 'develop';
      const token = 'ABC123';
      const expectedCommand =
          'git clone -b develop https://x-access-token:ABC123@github.com/user/repo.git';

      final command = cloneCommand(repoUrl, branch, token);

      expect(command, equals(expectedCommand));
    });
  });
}
