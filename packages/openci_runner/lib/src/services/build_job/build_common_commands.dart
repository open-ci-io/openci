class BuildCommonCommands {
  static String get loadZshrc => 'source ~/.zshrc';
  static String navigateToAppDirectory(String appName) =>
      'cd ~/Downloads/$appName';

  static String generateDartDefines(List<String>? dartDefines) {
    if (dartDefines == null) {
      return '';
    }
    return dartDefines.map((e) => '--dart-define=$e').join(' ');
  }
}
