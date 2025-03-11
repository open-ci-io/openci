enum OpenCIWorkflowTemplate {
  ipa,
  blank;

  String get title {
    switch (this) {
      case OpenCIWorkflowTemplate.ipa:
        return 'Release iOS App';
      case OpenCIWorkflowTemplate.blank:
        return 'From Scratch';
    }
  }
}
