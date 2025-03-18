import 'package:freezed_annotation/freezed_annotation.dart';

part 'github_repository.freezed.dart';
part 'github_repository.g.dart';

@freezed
class GithubRepository with _$GithubRepository {
  const factory GithubRepository({
    required String selectedRepository,
    required List<String> repositories,
  }) = _GithubRepository;
  factory GithubRepository.fromJson(Map<String, Object?> json) =>
      _$GithubRepositoryFromJson(json);
}
