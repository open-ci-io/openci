class FADService {
  String testers(List<String>? testers) {
    if (testers == null || testers.isEmpty) {
      return '';
    }

    return '--testers "${testers.join(', ')}"';
  }
}
