enum OpenCIAppDistributionTarget {
  none,
  firebaseAppDistribution,
  testflight;

  String get name => switch (this) {
        none => 'None',
        firebaseAppDistribution => 'Firebase App Distribution',
        testflight => 'Test Flight',
      };
}
